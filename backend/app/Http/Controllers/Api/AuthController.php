<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\User;
use App\Models\Role;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Validation\ValidationException;

class AuthController extends Controller
{
    /**
     * POST /api/auth/login
     * Validasi email & password, kembalikan token Sanctum
     */
    public function login(Request $request)
    {
        try {
            // 422: field kosong / format email salah / password kurang dari 6 karakter
            $validated = $request->validate([
                'email'    => 'required|email',
                'password' => 'required|string|min:6',
            ]);

            $user = User::where('email', $validated['email'])->first();

            // 401: email tidak ditemukan atau password salah
            if (!$user || !Hash::check($validated['password'], $user->password)) {
                return response()->json([
                    'status'  => false,
                    'message' => 'Invalid credentials. Email or password is incorrect.',
                ], 401);
            }

            // Revoke existing tokens
            $user->tokens()->delete();

            // Create new token
            $token = $user->createToken('auth_token')->plainTextToken;

            return response()->json([
                'status'  => true,
                'message' => 'Login successful',
                'data'    => [
                    'user'       => $user->load('role'),
                    'token'      => $token,
                    'token_type' => 'Bearer',
                ],
            ], 200);
        } catch (ValidationException $e) {
            // 422: hanya untuk field yang tidak memenuhi aturan validasi
            return response()->json([
                'status'  => false,
                'message' => 'Validation failed',
                'errors'  => $e->errors(),
            ], 422);
        }
    }

    /**
     * POST /api/auth/logout
     * Revoke token Sanctum saat user logout
     */
    public function logout(Request $request)
    {
        try {
            $user = $request->user();

            if (!$user) {
                return response()->json([
                    'status' => false,
                    'message' => 'User not authenticated',
                ], 401);
            }

            // Revoke all tokens for this user
            $user->tokens()->delete();

            return response()->json([
                'status' => true,
                'message' => 'Logout successful',
                'data' => null,
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'status' => false,
                'message' => 'Logout failed: ' . $e->getMessage(),
            ], 500);
        }
    }

    /**
     * POST /api/auth/register
     * Endpoint register hanya bisa dipanggil oleh role owner
     * AC: Kasir/admin tidak bisa register akun baru. Owner bisa mendaftarkan akun baru.
     */
    public function register(Request $request)
    {
        try {
            $user = $request->user();

            // Check if user is authenticated and is owner
            if (!$user || !$user->role || $user->role->name !== 'owner') {
                return response()->json([
                    'status' => false,
                    'message' => 'Unauthorized. Only owner can register new accounts.',
                ], 403);
            }

            $validated = $request->validate([
                'name' => 'required|string|max:255',
                'email' => 'required|email|unique:users',
                'password' => 'required|string|min:6|confirmed',
                'role_id' => 'required|exists:roles,id',
            ]);

            // Create new user
            $newUser = User::create([
                'name' => $validated['name'],
                'email' => $validated['email'],
                'password' => Hash::make($validated['password']),
                'role_id' => $validated['role_id'],
            ]);

            return response()->json([
                'status' => true,
                'message' => 'User registered successfully',
                'data' => [
                    'user' => $newUser->load('role'),
                ],
            ], 201);
        } catch (ValidationException $e) {
            return response()->json([
                'status' => false,
                'message' => 'Validation failed',
                'errors' => $e->errors(),
            ], 422);
        } catch (\Exception $e) {
            return response()->json([
                'status' => false,
                'message' => 'Registration failed: ' . $e->getMessage(),
            ], 500);
        }
    }

    /**
     * GET /api/auth/me
     * Get current authenticated user
     */
    public function me(Request $request)
    {
        try {
            $user = $request->user();

            if (!$user) {
                return response()->json([
                    'status' => false,
                    'message' => 'User not authenticated',
                ], 401);
            }

            return response()->json([
                'status' => true,
                'message' => 'User data retrieved',
                'data' => [
                    'user' => [
                        'id' => $user->id,
                        'name' => $user->name,
                        'email' => $user->email,
                        'role' => [
                            'id' => $user->role?->id,
                            'name' => $user->role?->name,
                        ],
                    ],
                ],
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'status' => false,
                'message' => 'Failed to retrieve user: ' . $e->getMessage(),
            ], 500);
        }
    }
}
