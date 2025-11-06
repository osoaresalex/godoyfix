<?php

namespace Modules\PaymentModule\Http\Controllers;

use Illuminate\Contracts\Foundation\Application;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Routing\Controller;
use Illuminate\Routing\Redirector;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Validator;
use MercadoPago\Client\Payment\PaymentClient;
use MercadoPago\Exceptions\MPApiException;
use MercadoPago\MercadoPagoConfig;
use Modules\PaymentModule\Entities\PaymentRequest;
use Modules\PaymentModule\Traits\Processor;

class MercadoPagoPixController extends Controller
{
    use Processor;

    private PaymentRequest $payment;

    public function __construct(PaymentRequest $payment)
    {
        $this->payment = $payment;

        // Load config from addon_settings
        $config = $this->payment_config('mercadopago_pix', 'payment_config');
        $mp = null;
        if (!is_null($config) && $config->mode == 'live') {
            $mp = json_decode($config->live_values);
        } elseif (!is_null($config) && $config->mode == 'test') {
            $mp = json_decode($config->test_values);
        }

        // Prefer configured token, fallback to env if missing
        $accessToken = null;
        if ($mp && isset($mp->access_token)) {
            $accessToken = $mp->access_token;
        } else {
            $accessToken = env('MERCADOPAGO_ACCESS_TOKEN');
        }
        
        if (!empty($accessToken)) {
            MercadoPagoConfig::setAccessToken($accessToken);
        }
    }

    public function index(Request $request)
    {
        // UX amigável: se acessar via GET sem payment_id, mostrar instrução
        if ($request->isMethod('get') && !$request->has('payment_id')) {
            return view('paymentmodule::mercado-pago-pix-invalid');
        }

        $validator = Validator::make($request->all(), [
            'payment_id' => 'required|uuid'
        ]);

        if ($validator->fails()) {
            // Se for navegação web (HTML), renderizar tela amigável em vez de JSON 400
            if ($request->isMethod('get') && !$request->expectsJson() && !$request->wantsJson()) {
                return view('paymentmodule::mercado-pago-pix-invalid');
            }
            return response()->json($this->response_formatter(GATEWAYS_DEFAULT_400, null, $this->error_processor($validator)), 400);
        }

        $data = $this->payment::where(['id' => $request['payment_id']])->where(['is_paid' => 0])->first();
        if (!isset($data)) {
            return response()->json($this->response_formatter(GATEWAYS_DEFAULT_204), 200);
        }

        $payer = json_decode($data['payer_information']);

        try {
            $client = new PaymentClient();
            $payload = [
                'transaction_amount' => (float)$data->payment_amount,
                'description' => 'Payment #' . $data->attribute_id,
                'payment_method_id' => 'pix',
                'external_reference' => (string)$data->id,
                'payer' => [
                    'email' => $payer->email ?? 'pix@example.com',
                    'first_name' => $payer->name ?? 'Customer'
                ],
                'notification_url' => route('mercadopago_pix.webhook'),
            ];

            $mpPayment = $client->create($payload);

            // Save MP payment id for traceability (not marking paid yet)
            $data->transaction_id = $mpPayment->id;
            $data->payment_method = 'mercadopago_pix';
            $data->save();

            $qr = $mpPayment->point_of_interaction->transaction_data ?? null;
            $qrCodeBase64 = $qr->qr_code_base64 ?? null;
            $qrCode = $qr->qr_code ?? null;

            $business_name = (business_config('business_name', 'business_information'))->live_values ?? 'my_business';
            $business_logo = getBusinessSettingsImageFullPath(
                key: 'business_logo', settingType: 'business_information', path: 'business/', defaultPath: 'public/assets/admin-module/img/placeholder.png'
            );

            return view('paymentmodule::mercado-pago-pix', compact('data', 'qrCodeBase64', 'qrCode', 'business_name', 'business_logo'));
        } catch (MPApiException $e) {
            $apiResp = method_exists($e, 'getApiResponse') ? $e->getApiResponse() : null;
            $statusCode = method_exists($apiResp, 'getStatusCode') ? $apiResp->getStatusCode() : 'N/A';
            $content = method_exists($apiResp, 'getContent') ? $apiResp->getContent() : [];
            
            Log::error('MercadoPago PIX create error: ' . $e->getMessage(), [
                'status_code' => $statusCode,
                'api_response_content' => $content,
                'api_response_object' => $apiResp,
            ]);
            $paymentData = $this->payment::where(['id' => $request['payment_id']])->first();
            if (isset($paymentData) && function_exists($paymentData->failure_hook)) {
                call_user_func($paymentData->failure_hook, $paymentData);
            }
            return $this->payment_response($paymentData, 'fail');
        } catch (\Exception $e) {
            Log::error('MercadoPago PIX unexpected error: ' . $e->getMessage());
            $paymentData = $this->payment::where(['id' => $request['payment_id']])->first();
            if (isset($paymentData) && function_exists($paymentData->failure_hook)) {
                call_user_func($paymentData->failure_hook, $paymentData);
            }
            return $this->payment_response($paymentData, 'fail');
        }
    }

