<?php
/**
 * Quick Migration Runner - Railway
 * Versão simplificada e rápida
 */

header('Content-Type: text/html; charset=utf-8');
set_time_limit(300); // 5 minutos timeout

$isAjax = isset($_GET['action']) && $_GET['action'] === 'migrate';

if (!$isAjax) {
    ?>
    <!DOCTYPE html>
    <html>
    <head>
        <meta charset="UTF-8">
        <title>Quick Migration</title>
        <style>
            body { font-family: monospace; background: #1a1a1a; color: #00ff00; padding: 20px; }
            .container { max-width: 900px; margin: 0 auto; background: #2d2d2d; padding: 30px; border-radius: 10px; }
            h1 { color: #ffd700; text-align: center; }
            button { background: #00ff00; color: #000; border: none; padding: 15px 30px; font-size: 18px; 
                     border-radius: 5px; cursor: pointer; display: block; margin: 20px auto; font-weight: bold; }
            button:hover { background: #00cc00; }
            #result { margin-top: 20px; white-space: pre-wrap; }
            .success { color: #51cf66; }
            .error { color: #ff6b6b; }
            .info { color: #74c0fc; }
        </style>
    </head>
    <body>
        <div class="container">
            <h1>⚡ Quick Migration Runner</h1>
            <button onclick="run()">▶️ RODAR MIGRATIONS</button>
            <div id="result"></div>
        </div>
        <script>
            async function run() {
                const btn = document.querySelector('button');
                const result = document.getElementById('result');
                
                btn.disabled = true;
                btn.textContent = '⏳ Executando...';
                result.innerHTML = '<div class="info">Iniciando migrations...</div>';
                
                try {
                    const response = await fetch('?action=migrate');
                    const text = await response.text();
                    result.innerHTML = text;
                    btn.textContent = '✅ Concluído';
                } catch (error) {
                    result.innerHTML = '<div class="error">❌ Erro: ' + error + '</div>';
                    btn.textContent = '❌ Erro';
                    btn.disabled = false;
                }
            }
        </script>
    </body>
    </html>
    <?php
    exit;
}

// ==================== EXECUTAR ====================

echo "<div class='info'>⏳ Carregando Laravel...</div>";
flush();

chdir(__DIR__ . '/..');
require __DIR__.'/../vendor/autoload.php';

try {
    $app = require_once __DIR__.'/../bootstrap/app.php';
    $kernel = $app->make(Illuminate\Contracts\Console\Kernel::class);
    $kernel->bootstrap();
    echo "<div class='success'>✅ Laravel carregado!</div>";
    flush();
} catch (Exception $e) {
    echo "<div class='error'>❌ Erro Laravel: " . htmlspecialchars($e->getMessage()) . "</div>";
    exit;
}

// Testar conexão
echo "<div class='info'>⏳ Testando banco...</div>";
flush();

try {
    DB::connection()->getPdo();
    $db = DB::connection()->getDatabaseName();
    echo "<div class='success'>✅ Conectado ao banco: {$db}</div>";
    flush();
} catch (Exception $e) {
    echo "<div class='error'>❌ Falha: " . htmlspecialchars($e->getMessage()) . "</div>";
    exit;
}

// Executar migrations
echo "<div class='info'>⏳ Executando migrations (pode demorar 1-2 minutos)...</div>";
flush();

try {
    // Usar comando direto para melhor performance
    $output = shell_exec('cd ' . escapeshellarg(__DIR__ . '/..') . ' && php artisan migrate --force 2>&1');
    
    echo "<pre>" . htmlspecialchars($output) . "</pre>";
    echo "<div class='success'>✅ Migrations concluídas!</div>";
    flush();
} catch (Exception $e) {
    echo "<div class='error'>❌ Erro: " . htmlspecialchars($e->getMessage()) . "</div>";
}

// Listar tabelas rapidamente
echo "<div class='info'>⏳ Listando tabelas...</div>";
flush();

try {
    $tables = DB::select('SHOW TABLES');
    echo "<div class='success'>Total: " . count($tables) . " tabelas</div>";
    
    // Mostrar apenas as importantes
    $important = ['users', 'payment_requests', 'addon_settings', 'bookings', 'migrations'];
    echo "<div class='info'>Tabelas principais: ";
    
    $found = [];
    foreach ($tables as $table) {
        $name = array_values((array)$table)[0];
        if (in_array($name, $important)) {
            $found[] = $name;
        }
    }
    echo implode(', ', $found) . "</div>";
    
} catch (Exception $e) {
    echo "<div class='error'>Erro ao listar: " . htmlspecialchars($e->getMessage()) . "</div>";
}

echo "<div class='success' style='font-size: 20px; margin-top: 20px;'>🎉 PROCESSO COMPLETO!</div>";
echo "<div class='error'>⚠️ DELETAR quick_migrate.php após uso!</div>";
?>
