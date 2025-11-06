<?php
/**
 * Teste direto da API do Mercado Pago
 */

require __DIR__.'/vendor/autoload.php';

$app = require_once __DIR__.'/bootstrap/app.php';
$app->make('Illuminate\Contracts\Console\Kernel')->bootstrap();

use MercadoPago\MercadoPagoConfig;
use MercadoPago\Client\Payment\PaymentClient;
use MercadoPago\Exceptions\MPApiException;

echo "🧪 TESTE DIRETO DA API MERCADO PAGO\n";
echo "=====================================\n\n";

$token = env('MERCADOPAGO_ACCESS_TOKEN');

if (empty($token)) {
    echo "❌ Token não encontrado no .env\n";
    exit(1);
}

echo "Token: " . substr($token, 0, 30) . "...\n\n";

try {
    MercadoPagoConfig::setAccessToken($token);
    
    $client = new PaymentClient();
    
    $payload = [
        'transaction_amount' => 1.00,
        'description' => 'Test Payment',
        'payment_method_id' => 'pix',
        'payer' => [
            'email' => 'test@example.com',
            'first_name' => 'Test'
        ]
    ];
    
    echo "📤 Enviando requisição...\n";
    echo "Payload: " . json_encode($payload, JSON_PRETTY_PRINT) . "\n\n";
    
    $payment = $client->create($payload);
    
    echo "✅ SUCESSO!\n\n";
    echo "Payment ID: {$payment->id}\n";
    echo "Status: {$payment->status}\n";
    
    if (isset($payment->point_of_interaction->transaction_data->qr_code)) {
        echo "\n✅ QR Code gerado:\n";
        echo "QR Code: " . substr($payment->point_of_interaction->transaction_data->qr_code, 0, 50) . "...\n";
        echo "QR Code Base64: " . substr($payment->point_of_interaction->transaction_data->qr_code_base64, 0, 50) . "...\n";
    }
    
} catch (MPApiException $e) {
    echo "❌ ERRO DA API MERCADO PAGO\n\n";
    echo "Message: " . $e->getMessage() . "\n";
    echo "Status Code: " . $e->getStatusCode() . "\n\n";
    
    $apiResponse = $e->getApiResponse();
    if ($apiResponse) {
        echo "API Response:\n";
        echo json_encode($apiResponse, JSON_PRETTY_PRINT) . "\n";
    }
    
    echo "\n";
    echo "💡 Possíveis causas:\n";
    echo "   1. Token inválido ou expirado\n";
    echo "   2. Token de produção quando deveria ser teste (ou vice-versa)\n";
    echo "   3. Conta Mercado Pago não configurada para PIX\n";
    echo "   4. Limite de requisições atingido\n";
    
} catch (\Exception $e) {
    echo "❌ ERRO GERAL\n\n";
    echo "Message: " . $e->getMessage() . "\n";
    echo "File: " . $e->getFile() . ":" . $e->getLine() . "\n";
}
