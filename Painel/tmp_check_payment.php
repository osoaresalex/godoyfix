<?php
// Usage: php tmp_check_payment.php <payment_id>

use Modules\PaymentModule\Entities\PaymentRequest;

require __DIR__.'/vendor/autoload.php';
$app = require __DIR__.'/bootstrap/app.php';
$kernel = $app->make(Illuminate\Contracts\Console\Kernel::class);
$kernel->bootstrap();

$id = $argv[1] ?? null;
if (!$id) {
    fwrite(STDERR, "Provide payment_id as first argument\n");
    exit(1);
}

$p = PaymentRequest::find($id);
if (!$p) {
    echo "PaymentRequest not found\n";
    exit(2);
}

echo json_encode([
    'id' => $p->id,
    'is_paid' => (int)$p->is_paid,
    'payment_method' => $p->payment_method,
    'transaction_id' => $p->transaction_id,
    'updated_at' => (string)$p->updated_at,
], JSON_PRETTY_PRINT), "\n";
