<?php
/**
 * Migration Tool Standalone - Railway
 * Acesso direto sem Laravel routing
 * URL: https://godoyfix-production.up.railway.app/db_migrate.php
 */

// Headers para evitar cache
header('Content-Type: text/html; charset=utf-8');
header('Cache-Control: no-cache, no-store, must-revalidate');

// Verificar se é solicitação AJAX para executar migration
$isAjax = isset($_GET['action']) && $_GET['action'] === 'migrate';

if (!$isAjax) {
    // Renderizar HTML
    ?>
    <!DOCTYPE html>
    <html lang="pt-BR">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Railway Database Migration</title>
        <style>
            * { margin: 0; padding: 0; box-sizing: border-box; }
            body { 
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                min-height: 100vh;
                padding: 20px;
            }
            .container {
                max-width: 1000px;
                margin: 0 auto;
                background: rgba(255, 255, 255, 0.95);
                padding: 40px;
                border-radius: 15px;
                box-shadow: 0 20px 60px rgba(0,0,0,0.3);
            }
            h1 { 
                color: #667eea;
                text-align: center;
                margin-bottom: 30px;
                font-size: 2.5em;
            }
            .info-box {
                background: #e7f5ff;
                border-left: 4px solid #339af0;
                padding: 20px;
                margin: 20px 0;
                border-radius: 5px;
            }
            button {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                border: none;
                padding: 20px 40px;
                font-size: 18px;
                border-radius: 50px;
                cursor: pointer;
                display: block;
                margin: 30px auto;
                font-weight: bold;
                transition: all 0.3s;
                box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4);
            }
            button:hover {
                transform: translateY(-2px);
                box-shadow: 0 6px 20px rgba(102, 126, 234, 0.6);
            }
            button:disabled {
                opacity: 0.6;
                cursor: not-allowed;
                transform: none;
            }
            .loader {
                border: 8px solid #f3f3f3;
                border-top: 8px solid #667eea;
                border-radius: 50%;
                width: 60px;
                height: 60px;
                animation: spin 1s linear infinite;
                margin: 20px auto;
                display: none;
            }
            @keyframes spin {
                0% { transform: rotate(0deg); }
                100% { transform: rotate(360deg); }
            }
            #result {
                margin-top: 30px;
                padding: 20px;
                background: #f8f9fa;
                border-radius: 10px;
                display: none;
            }
            .success { color: #51cf66; font-weight: bold; }
            .error { color: #ff6b6b; font-weight: bold; }
            .warning { color: #ffd43b; font-weight: bold; }
            .section {
                background: white;
                padding: 20px;
                margin: 15px 0;
                border-radius: 8px;
                border-left: 4px solid #667eea;
                box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            }
            pre {
                background: #2d3748;
                color: #68d391;
                padding: 15px;
                border-radius: 5px;
                overflow-x: auto;
                font-size: 13px;
            }
            ul { margin-left: 25px; margin-top: 10px; }
            li { margin: 5px 0; }
        </style>
    </head>
    <body>
        <div class="container">
            <h1>🚀 Railway Database Migration</h1>
            
            <div class="info-box">
                <h3>📋 O que este script faz:</h3>
                <ul>
                    <li>✅ Testa conexão com MySQL Railway</li>
                    <li>✅ Executa todas as migrations pendentes</li>
                    <li>✅ Lista tabelas criadas no banco</li>
                    <li>✅ Verifica configuração do Mercado Pago</li>
                    <li>✅ Mostra variáveis de ambiente configuradas</li>
                </ul>
            </div>

            <button id="migrateBtn" onclick="runMigration()">
                ▶️ EXECUTAR MIGRATIONS AGORA
            </button>
            
            <div class="loader" id="loader"></div>
            
            <div id="result"></div>
        </div>

        <script>
            async function runMigration() {
                const btn = document.getElementById('migrateBtn');
                const loader = document.getElementById('loader');
                const result = document.getElementById('result');
                
                btn.disabled = true;
                btn.textContent = '⏳ Executando migrations...';
                loader.style.display = 'block';
                result.style.display = 'none';
                result.innerHTML = '';
                
                try {
                    const response = await fetch('?action=migrate');
                    const html = await response.text();
                    
                    loader.style.display = 'none';
                    result.innerHTML = html;
                    result.style.display = 'block';
                    btn.textContent = '✅ Concluído!';
                    
                    // Scroll suave até resultado
                    result.scrollIntoView({ behavior: 'smooth', block: 'start' });
                } catch (error) {
                    loader.style.display = 'none';
                    result.innerHTML = '<div class="section"><div class="error">❌ Erro: ' + error + '</div></div>';
                    result.style.display = 'block';
                    btn.textContent = '❌ Erro - Tentar Novamente';
                    btn.disabled = false;
                }
            }
        </script>
    </body>
    </html>
    <?php
    exit;
}

// ==================== EXECUTAR MIGRATION ====================

// Bootstrap Laravel
chdir(__DIR__ . '/..');
require __DIR__.'/../vendor/autoload.php';

try {
    $app = require_once __DIR__.'/../bootstrap/app.php';
    $kernel = $app->make(Illuminate\Contracts\Console\Kernel::class);
    $kernel->bootstrap();
} catch (Exception $e) {
    echo '<div class="section"><div class="error">❌ Erro ao carregar Laravel: ' . htmlspecialchars($e->getMessage()) . '</div></div>';
    exit;
}

// 1. Testar conexão
echo '<div class="section">';
echo '<h2 style="color: #667eea;">1️⃣ Conexão com Banco de Dados</h2>';

try {
    DB::connection()->getPdo();
    $dbName = DB::connection()->getDatabaseName();
    echo '<div class="success">✅ Conectado ao MySQL Railway!</div>';
    echo '<p>📊 Database: <strong>' . htmlspecialchars($dbName) . '</strong></p>';
    
    $version = DB::select("SELECT VERSION() as v")[0]->v;
    echo '<p>🔧 MySQL Version: <strong>' . htmlspecialchars($version) . '</strong></p>';
} catch (Exception $e) {
    echo '<div class="error">❌ FALHA NA CONEXÃO!</div>';
    echo '<pre>' . htmlspecialchars($e->getMessage()) . '</pre>';
    echo '</div>';
    exit;
}
echo '</div>';

// 2. Executar migrations
echo '<div class="section">';
echo '<h2 style="color: #667eea;">2️⃣ Executando Migrations</h2>';
echo '<pre>';

try {
    ob_start();
    $exitCode = Artisan::call('migrate', ['--force' => true]);
    $output = Artisan::output();
    ob_end_clean();
    
    echo htmlspecialchars($output);
    echo '</pre>';
    
    if ($exitCode === 0) {
        echo '<div class="success">✅ Migrations executadas com sucesso!</div>';
    } else {
        echo '<div class="warning">⚠️ Exit code: ' . $exitCode . '</div>';
    }
} catch (Exception $e) {
    ob_end_clean();
    echo '</pre>';
    echo '<div class="error">❌ Erro: ' . htmlspecialchars($e->getMessage()) . '</div>';
}
echo '</div>';

// 3. Listar tabelas
echo '<div class="section">';
echo '<h2 style="color: #667eea;">3️⃣ Tabelas no Banco</h2>';

try {
    $tables = DB::select('SHOW TABLES');
    echo '<p class="success">Total: ' . count($tables) . ' tabelas criadas</p>';
    echo '<ul>';
    
    $important = ['users', 'payment_requests', 'addon_settings', 'bookings', 'migrations'];
    
    foreach ($tables as $table) {
        $name = array_values((array)$table)[0];
        $emoji = in_array($name, $important) ? '⭐' : '•';
        $style = in_array($name, $important) ? 'font-weight:bold;color:#667eea;' : '';
        echo "<li style='{$style}'>{$emoji} {$name}</li>";
    }
    echo '</ul>';
} catch (Exception $e) {
    echo '<div class="error">❌ Erro ao listar tabelas</div>';
}
echo '</div>';

// 4. Contagem de registros
echo '<div class="section">';
echo '<h2 style="color: #667eea;">4️⃣ Registros nas Tabelas</h2>';
echo '<ul>';

$checkTables = ['users', 'payment_requests', 'addon_settings', 'bookings'];
foreach ($checkTables as $table) {
    try {
        $count = DB::table($table)->count();
        echo "<li><strong>{$table}:</strong> {$count} registros</li>";
    } catch (Exception $e) {
        echo "<li class='warning'><strong>{$table}:</strong> não existe</li>";
    }
}
echo '</ul>';
echo '</div>';

// 5. Mercado Pago Config
echo '<div class="section">';
echo '<h2 style="color: #667eea;">5️⃣ Configuração Mercado Pago PIX</h2>';

try {
    $mp = DB::table('addon_settings')->where('key_name', 'mercadopago_pix')->first();
    
    if ($mp) {
        echo '<div class="success">✅ Configuração encontrada!</div>';
    } else {
        echo '<div class="warning">⚠️ Não configurado ainda</div>';
        echo '<p>💡 Configure via admin panel após primeiro login</p>';
    }
} catch (Exception $e) {
    echo '<div class="warning">⚠️ Tabela addon_settings não existe ainda</div>';
}
echo '</div>';

// 6. Environment vars
echo '<div class="section">';
echo '<h2 style="color: #667eea;">6️⃣ Variáveis de Ambiente</h2>';
echo '<ul>';
echo '<li><strong>APP_ENV:</strong> ' . env('APP_ENV') . '</li>';
echo '<li><strong>APP_URL:</strong> ' . env('APP_URL') . '</li>';
echo '<li><strong>DB_CONNECTION:</strong> ' . env('DB_CONNECTION') . '</li>';
echo '<li><strong>DB_DATABASE:</strong> ' . env('DB_DATABASE') . '</li>';

$tokenOk = env('MERCADOPAGO_ACCESS_TOKEN') ? 'Configurado ✅' : 'Faltando ❌';
$tokenClass = env('MERCADOPAGO_ACCESS_TOKEN') ? 'success' : 'error';
echo "<li class='{$tokenClass}'><strong>MERCADOPAGO_ACCESS_TOKEN:</strong> {$tokenOk}</li>";
echo '</ul>';
echo '</div>';

echo '<div class="section" style="text-align:center;background:#d3f9d8;">';
echo '<h2 style="color:#37b24d;font-size:28px;">🎉 MIGRATION CONCLUÍDA!</h2>';
echo '<p style="color:#e67700;margin-top:10px;"><strong>⚠️ DELETAR este arquivo após uso!</strong></p>';
echo '</div>';
?>
