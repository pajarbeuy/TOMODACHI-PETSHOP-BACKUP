<?php

return [

    /*
    |--------------------------------------------------------------------------
    | Cross-Origin Resource Sharing (CORS) Configuration
    |--------------------------------------------------------------------------
    |
    | Here you may configure your settings for cross-origin resource sharing
    | or "CORS". This determines what cross-origin operations may execute
    | in web browsers. You are free to adjust these settings as needed.
    |
    | To learn more: https://developer.mozilla.org/en-US/docs/Web/HTTP/CORS
    |
    */

    'paths' => ['api/*', 'sanctum/csrf-cookie'],

    'allowed_methods' => ['GET', 'POST', 'PUT', 'PATCH', 'DELETE', 'OPTIONS'],

    'allowed_origins' => [
        // Production domain
        'https://tomodachi-petshop.xyz',
        'https://www.tomodachi-petshop.xyz',
        // Local development
        'http://localhost',
        'http://localhost:8000',
        'http://localhost:3000',
        'http://127.0.0.1',
        'http://127.0.0.1:8000',
    ],

    'allowed_origins_patterns' => [
        // Flutter web memakai port acak saat development.
        '/^http:\/\/localhost(:[0-9]+)?$/',
        '/^http:\/\/127\.0\.0\.1(:[0-9]+)?$/',
        // Izinkan ngrok tunnel saat development/demo
        '/^https:\/\/[a-z0-9\-]+\.ngrok(-free)?\.app$/',
        '/^https:\/\/[a-z0-9\-]+\.ngrok-free\.dev$/',
    ],

    'allowed_headers' => ['Content-Type', 'Authorization', 'Accept', 'X-Requested-With', 'ngrok-skip-browser-warning'],

    'exposed_headers' => [],

    'max_age' => 86400,

    'supports_credentials' => false,

];
