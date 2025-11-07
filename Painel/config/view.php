<?php

return [

    /*
    |--------------------------------------------------------------------------
    | View Storage Paths
    |--------------------------------------------------------------------------
    |
    | Most templating systems load templates from disk. Here you may specify
    | an array of paths that should be checked for your views. Of course
    | the usual Laravel view path has already been registered for you.
    |
    */

    'paths' => [
        resource_path('views'),
    ],

    /*
    |--------------------------------------------------------------------------
    | Compiled View Path
    |--------------------------------------------------------------------------
    |
    | This option determines where all the compiled Blade templates will be
    | stored for your application. Typically, this is within the storage
    | directory. However, as usual, you are free to change this value.
    |
    */

    // CRITICAL FIX: Prevent "Please provide a valid cache path" error
    // 1. If VIEW_CACHE_DISABLED is true, return null (no compilation)
    // 2. If VIEW_COMPILED_PATH env is set, use it directly
    // 3. Otherwise use storage_path, but verify directory exists first
    // 4. Never use realpath() during config load as it fails if dir doesn't exist yet
    'compiled' => (function() {
        // Priority 1: Check if view caching is explicitly disabled
        if (env('VIEW_CACHE_DISABLED', false) === true || env('VIEW_CACHE_DISABLED') === 'true') {
            return null;
        }
        
        // Priority 2: Use explicit compiled path if provided
        if ($path = env('VIEW_COMPILED_PATH')) {
            return $path;
        }
        
        // Priority 3: Use storage path and ensure directory exists
        $storagePath = storage_path('framework/views');
        
        // Try to create the directory if it doesn't exist
        if (!is_dir($storagePath)) {
            @mkdir($storagePath, 0755, true);
        }
        
        // Only return the path if it exists and is writable, otherwise disable compilation
        return (is_dir($storagePath) && is_writable($storagePath)) ? $storagePath : null;
    })(),

];
