<?php
/**
 * Import Schema - Standalone (sem Laravel)
 * Conecta direto no MySQL Railway
 */

// Configurações - PREENCHER COM VALORES DA RAILWAY
$host = getenv('DB_HOST') ?: 'shuttle.proxy.rlwy.net';
$port = getenv('DB_PORT') ?: '40276';
$database = getenv('DB_DATABASE') ?: 'railway';
$username = getenv('DB_USERNAME') ?: 'root';
$password = getenv('DB_PASSWORD') ?: 'HZyrygSuuaAMdwfTocCQPYycdXfAWcvQ';

header('Content-Type: text/html; charset=utf-8');
set_time_limit(600);

$isAjax = isset($_GET['action']) && $_GET['action'] === 'import';

if (!$isAjax) {
    ?>
    <!DOCTYPE html>
    <html><head><meta charset="UTF-8"><title>Direct Import</title>
    <style>body{font-family:monospace;background:#000;color:#0f0;padding:20px;}
    .container{max-width:900px;margin:0 auto;background:#111;padding:30px;border-radius:10px;}
    h1{color:#ff0;text-align:center;}button{background:#0f0;color:#000;border:none;padding:15px 30px;
    font-size:18px;border-radius:5px;cursor:pointer;display:block;margin:20px auto;font-weight:bold;}
    .success{color:#0f0;}.error{color:#f00;}.info{color:#0af;}</style>
    </head><body><div class="container"><h1>⚡ Direct Schema Import</h1>
    <div class="info"><p>Importação direta no MySQL Railway (sem Laravel)</p>
    <ul><li>Host: <?= htmlspecialchars($host) ?></li>
    <li>Database: <?= htmlspecialchars($database) ?></li>
    <li>User: <?= htmlspecialchars($username) ?></li></ul></div>
    <button onclick="run()">▶️ IMPORT AGORA</button>
    <div id="result"></div></div>
    <script>async function run(){const btn=document.querySelector('button');
    const result=document.getElementById('result');btn.disabled=true;btn.textContent='⏳ Importing...';
    result.innerHTML='<div class="info">Starting...</div>';try{const response=await fetch('?action=import');
    const text=await response.text();result.innerHTML=text;btn.textContent='✅ Done';}
    catch(error){result.innerHTML='<div class="error">❌ '+error+'</div>';
    btn.textContent='❌ Error';btn.disabled=false;}}</script></body></html>
    <?php
    exit;
}

// ==================== IMPORT ====================

echo "<div class='info'>⏳ Conectando ao MySQL...</div>";
flush();

try {
    $conn = new PDO(
        "mysql:host={$host};port={$port};dbname={$database};charset=utf8mb4",
        $username,
        $password,
        [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION]
    );
    echo "<div class='success'>✅ Conectado: {$database}@{$host}</div>";
    flush();
} catch (PDOException $e) {
    echo "<div class='error'>❌ Falha: " . htmlspecialchars($e->getMessage()) . "</div>";
    exit;
}

// Ler SQL
$sqlFile = __DIR__ . '/railway_schema.sql';
if (!file_exists($sqlFile)) {
    echo "<div class='error'>❌ railway_schema.sql não encontrado!</div>";
    exit;
}

echo "<div class='info'>⏳ Lendo SQL...</div>";
$sql = file_get_contents($sqlFile);
echo "<div class='success'>✅ " . number_format(filesize($sqlFile)/1024, 2) . " KB lidos</div>";
flush();

// Executar
echo "<div class='info'>⏳ Executando SQL...</div>";
flush();

try {
    $statements = array_filter(
        explode(";\n", $sql),
        fn($s) => !empty(trim($s)) && !str_starts_with(trim($s), '--')
    );
    
    $total = count($statements);
    $success = 0;
    
    foreach ($statements as $i => $stmt) {
        try {
            $conn->exec(trim($stmt));
            $success++;
            if ($i % 20 == 0) {
                $pct = round(($i/$total)*100);
                echo "<div class='info'>{$pct}% ({$success}/{$total})</div>";
                flush();
            }
        } catch (PDOException $e) {
            // Ignorar erros de DROP
            if (!str_contains($e->getMessage(), 'DROP')) {
                echo "<div class='error'>Aviso: " . substr($e->getMessage(), 0, 100) . "...</div>";
            }
        }
    }
    
    echo "<div class='success'>✅ {$success}/{$total} statements executados!</div>";
    flush();
    
} catch (Exception $e) {
    echo "<div class='error'>❌ " . htmlspecialchars($e->getMessage()) . "</div>";
    exit;
}

// Verificar
try {
    $stmt = $conn->query('SHOW TABLES');
    $tables = $stmt->fetchAll(PDO::FETCH_COLUMN);
    echo "<div class='success'>✅ {$count(tables)} tabelas criadas!</div>";
    
    $important = ['users', 'payment_requests', 'addon_settings', 'bookings'];
    $found = array_intersect($important, $tables);
    echo "<div class='info'>Principais: " . implode(', ', $found) . "</div>";
    
} catch (Exception $e) {
    echo "<div class='error'>" . htmlspecialchars($e->getMessage()) . "</div>";
}

echo "<div class='success' style='font-size:24px;margin-top:20px;'>🎉 COMPLETO!</div>";
echo "<div class='error'>⚠️ DELETAR direct_import.php após uso!</div>";
?>
