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

    // Do not call realpath() here because it returns false when the
    // target directory doesn't yet exist (causes "Please provide a valid
    // cache path" during early boot). Use the storage path directly so
    // Laravel can create/resolve it later at runtime.
    'compiled' => env('VIEW_CACHE_DISABLED', false)
        ? null
        : env('VIEW_COMPILED_PATH', storage_path('framework/views')),

];
