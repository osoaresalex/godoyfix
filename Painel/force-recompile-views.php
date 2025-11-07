<?php
// AGGRESSIVE force recompile all Blade views

echo "========================================\n";
echo "FORCING VIEW RECOMPILATION\n";
echo "========================================\n\n";

// Delete ALL compiled views BEFORE loading Laravel
$viewPath = __DIR__ . '/storage/framework/views';
echo "1. Deleting compiled views from: $viewPath\n";

if (is_dir($viewPath)) {
    $files = glob($viewPath . '/*');
    $deleted = 0;
    foreach ($files as $file) {
        if (is_file($file)) {
            unlink($file);
            $deleted++;
        }
    }
    echo "   Deleted $deleted compiled view files\n\n";
}

// Delete bootstrap cache
$bootstrapCache = __DIR__ . '/bootstrap/cache';
if (is_dir($bootstrapCache)) {
    $files = glob($bootstrapCache . '/*.php');
    foreach ($files as $file) {
        if (is_file($file)) {
            unlink($file);
            echo "   Deleted: " . basename($file) . "\n";
        }
    }
}

echo "\n2. Loading Laravel...\n";
require __DIR__.'/vendor/autoload.php';

$app = require_once __DIR__.'/bootstrap/app.php';
$app->make('Illuminate\Contracts\Console\Kernel')->bootstrap();

// Clear ALL Laravel caches
echo "\n3. Clearing all Laravel caches...\n";
Artisan::call('cache:clear');
echo "   Cache cleared\n";
Artisan::call('view:clear');
echo "   View cache cleared\n";
Artisan::call('config:clear');
echo "   Config cache cleared\n";
Artisan::call('route:clear');
echo "   Route cache cleared\n";

// Touch all blade files to make them "newer" than any compiled versions
echo "\n4. Touching all Blade files to force recompilation...\n";
$iterator = new RecursiveIteratorIterator(
    new RecursiveDirectoryIterator(base_path('Modules'), RecursiveDirectoryIterator::SKIP_DOTS),
    RecursiveIteratorIterator::SELF_FIRST
);

$touched = 0;
foreach ($iterator as $file) {
    if ($file->isFile() && strpos($file->getFilename(), '.blade.php') !== false) {
        touch($file->getPathname());
        $touched++;
    }
}
echo "   Touched $touched Blade files\n";

echo "\n========================================\n";
echo "DONE! Views will be recompiled on next request.\n";
echo "========================================\n";
