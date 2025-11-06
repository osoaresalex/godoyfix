<?php

/**
 * Script temporário para executar migrations na Railway
 * DELETAR após uso por questões de segurança
 */

require __DIR__.'/vendor/autoload.php';

$app = require_once __DIR__.'/bootstrap/app.php';

$kernel = $app->make(Illuminate\Contracts\Console\Kernel::class);

echo "=== Executando Migrations ===\n\n";

$status = $kernel->call('migrate', [
    '--force' => true,
    '--no-interaction' => true
]);

echo "\n=== Migrations Concluídas ===\n";
echo "Status: " . ($status === 0 ? 'SUCESSO' : 'ERRO') . "\n";

// Verificar tabelas criadas
echo "\n=== Verificando Tabelas ===\n";
try {
    $tables = DB::select('SHOW TABLES');
    echo "Total de tabelas: " . count($tables) . "\n";
    foreach ($tables as $table) {
        $tableName = array_values((array)$table)[0];
        echo "  - {$tableName}\n";
    }
} catch (Exception $e) {
    echo "Erro ao listar tabelas: " . $e->getMessage() . "\n";
}

echo "\n=== FIM ===\n";
