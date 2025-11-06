<?php
// Bootstrap Laravel app and create a test customer + payment request for PIX (add_fund)

use Illuminate\Support\Str;
use Modules\PaymentModule\Entities\PaymentRequest;
use Modules\UserManagement\Entities\User;

require __DIR__.'/vendor/autoload.php';
$app = require __DIR__.'/bootstrap/app.php';

$kernel = $app->make(Illuminate\Contracts\Console\Kernel::class);
$kernel->bootstrap();

// 1) Create or reuse a test customer
$email = 'pix.test.'.date('Ymd_His').'@example.com';
$user = new User();
$user->first_name = 'PIX';
$user->last_name = 'Tester';
$user->email = $email;
$user->phone = '5500000000000';
$user->password = bcrypt('PixTest#123');
$user->is_active = 1;
$user->user_type = 'customer';
$user->save();

// 2) Create a PaymentRequest for Mercado Pago PIX (add fund)
$payment = new PaymentRequest();
$payment->payer_id = $user->id;
$payment->receiver_id = null;
$payment->payment_amount = 1.00; // BRL 1.00 for test
$payment->currency_code = 'BRL';
$payment->payment_method = 'mercadopago_pix';
$payment->success_hook = 'add_fund_success';
$payment->failure_hook = 'add_fund_fail';
$payment->additional_data = json_encode(['is_add_fund' => 1, 'payment_method' => 'mercadopago_pix', 'payment_platform' => 'web']);
$payment->payer_information = json_encode(['email' => $email, 'name' => 'PIX Tester']);
$payment->payment_platform = 'web';
$payment->save();

$payUrl = url("payment/mercadopago_pix/pay/?payment_id={$payment->id}");

echo "Created test customer: {$user->id} ({$email})\n";
echo "PaymentRequest id: {$payment->id}\n";
echo "Open this URL to generate the PIX QR: {$payUrl}\n";
