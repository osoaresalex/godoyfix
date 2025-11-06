<?php
/**
 * Import Database Schema na Railway
 * Executa o SQL do arquivo railway_schema.sql
 */

header('Content-Type: text/html; charset=utf-8');
set_time_limit(600); // 10 minutos

$isAjax = isset($_GET['action']) && $_GET['action'] === 'import';

if (!$isAjax) {
    ?>
    <!DOCTYPE html>
    <html>
    <head>
        <meta charset="UTF-8">
        <title>Import Schema</title>
        <style>
            body { font-family: monospace; background: #1a1a1a; color: #00ff00; padding: 20px; }
            .container { max-width: 900px; margin: 0 auto; background: #2d2d2d; padding: 30px; border-radius: 10px; }
            h1 { color: #ffd700; text-align: center; }
            button { background: #00ff00; color: #000; border: none; padding: 15px 30px; font-size: 18px; 
                     border-radius: 5px; cursor: pointer; display: block; margin: 20px auto; font-weight: bold; }
            #result { margin-top: 20px; white-space: pre-wrap; }
            .success { color: #51cf66; }
            .error { color: #ff6b6b; }
            .info { color: #74c0fc; }
        </style>
    </head>
    <body>
        <div class="container">
            <h1>📥 Import Database Schema</h1>
            <div class="info">
                <p>Este script irá:</p>
                <ul>
                    <li>✅ Dropar tabelas existentes</li>
                    <li>✅ Criar 112 tabelas do schema</li>
                    <li>✅ Configurar chaves estrangeiras</li>
                </ul>
            </div>
            <button onclick="run()">▶️ IMPORTAR SCHEMA AGORA</button>
            <div id="result"></div>
        </div>
        <script>
            async function run() {
                const btn = document.querySelector('button');
                const result = document.getElementById('result');
                
                btn.disabled = true;
                btn.textContent = '⏳ Importando...';
                result.innerHTML = '<div class="info">Iniciando importação...</div>';
                
                try {
                    const response = await fetch('?action=import');
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

// ==================== EXECUTAR IMPORT ====================

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
    echo "<div class='error'>❌ Erro: " . htmlspecialchars($e->getMessage()) . "</div>";
    exit;
}

// Verificar conexão
echo "<div class='info'>⏳ Conectando ao banco Railway...</div>";
flush();

try {
    DB::connection()->getPdo();
    $db = DB::connection()->getDatabaseName();
    echo "<div class='success'>✅ Conectado: {$db}</div>";
    flush();
} catch (Exception $e) {
    echo "<div class='error'>❌ Falha: " . htmlspecialchars($e->getMessage()) . "</div>";
    exit;
}

// Ler arquivo SQL
$sqlFile = __DIR__ . '/railway_schema.sql';

if (!file_exists($sqlFile)) {
    echo "<div class='error'>❌ Arquivo railway_schema.sql não encontrado!</div>";
    echo "<div class='info'>Por favor, execute export_schema.php primeiro localmente e faça upload do arquivo.</div>";
    exit;
}

echo "<div class='info'>⏳ Lendo schema SQL...</div>";
$sql = file_get_contents($sqlFile);
$size = filesize($sqlFile) / 1024;
echo "<div class='success'>✅ Arquivo lido: " . number_format($size, 2) . " KB</div>";
flush();

// Executar SQL
echo "<div class='info'>⏳ Executando importação (pode demorar 2-3 minutos)...</div>";
flush();

try {
    // Split por statement (ponto e vírgula + nova linha)
    $statements = array_filter(
        explode(";\n", $sql),
        function($stmt) {
            $clean = trim($stmt);
            return !empty($clean) && !str_starts_with($clean, '--');
        }
    );
    
    $total = count($statements);
    $success = 0;
    $errors = 0;
    
    echo "<div class='info'>Total de statements: {$total}</div>";
    flush();
    
    foreach ($statements as $i => $statement) {
        $stmt = trim($statement);
        if (empty($stmt)) continue;
        
        try {
            DB::unprepared($stmt);
            $success++;
            
            // Mostrar progresso a cada 10 statements
            if ($i % 10 == 0) {
                $progress = round(($i / $total) * 100);
                echo "<div class='info'>{$progress}% - {$success} statements executados...</div>";
                flush();
            }
        } catch (Exception $e) {
            $errors++;
            // Ignorar erros de DROP TABLE IF NOT EXISTS
            if (!str_contains($e->getMessage(), 'DROP TABLE')) {
                echo "<div class='error'>Aviso: " . htmlspecialchars($e->getMessage()) . "</div>";
            }
        }
    }
    
    echo "<div class='success'>✅ Importação concluída!</div>";
    echo "<div class='info'>Sucesso: {$success} | Erros: {$errors}</div>";
    flush();
    
} catch (Exception $e) {
    echo "<div class='error'>❌ Erro fatal: " . htmlspecialchars($e->getMessage()) . "</div>";
    exit;
}

// Verificar tabelas criadas
echo "<div class='info'>⏳ Verificando tabelas...</div>";
flush();

try {
    $tables = DB::select('SHOW TABLES');
    echo "<div class='success'>✅ Total de tabelas: " . count($tables) . "</div>";
    
    $important = ['users', 'payment_requests', 'addon_settings', 'bookings', 'providers'];
    echo "<div class='info'>Tabelas importantes: ";
    
    $found = [];
    foreach ($tables as $table) {
        $name = array_values((array)$table)[0];
        if (in_array($name, $important)) {
            $found[] = $name;
        }
    }
    echo implode(', ', $found) . "</div>";
    
} catch (Exception $e) {
    echo "<div class='error'>Erro: " . htmlspecialchars($e->getMessage()) . "</div>";
}

echo "<div class='success' style='font-size: 20px; margin-top: 20px;'>🎉 BANCO CONFIGURADO!</div>";
echo "<div class='error'>⚠️ DELETAR import_schema.php e railway_schema.sql após uso!</div>";
?>
