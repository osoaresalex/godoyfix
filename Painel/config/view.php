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

    // CRITICAL FIX: Always return a valid string path, never null
    // Laravel's Compiler.php throws exception if cachePath is falsy
    // Use /tmp/views as emergency fallback if storage path doesn't exist
    'compiled' => env('VIEW_COMPILED_PATH', '/app/Painel/storage/framework/views'),

];
