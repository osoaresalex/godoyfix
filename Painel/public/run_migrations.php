<?php

/**
 * Script público para executar migrations
 * Acessível via: https://godoyfix-production.up.railway.app/run_migrations.php
 * DELETAR após uso por segurança
 */

// Subir um diretório para chegar em /app/Painel
require __DIR__.'/../vendor/autoload.php';

$app = require_once __DIR__.'/../bootstrap/app.php';

// Boot Laravel
$kernel = $app->make(Illuminate\Contracts\Console\Kernel::class);
$kernel->bootstrap();

echo "<!DOCTYPE html><html><head><meta charset='UTF-8'><title>Database Migration</title>";
echo "<style>body{font-family:monospace;padding:20px;background:#1e1e1e;color:#00ff00;}";
echo "h1{color:#ff6b6b;}.success{color:#51cf66;}.error{color:#ff6b6b;}.info{color:#339af0;}</style></head><body>";

echo "<h1>🚀 Database Migration - Railway</h1>";
echo "<div class='info'>Timestamp: " . date('Y-m-d H:i:s') . "</div><hr>";

// Verificar conexão com banco
echo "<h2>1️⃣ Testando Conexão com Banco de Dados</h2>";
try {
    DB::connection()->getPdo();
    echo "<div class='success'>✅ Conexão com MySQL estabelecida!</div>";
    
    $dbName = DB::connection()->getDatabaseName();
    echo "<div class='info'>📊 Database: {$dbName}</div>";
} catch (Exception $e) {
    echo "<div class='error'>❌ ERRO ao conectar: " . htmlspecialchars($e->getMessage()) . "</div>";
    echo "</body></html>";
    exit;
}

// Executar migrations
echo "<h2>2️⃣ Executando Migrations</h2>";
echo "<pre style='background:#2d2d2d;padding:15px;border-radius:5px;'>";

try {
    $exitCode = Artisan::call('migrate', [
        '--force' => true,
        '--no-interaction' => true
    ]);
    
    $output = Artisan::output();
    echo htmlspecialchars($output);
    
    if ($exitCode === 0) {
        echo "</pre><div class='success'>✅ Migrations executadas com sucesso!</div>";
    } else {
        echo "</pre><div class='error'>⚠️ Migrations finalizadas com avisos (exit code: {$exitCode})</div>";
    }
} catch (Exception $e) {
    echo "</pre><div class='error'>❌ ERRO nas migrations: " . htmlspecialchars($e->getMessage()) . "</div>";
}

// Listar tabelas criadas
echo "<h2>3️⃣ Verificando Tabelas Criadas</h2>";
echo "<ul>";
try {
    $tables = DB::select('SHOW TABLES');
    $tableCount = count($tables);
    echo "<div class='info'>Total: {$tableCount} tabelas</div><ul>";
    
    foreach ($tables as $table) {
        $tableName = array_values((array)$table)[0];
        
        // Destacar tabelas importantes
        $important = in_array($tableName, ['users', 'payment_requests', 'addon_settings', 'migrations']);
        $color = $important ? '#ffd43b' : '#00ff00';
        
        echo "<li style='color:{$color}'>{$tableName}</li>";
    }
    echo "</ul>";
} catch (Exception $e) {
    echo "<div class='error'>❌ Erro ao listar tabelas: " . htmlspecialchars($e->getMessage()) . "</div>";
}

// Verificar configuração do Mercado Pago
echo "<h2>4️⃣ Verificando Mercado Pago Config</h2>";
try {
    $mpConfig = DB::table('addon_settings')
        ->where('key_name', 'mercadopago_pix')
        ->first();
    
    if ($mpConfig) {
        echo "<div class='success'>✅ Configuração PIX encontrada!</div>";
        echo "<div class='info'>Mode: " . ($mpConfig->live_values ?? 'N/A') . "</div>";
    } else {
        echo "<div class='error'>⚠️ Configuração PIX não encontrada em addon_settings</div>";
        echo "<div class='info'>💡 Será necessário configurar via admin panel</div>";
    }
} catch (Exception $e) {
    echo "<div class='error'>⚠️ Tabela addon_settings ainda não existe (normal em primeira execução)</div>";
}

echo "<hr><div class='success' style='font-size:20px;'>🎉 PROCESSO CONCLUÍDO!</div>";
echo "<div class='info'>⚠️ DELETAR este arquivo após uso: /public/run_migrations.php</div>";
echo "</body></html>";
