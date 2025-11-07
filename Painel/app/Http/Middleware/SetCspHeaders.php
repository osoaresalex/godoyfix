<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;

class SetCspHeaders
{
    /**
     * Handle an incoming request and set permissive CSP headers for landing pages
     */
    public function handle(Request $request, Closure $next)
    {
        $response = $next($request);

        // Only process HTML responses on landing pages
        $contentType = $response->headers->get('Content-Type');
        $isLandingPage = $request->is('/') || $request->is('business-page/*') || $request->is('page/*');
        
        if ($isLandingPage && $contentType && strpos($contentType, 'text/html') !== false) {
            // Set permissive CSP that allows inline scripts and styles
            $response->headers->set('Content-Security-Policy', 
                "default-src 'self'; " .
                "script-src 'self' 'unsafe-inline' 'unsafe-eval' https://www.google-analytics.com https://www.googletagmanager.com; " .
                "style-src 'self' 'unsafe-inline' https://fonts.googleapis.com; " .
                "img-src 'self' data: https: http:; " .
                "font-src 'self' data: https://fonts.gstatic.com; " .
                "connect-src 'self' https://www.google-analytics.com; " .
                "frame-src 'self' https://www.youtube.com https://www.google.com; " .
                "object-src 'none'; " .
                "base-uri 'self';"
            );
        }

        return $response;
    }
}
