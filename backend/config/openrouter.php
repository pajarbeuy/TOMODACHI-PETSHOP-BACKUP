<?php

return [
    /*
    |--------------------------------------------------------------------------
    | OpenRouter AI Configuration
    |--------------------------------------------------------------------------
    |
    | OpenRouter is a unified API gateway that provides access to hundreds of
    | AI models. It uses the OpenAI-compatible chat completions format.
    |
    | Get your free API key at: https://openrouter.ai
    |
    */

    'api_key'  => env('OPENROUTER_API_KEY', ''),

    'base_url' => env('OPENROUTER_BASE_URL', 'https://openrouter.ai/api/v1'),

    // Default model — use any model slug from https://openrouter.ai/models
    // Free models: meta-llama/llama-3.3-70b-instruct:free
    //              google/gemma-3-27b-it:free
    //              mistralai/mistral-7b-instruct:free
    'model'    => env('OPENROUTER_MODEL', 'meta-llama/llama-3.3-70b-instruct:free'),

    // Comma-separated fallback models used when the primary model is rate-limited.
    'fallback_models' => array_values(array_filter(array_map(
        'trim',
        explode(',', env('OPENROUTER_FALLBACK_MODELS', 'openai/gpt-oss-20b:free,openai/gpt-oss-120b:free,nex-agi/nex-n2-pro:free,nvidia/nemotron-3-ultra-550b-a55b:free'))
    ))),

    // HTTP timeout in seconds
    'timeout'  => (int) env('OPENROUTER_TIMEOUT', 60),

    // App site URL and name sent in headers (required by OpenRouter policy)
    'site_url'  => env('APP_URL', 'http://localhost'),
    'site_name' => env('APP_NAME', 'Tomodachi Pet Shop'),
];
