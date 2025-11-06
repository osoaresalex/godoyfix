<?php
$app = require __DIR__ . '/bootstrap/app.php';
$kernel = $app->make(Illuminate\Contracts\Console\Kernel::class);
$kernel->bootstrap();

use Illuminate\Support\Facades\DB;

$count = DB::table('addon_settings')
    ->where('key_name', 'mercadopago_pix')
    ->where('settings_type', 'payment_config')
    ->count();

echo $count, PHP_EOL;
