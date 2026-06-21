<?php

namespace App\Http\Middleware;

use App\Support\ApiResponse;
use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class CheckRole
{
    /**
     * Handle an incoming request.
     * Usage: Route::middleware(['auth:sanctum', 'check.role:owner,admin'])
     *
     * @param  \Closure(\Illuminate\Http\Request): (\Symfony\Component\HttpFoundation\Response)  $next
     */
    public function handle(Request $request, Closure $next, ...$roles): Response
    {
        $user = $request->user();

        if (!$user) {
            return ApiResponse::error('Unauthorized. Please login first.', 401);
        }

        if (!$user->role) {
            return ApiResponse::error('Unauthorized. User role not assigned.', 403);
        }

        if (!in_array($user->role->name, $roles)) {
            return ApiResponse::error('Forbidden. You do not have permission to access this resource.', 403, null, [
                'required_roles' => $roles,
                'your_role' => $user->role->name,
            ]);
        }

        return $next($request);
    }
}