    public function webhook(Request $request): JsonResponse
    {
        try {
            Log::info('MercadoPago PIX webhook received', [
                'type' => $request->get('type') ?? $request->input('action'),
                'payload' => $request->all(),
            ]);
            // Mercado Pago will send notifications with type "payment" and data.id
            $type = $request->get('type') ?? $request->input('action');
            $id = data_get($request->all(), 'data.id');

            if ($type === 'payment' && $id) {
                $client = new PaymentClient();
                $payment = $client->get($id);

                // Retrieve our PaymentRequest via external_reference (we set it as our payment_request id)
                $externalRef = $payment->external_reference ?? null;
                if ($externalRef) {
                    $data = $this->payment::where(['id' => $externalRef])->first();
                    if ($data && strtolower($payment->status) === 'approved' && (int)$data->is_paid === 0) {
                        $data->is_paid = 1;
                        $data->payment_method = 'mercadopago_pix';
                        $data->transaction_id = $payment->id;
                        $data->save();

                        Log::info('MercadoPago PIX marked as paid', [
                            'payment_request_id' => $data->id,
                            'mp_payment_id' => $payment->id,
                            'status' => $payment->status,
                        ]);

                        if (isset($data) && function_exists($data->success_hook)) {
                            call_user_func($data->success_hook, $data);
                        }
                    }
                }
            }
        } catch (MPApiException $e) {
            Log::error('MercadoPago PIX webhook error: ' . $e->getMessage());
        } catch (\Exception $e) {
            Log::error('MercadoPago PIX webhook unexpected error: ' . $e->getMessage());
        }

        return response()->json(['status' => 'ok']);
    }

    public function checkStatus(Request $request): JsonResponse
    {
        $validator = Validator::make($request->all(), [
            'payment_id' => 'required|uuid'
        ]);
        if ($validator->fails()) {
            return response()->json($this->response_formatter(GATEWAYS_DEFAULT_400, null, $this->error_processor($validator)), 400);
        }

        $data = $this->payment::find($request['payment_id']);
        $paid = (bool)($data?->is_paid ?? 0);
        $redirect = $paid ? route('mercadopago_pix.redirect-success', ['payment_id' => $data->id]) : null;
        return response()->json(['paid' => $paid, 'redirect' => $redirect]);
    }

    public function redirectSuccess(Request $request): Application|JsonResponse|Redirector|RedirectResponse
    {
        $validator = Validator::make($request->all(), [
            'payment_id' => 'required|uuid'
        ]);
        if ($validator->fails()) {
            return response()->json($this->response_formatter(GATEWAYS_DEFAULT_400, null, $this->error_processor($validator)), 400);
        }
        $data = $this->payment::find($request['payment_id']);
        if ($data && (int)$data->is_paid === 1) {
            return $this->payment_response($data, 'success');
        }
        return $this->payment_response($data, 'fail');
    }
}
