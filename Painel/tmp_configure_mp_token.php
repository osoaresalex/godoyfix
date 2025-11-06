<?php
/**
 * Script para configurar o access_token do Mercado Pago PIX no banco de dados
 * Uso: php tmp_configure_mp_token.php
 */

require __DIR__.'/vendor/autoload.php';

$app = require_once __DIR__.'/bootstrap/app.php';
$app->make('Illuminate\Contracts\Console\Kernel')->bootstrap();

use Illuminate\Support\Facades\DB;

$access_token = env('MERCADOPAGO_ACCESS_TOKEN');

if (empty($access_token)) {
    echo "❌ MERCADOPAGO_ACCESS_TOKEN não encontrado no .env\n";
    echo "Por favor, adicione no .env:\n";
    echo "MERCADOPAGO_ACCESS_TOKEN=SEU_TOKEN_AQUI\n";
    exit(1);
}

echo "🔧 Configurando Mercado Pago PIX...\n";
echo "Token: " . substr($access_token, 0, 20) . "...\n\n";

// Buscar o registro existente
$setting = DB::table('addon_settings')
    ->where('key_name', 'mercadopago_pix')
    ->where('settings_type', 'payment_config')
    ->first();

if ($setting) {
    // Decodificar os JSON values
    $test_values = json_decode($setting->test_values, true) ?: [];
    $live_values = json_decode($setting->live_values, true) ?: [];
    
    // Atualizar o access_token
    $test_values['access_token'] = $access_token;
    $live_values['access_token'] = $access_token;
    
    // Atualizar no banco
    DB::table('addon_settings')
        ->where('key_name', 'mercadopago_pix')
        ->where('settings_type', 'payment_config')
        ->update([
            'test_values' => json_encode($test_values),
            'live_values' => json_encode($live_values),
            'is_active' => 1,
            'updated_at' => now()
        ]);
    
    echo "✅ Access token atualizado no banco de dados!\n";
    echo "   Mode: {$setting->mode}\n";
    echo "   Active: " . ($setting->is_active ? 'SIM' : 'NÃO') . "\n\n";
    
    // Verificar
    $updated = DB::table('addon_settings')
        ->where('key_name', 'mercadopago_pix')
        ->first();
    
    $test = json_decode($updated->test_values, true);
    $live = json_decode($updated->live_values, true);
    
    echo "✓ Test access_token: " . (isset($test['access_token']) && !empty($test['access_token']) ? 'CONFIGURADO' : 'VAZIO') . "\n";
    echo "✓ Live access_token: " . (isset($live['access_token']) && !empty($live['access_token']) ? 'CONFIGURADO' : 'VAZIO') . "\n";
    
} else {
    echo "❌ Registro 'mercadopago_pix' não encontrado no banco.\n";
    echo "Execute primeiro: php tmp_setup_mp_pix.php\n";
    exit(1);
}

echo "\n🎉 Pronto! Agora você pode gerar um novo pagamento de teste:\n";
echo "   php tmp_pix_create.php\n\n";
