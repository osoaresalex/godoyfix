<?php
use Illuminate\Support\Facades\DB;

require __DIR__.'/vendor/autoload.php';
$app = require __DIR__.'/bootstrap/app.php';
$kernel = $app->make(Illuminate\Contracts\Console\Kernel::class);
$kernel->bootstrap();

$row = DB::table('addon_settings')
    ->where('key_name','mercadopago_pix')
    ->select('mode','is_active','live_values','test_values')
    ->first();

echo json_encode($row, JSON_PRETTY_PRINT), "\n";
