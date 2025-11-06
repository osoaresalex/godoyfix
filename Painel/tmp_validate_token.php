<?php

require __DIR__.'/vendor/autoload.php';

use MercadoPago\MercadoPagoConfig;
use MercadoPago\Client\Common\RequestOptions;
use GuzzleHttp\Client;

$dotenv = Dotenv\Dotenv::createImmutable(__DIR__);
$dotenv->load();

$token = $_ENV['MERCADOPAGO_ACCESS_TOKEN'] ?? "TOKEN_NAO_ENCONTRADO";

echo "🔍 VALIDANDO TOKEN MERCADO PAGO\n";
echo "=====================================\n\n";
echo "Token: " . substr($token, 0, 20) . "...\n\n";

// Tentar obter informações do usuário autenticado
try {
    $client = new Client();
    $response = $client->get('https://api.mercadopago.com/users/me', [
        'headers' => [
            'Authorization' => 'Bearer ' . $token,
            'Content-Type' => 'application/json'
        ]
    ]);
    
    $data = json_decode($response->getBody(), true);
    
    echo "✅ TOKEN VÁLIDO!\n\n";
    echo "Tipo: " . (strpos($token, 'TEST') !== false ? 'TEST' : 'PRODUCTION') . "\n";
    echo "ID: " . ($data['id'] ?? 'N/A') . "\n";
    echo "Email: " . ($data['email'] ?? 'N/A') . "\n";
    echo "Nickname: " . ($data['nickname'] ?? 'N/A') . "\n";
    echo "Site: " . ($data['site_id'] ?? 'N/A') . "\n";
    
    if (isset($data['live_mode'])) {
        echo "Live Mode: " . ($data['live_mode'] ? 'SIM (PRODUCTION)' : 'NÃO (TEST)') . "\n";
    }
    
} catch (\Exception $e) {
    echo "❌ ERRO AO VALIDAR TOKEN\n\n";
    echo "Message: " . $e->getMessage() . "\n";
    
    if (method_exists($e, 'getResponse')) {
        $response = $e->getResponse();
        if ($response) {
            echo "Status: " . $response->getStatusCode() . "\n";
            echo "Response: " . $response->getBody() . "\n";
        }
    }
}
