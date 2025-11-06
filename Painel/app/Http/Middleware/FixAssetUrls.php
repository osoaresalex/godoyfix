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
        $contentType = $response->headers->get('Content-Type');
        
        \Log::info('FixAssetUrls Middleware', [
            'path' => $request->path(),
            'content_type' => $contentType,
            'status' => $response->status()
        ]);
        
        if ($contentType && strpos($contentType, 'text/html') !== false) {
            $content = $response->getContent();
            $originalLength = strlen($content);
            
            // Replace all occurrences of /public/assets/ with /assets/
            $content = str_replace('/public/assets/', '/assets/', $content);
            $content = preg_replace('#(https?://[^/]+)/public/assets/#', '$1/assets/', $content);
            
            $newLength = strlen($content);
            
            \Log::info('FixAssetUrls Applied', [
                'original_length' => $originalLength,
                'new_length' => $newLength,
                'replacements_made' => $originalLength !== $newLength
            ]);
            
            $response->setContent($content);
        }

        return $response;
    }
}
