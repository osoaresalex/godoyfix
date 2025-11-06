<?php
/**
 * Script para atualizar o domínio do ngrok em todos os lugares necessários
 * Uso: php update_ngrok_domain.php https://SEU-DOMINIO.ngrok-free.app
 */

if ($argc < 2) {
    echo "❌ Uso: php update_ngrok_domain.php https://SEU-DOMINIO.ngrok-free.app\n";
    exit(1);
}

$new_domain = rtrim($argv[1], '/');

// Validar se é uma URL válida
if (!filter_var($new_domain, FILTER_VALIDATE_URL)) {
    echo "❌ URL inválida: $new_domain\n";
    exit(1);
}

echo "🔄 Atualizando domínio para: $new_domain\n\n";

// 1. Atualizar .env do backend
$env_file = __DIR__ . '/.env';
if (file_exists($env_file)) {
    $env_content = file_get_contents($env_file);
    
    // Atualizar APP_URL
    $env_content = preg_replace(
        '/APP_URL=https?:\/\/[^\s]+\.ngrok-free\.app/',
        "APP_URL=$new_domain",
        $env_content
    );
    
    // Atualizar ASSET_URL
    $env_content = preg_replace(
        '/ASSET_URL=https?:\/\/[^\s]+\.ngrok-free\.app/',
        "ASSET_URL=$new_domain",
        $env_content
    );
    
    file_put_contents($env_file, $env_content);
    echo "✅ Backend .env atualizado\n";
} else {
    echo "⚠️  Arquivo .env não encontrado\n";
}

// 2. Atualizar app_constants.dart do Flutter
$flutter_constants = __DIR__ . '/../lib/utils/app_constants.dart';
if (file_exists($flutter_constants)) {
    $constants_content = file_get_contents($flutter_constants);
    
    $constants_content = preg_replace(
        '/static const String baseUrl = ["\']https?:\/\/[^\s]+\.ngrok-free\.app["\']/i',
        "static const String baseUrl = '$new_domain'",
        $constants_content
    );
    
    file_put_contents($flutter_constants, $constants_content);
    echo "✅ Flutter app_constants.dart atualizado\n";
} else {
    echo "⚠️  Arquivo app_constants.dart não encontrado em: $flutter_constants\n";
}

// 3. Limpar cache do Laravel
echo "\n🧹 Limpando cache do Laravel...\n";
passthru('php artisan config:clear');
passthru('php artisan cache:clear');

echo "\n✨ Domínio atualizado com sucesso!\n";
echo "📝 Novo domínio: $new_domain\n\n";
echo "⚡ Próximos passos:\n";
echo "   1. Certifique-se que o servidor Laravel está rodando: php artisan serve --host=127.0.0.1 --port=8000\n";
echo "   2. Gere um novo pagamento de teste: php tmp_pix_create.php\n";
echo "   3. Configure o webhook no Mercado Pago para: $new_domain/payment/mercadopago_pix/webhook\n\n";
