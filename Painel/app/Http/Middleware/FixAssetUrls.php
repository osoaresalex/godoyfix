<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;

class FixAssetUrls
{
    /**
     * Handle an incoming request and fix asset URLs
     * Remove /public/ prefix from asset URLs in HTML responses
     */
    public function handle(Request $request, Closure $next)
    {
        $response = $next($request);

        // Only process HTML responses
        if ($response->headers->get('Content-Type') && 
            strpos($response->headers->get('Content-Type'), 'text/html') !== false) {
            
            $content = $response->getContent();
            
            // Replace all occurrences of /public/assets/ with /assets/
            $content = str_replace('/public/assets/', '/assets/', $content);
            $content = preg_replace('#https?://[^/]+/public/assets/#', '$0/../assets/', $content);
            $content = preg_replace('#(https?://[^/]+)/public/assets/#', '$1/assets/', $content);
            
            $response->setContent($content);
        }

        return $response;
    }
}
