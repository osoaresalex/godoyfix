<?php
/**
 * Executor de migrations - Sem middleware Laravel
 * Acessível apenas via migrate.html
 */

// Impedir acesso direto
if (!isset($_SERVER['HTTP_REFERER']) || strpos($_SERVER['HTTP_REFERER'], 'migrate.html') === false) {
    http_response_code(403);
    die('Access denied');
}

// Subir para chegar em /app/Painel
chdir(__DIR__ . '/..');

require __DIR__.'/../vendor/autoload.php';

$app = require_once __DIR__.'/../bootstrap/app.php';
$kernel = $app->make(Illuminate\Contracts\Console\Kernel::class);
$kernel->bootstrap();

header('Content-Type: text/html; charset=utf-8');

echo '<div class="section">';
echo '<h2 class="info">1️⃣ Conexão com Banco de Dados</h2>';

try {
    DB::connection()->getPdo();
    $dbName = DB::connection()->getDatabaseName();
    echo '<div class="success">✅ Conectado ao MySQL!</div>';
    echo '<div class="info">📊 Database: <strong>' . htmlspecialchars($dbName) . '</strong></div>';
    
    // Info do servidor
    $serverVersion = DB::select("SELECT VERSION() as version")[0]->version;
    echo '<div class="info">🔧 MySQL Version: ' . htmlspecialchars($serverVersion) . '</div>';
} catch (Exception $e) {
    echo '<div class="error">❌ ERRO: ' . htmlspecialchars($e->getMessage()) . '</div>';
    echo '</div>';
    exit;
}
echo '</div>';

// Executar migrations
echo '<div class="section">';
echo '<h2 class="info">2️⃣ Executando Migrations</h2>';
echo '<pre style="color: #51cf66;">';

ob_start();
try {
    $exitCode = Artisan::call('migrate', [
        '--force' => true,
        '--no-interaction' => true
    ]);
    
    $output = Artisan::output();
    echo htmlspecialchars($output);
    
    if ($exitCode === 0) {
        echo "</pre><div class='success'>✅ Migrations executadas!</div>";
    } else {
        echo "</pre><div class='warning'>⚠️ Exit code: {$exitCode}</div>";
    }
} catch (Exception $e) {
    ob_end_clean();
    echo "</pre><div class='error'>❌ ERRO: " . htmlspecialchars($e->getMessage()) . "</div>";
    echo "<pre>" . htmlspecialchars($e->getTraceAsString()) . "</pre>";
}
echo '</div>';

// Listar tabelas
echo '<div class="section">';
echo '<h2 class="info">3️⃣ Tabelas Criadas</h2>';

try {
    $tables = DB::select('SHOW TABLES');
    echo '<div class="success">Total: ' . count($tables) . ' tabelas</div>';
    echo '<ul style="margin-left: 20px; margin-top: 10px;">';
    
    $important = ['users', 'payment_requests', 'addon_settings', 'migrations', 'bookings'];
    
    foreach ($tables as $table) {
        $tableName = array_values((array)$table)[0];
        $color = in_array($tableName, $important) ? '#ffd43b' : '#51cf66';
        $emoji = in_array($tableName, $important) ? '⭐' : '•';
        echo "<li style='color:{$color}'>{$emoji} {$tableName}</li>";
    }
    echo '</ul>';
    
    // Contar registros em tabelas importantes
    echo '<h3 style="margin-top: 20px; color: #74c0fc;">📊 Registros nas Tabelas Principais</h3>';
    echo '<ul style="margin-left: 20px;">';
    foreach ($important as $table) {
        try {
            $count = DB::table($table)->count();
            echo "<li class='info'>{$table}: <strong>{$count}</strong> registros</li>";
        } catch (Exception $e) {
            echo "<li class='warning'>{$table}: tabela não existe ainda</li>";
        }
    }
    echo '</ul>';
} catch (Exception $e) {
    echo '<div class="error">❌ Erro: ' . htmlspecialchars($e->getMessage()) . '</div>';
}
echo '</div>';

// Verificar Mercado Pago
echo '<div class="section">';
echo '<h2 class="info">4️⃣ Configuração Mercado Pago PIX</h2>';

try {
    $mpConfig = DB::table('addon_settings')
        ->where('key_name', 'mercadopago_pix')
        ->first();
    
    if ($mpConfig) {
        echo '<div class="success">✅ Configuração PIX encontrada!</div>';
        $settings = json_decode($mpConfig->settings_value ?? '{}', true);
        echo '<pre>' . htmlspecialchars(json_encode($settings, JSON_PRETTY_PRINT)) . '</pre>';
    } else {
        echo '<div class="warning">⚠️ Configuração PIX não encontrada</div>';
        echo '<div class="info">💡 Configure via painel admin após login</div>';
    }
} catch (Exception $e) {
    echo '<div class="warning">⚠️ Tabela addon_settings não existe: ' . htmlspecialchars($e->getMessage()) . '</div>';
}
echo '</div>';

// Verificar variáveis de ambiente
echo '<div class="section">';
echo '<h2 class="info">5️⃣ Variáveis de Ambiente</h2>';
echo '<ul style="margin-left: 20px;">';
echo '<li class="info">APP_ENV: <strong>' . env('APP_ENV') . '</strong></li>';
echo '<li class="info">APP_DEBUG: <strong>' . (env('APP_DEBUG') ? 'true' : 'false') . '</strong></li>';
echo '<li class="info">DB_CONNECTION: <strong>' . env('DB_CONNECTION') . '</strong></li>';
echo '<li class="info">DB_DATABASE: <strong>' . env('DB_DATABASE') . '</strong></li>';
echo '<li class="info">APP_URL: <strong>' . env('APP_URL') . '</strong></li>';
$tokenSet = env('MERCADOPAGO_ACCESS_TOKEN') ? 'Configurado ✅' : 'Não configurado ❌';
echo '<li class="' . (env('MERCADOPAGO_ACCESS_TOKEN') ? 'success' : 'error') . '">MERCADOPAGO_ACCESS_TOKEN: <strong>' . $tokenSet . '</strong></li>';
echo '</ul>';
echo '</div>';

echo '<div class="section" style="text-align: center;">';
echo '<h2 class="success" style="font-size: 24px;">🎉 PROCESSO CONCLUÍDO!</h2>';
echo '<div class="warning" style="margin-top: 10px;">⚠️ DELETAR migrate.html e migrate_exec.php após uso!</div>';
echo '</div>';
