<?php

namespace App\Exceptions;

use App\Support\ApiResponse;
use Illuminate\Auth\Access\AuthorizationException;
use Illuminate\Auth\AuthenticationException;
use Illuminate\Database\QueryException;
use Illuminate\Foundation\Exceptions\Handler as ExceptionHandler;
use Illuminate\Http\Exceptions\ThrottleRequestsException;
use Illuminate\Http\Request;
use Illuminate\Routing\Exceptions\InvalidSignatureException;
use Illuminate\Validation\ValidationException;
use Symfony\Component\HttpKernel\Exception\HttpExceptionInterface;
use Symfony\Component\HttpKernel\Exception\MethodNotAllowedHttpException;
use Symfony\Component\HttpKernel\Exception\NotFoundHttpException;
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

        $this->renderable(function (ValidationException $e, Request $request) {
            if (!$this->shouldReturnJson($request)) {
                return null;
            }

            return ApiResponse::error('Validation failed', 422, $e->errors());
        });

        $this->renderable(function (AuthorizationException $e, Request $request) {
            if (!$this->shouldReturnJson($request)) {
                return null;
            }

            return ApiResponse::error('Forbidden. You do not have permission to access this resource.', 403);
        });

        $this->renderable(function (NotFoundHttpException $e, Request $request) {
            if (!$this->shouldReturnJson($request)) {
                return null;
            }

            return ApiResponse::error('Resource not found.', 404);
        });

        $this->renderable(function (MethodNotAllowedHttpException $e, Request $request) {
            if (!$this->shouldReturnJson($request)) {
                return null;
            }

            return ApiResponse::error('HTTP method is not allowed for this endpoint.', 405, null, [
                'allowed_methods' => $e->getHeaders()['Allow'] ?? null,
            ]);
        });

        $this->renderable(function (InvalidSignatureException $e, Request $request) {
            if (!$this->shouldReturnJson($request)) {
                return null;
            }

            return ApiResponse::error('Invalid or expired signature.', 403);
        });

        $this->renderable(function (QueryException $e, Request $request) {
            if (!$this->shouldReturnJson($request)) {
                return null;
            }

            return ApiResponse::error('Database operation failed. Please try again later.', 500);
        });

        $this->renderable(function (ThrottleRequestsException $e, Request $request) {
            if (!$this->shouldReturnJson($request)) {
                return null;
            }

            $retryAfter = $e->getHeaders()['Retry-After'] ?? 60;

            return ApiResponse::error('Too many requests. Please slow down.', 429, null, [
                'retry_after' => (int) $retryAfter . ' seconds',
            ]);
        });
    }

    public function render($request, Throwable $e)
    {
        if ($this->shouldReturnJson($request)) {
            if (
                !$e instanceof AuthenticationException
                && !$e instanceof AuthorizationException
                && !$e instanceof ValidationException
                && !$e instanceof HttpExceptionInterface
                && !$e instanceof QueryException
            ) {
                report($e);

                return ApiResponse::error('Internal server error. Please try again later.', 500);
            }
        }

        return parent::render($request, $e);
    }

    /**
     * Override unauthenticated handler to always return JSON 401
     * instead of redirecting to a 'login' route (which doesn't exist in API-only apps).
     */
    protected function unauthenticated($request, AuthenticationException $exception)
    {
        return ApiResponse::error('Unauthenticated. Please provide a valid Bearer token.', 401);
    }

    protected function shouldReturnJson($request, ?Throwable $e = null): bool
    {
        return $request->is('api/*') || $request->expectsJson();
    }
}
