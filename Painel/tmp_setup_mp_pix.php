<?php
// Helper para configurar o access_token do Mercado Pago PIX no banco

use Modules\BusinessSettingsModule\Entities\BusinessSettings;

require __DIR__.'/vendor/autoload.php';
$app = require __DIR__.'/bootstrap/app.php';
$kernel = $app->make(Illuminate\Contracts\Console\Kernel::class);
$kernel->bootstrap();

echo "=== Configuração do Mercado Pago PIX ===\n\n";

// Verificar se já existe
$existing = BusinessSettings::where('key_name', 'mercadopago_pix')
    ->where('settings_type', 'payment_config')
    ->first();

if ($existing) {
    echo "✓ Registro encontrado no banco.\n";
    echo "  Mode: {$existing->mode}\n";
    echo "  Active: " . ($existing->is_active ? 'SIM' : 'NÃO') . "\n\n";
    
    $testValues = json_decode($existing->test_values, true);
    $liveValues = json_decode($existing->live_values, true);
    
    echo "Test access_token: " . ($testValues['access_token'] ?? '(vazio)') . "\n";
    echo "Live access_token: " . ($liveValues['access_token'] ?? '(vazio)') . "\n\n";
} else {
    echo "⚠ Nenhum registro encontrado. Criando...\n";
    
    $setting = new BusinessSettings();
    $setting->key_name = 'mercadopago_pix';
    $setting->settings_type = 'payment_config';
    $setting->mode = 'test';
    $setting->is_active = 1;
    $setting->test_values = json_encode([
        'gateway' => 'mercadopago_pix',
        'mode' => 'test',
        'access_token' => ''
    ]);
    $setting->live_values = json_encode([
        'gateway' => 'mercadopago_pix',
        'mode' => 'live',
        'access_token' => ''
    ]);
    $setting->save();
    
    echo "✓ Registro criado!\n\n";
}

echo "=== Para configurar o access_token ===\n";
echo "1. Acesse: https://1495e2084580.ngrok-free.app/admin/configuration/get-payment-config\n";
echo "2. Encontre 'Mercado Pago PIX'\n";
echo "3. Cole seu access_token (test ou live)\n";
echo "4. Ative o gateway\n";
echo "5. Salve\n\n";

echo "OU execute este comando SQL diretamente:\n\n";
echo "UPDATE addon_settings \n";
echo "SET test_values = JSON_SET(test_values, '$.access_token', 'SEU_TOKEN_AQUI'),\n";
echo "    is_active = 1\n";
echo "WHERE key_name = 'mercadopago_pix' AND settings_type = 'payment_config';\n\n";

echo "Obtenha seu token em: https://www.mercadopago.com.br/developers/panel/credentials\n";
