<?php

namespace App\Http\Middleware;

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
            return response()->json([
                'status' => false,
                'message' => 'Unauthorized. Please login first.',
            ], 401);
        }

        if (!$user->role) {
            return response()->json([
                'status' => false,
                'message' => 'Unauthorized. User role not assigned.',
            ], 403);
        }

        if (!in_array($user->role->name, $roles)) {
            return response()->json([
                'status' => false,
                'message' => 'Forbidden. You do not have permission to access this resource.',
                'required_roles' => $roles,
                'your_role' => $user->role->name,
            ], 403);
        }

        return $next($request);
    }
}
