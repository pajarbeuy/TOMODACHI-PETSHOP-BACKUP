<?php

namespace App\Exceptions;

use Illuminate\Auth\AuthenticationException;
use Illuminate\Foundation\Exceptions\Handler as ExceptionHandler;
use Illuminate\Http\Exceptions\ThrottleRequestsException;
use Illuminate\Http\Request;
use Throwable;

class Handler extends ExceptionHandler
{
    /**
     * The list of the inputs that are never flashed to the session on validation exceptions.
     *
     * @var array<int, string>
     */
    protected $dontFlash = [
        'current_password',
        'password',
        'password_confirmation',
    ];

    /**
     * Register the exception handling callbacks for the application.
     */
    public function register(): void
    {
        $this->reportable(function (Throwable $e) {
            //
        });

        // 429: Rate limit exceeded → always return JSON
        $this->renderable(function (ThrottleRequestsException $e, Request $request) {
            $retryAfter = $e->getHeaders()['Retry-After'] ?? 60;
            return response()->json([
                'status'      => false,
                'message'     => 'Too many requests. Please slow down.',
                'retry_after' => (int) $retryAfter . ' seconds',
            ], 429);
        });
    }

    /**
     * Override unauthenticated handler to always return JSON 401
     * instead of redirecting to a 'login' route (which doesn't exist in API-only apps).
     */
    protected function unauthenticated($request, AuthenticationException $exception)
    {
        return response()->json([
            'status'  => false,
            'message' => 'Unauthenticated. Please provide a valid Bearer token.',
        ], 401);
    }
}
