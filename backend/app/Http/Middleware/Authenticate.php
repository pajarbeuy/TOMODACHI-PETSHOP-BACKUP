<?php

namespace App\Http\Middleware;

use Illuminate\Auth\Middleware\Authenticate as Middleware;
use Illuminate\Http\Request;

class Authenticate extends Middleware
{
    /**
     * Get the path the user should be redirected to when they are not authenticated.
     */
    protected function redirectTo(Request $request): ?string
    {
        // Return null so unauthenticated API requests receive a 401 JSON response
        // instead of attempting to redirect to a named 'login' route (which doesn't exist in API-only apps).
        return null;
    }
}
