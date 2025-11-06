<?php
/**
 * Export Database Schema para Railway
 * Gera arquivo SQL com CREATE TABLE de todas as tabelas
 */

require __DIR__.'/../vendor/autoload.php';

$app = require_once __DIR__.'/../bootstrap/app.php';
$kernel = $app->make(Illuminate\Contracts\Console\Kernel::class);
$kernel->bootstrap();

echo "=== Exportando Schema do Banco Local ===\n\n";

try {
    // Pegar lista de tabelas
    $tables = DB::select('SHOW TABLES');
    $dbName = DB::connection()->getDatabaseName();
    
    echo "Database: {$dbName}\n";
    echo "Total de tabelas: " . count($tables) . "\n\n";
    
    $sql = "-- Database Schema Export\n";
    $sql .= "-- Generated: " . date('Y-m-d H:i:s') . "\n\n";
    $sql .= "SET FOREIGN_KEY_CHECKS=0;\n\n";
    
    foreach ($tables as $table) {
        $tableName = array_values((array)$table)[0];
        echo "Exportando: {$tableName}...\n";
        
        // Pegar CREATE TABLE
        $createTable = DB::select("SHOW CREATE TABLE `{$tableName}`")[0];
        $createStatement = $createTable->{'Create Table'};
        
        $sql .= "-- Table: {$tableName}\n";
        $sql .= "DROP TABLE IF EXISTS `{$tableName}`;\n";
        $sql .= $createStatement . ";\n\n";
    }
    
    $sql .= "SET FOREIGN_KEY_CHECKS=1;\n";
    
    // Salvar arquivo
    $filename = __DIR__ . '/railway_schema.sql';
    file_put_contents($filename, $sql);
    
    echo "\n✅ Schema exportado com sucesso!\n";
    echo "Arquivo: {$filename}\n";
    echo "Tamanho: " . number_format(filesize($filename) / 1024, 2) . " KB\n";
    
} catch (Exception $e) {
    echo "❌ ERRO: " . $e->getMessage() . "\n";
}
