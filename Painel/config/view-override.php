<?php

/**
 * View Override Configuration
 * 
 * This file forces the view compiled path to null to prevent
 * "Please provide a valid cache path" errors during Railway deployment.
 * 
 * This is loaded by including it in bootstrap/app.php or by merging
 * with the main view config at runtime.
 */

return [
    'compiled' => null, // Force disable view compilation
];
