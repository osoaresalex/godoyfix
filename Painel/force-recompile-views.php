<?php
// Force recompile all Blade views

require __DIR__.'/vendor/autoload.php';

$app = require_once __DIR__.'/bootstrap/app.php';
$app->make('Illuminate\Contracts\Console\Kernel')->bootstrap();

// Delete all compiled views
$viewPath = storage_path('framework/views');
echo "Deleting compiled views from: $viewPath\n";

if (is_dir($viewPath)) {
    $files = glob($viewPath . '/*');
    foreach ($files as $file) {
        if (is_file($file)) {
            unlink($file);
            echo "Deleted: $file\n";
        }
    }
}

// Clear view cache
Artisan::call('view:clear');
echo "View cache cleared!\n";

// Get all blade files and force recompilation
$bladeFiles = new RecursiveIteratorIterator(
    new RecursiveDirectoryIterator(base_path('Modules'))
);

$recompiled = 0;
foreach ($bladeFiles as $file) {
    if ($file->isFile() && $file->getExtension() === 'php' && strpos($file->getFilename(), '.blade.php') !== false) {
        $viewPath = str_replace(base_path(), '', $file->getPathname());
        $viewPath = str_replace(['\\', '/'], '.', $viewPath);
        $viewPath = str_replace('.Modules.', '', $viewPath);
        $viewPath = str_replace('.Resources.views.', '::', $viewPath);
        $viewPath = str_replace('.blade.php', '', $viewPath);
        
        try {
            // Try to render the view to force compilation
            view($viewPath)->render();
            $recompiled++;
            echo "Recompiled: $viewPath\n";
        } catch (\Exception $e) {
            // Skip views that can't be rendered without data
        }
    }
}

echo "\n=== SUMMARY ===\n";
echo "Total views recompiled: $recompiled\n";
echo "Done!\n";
