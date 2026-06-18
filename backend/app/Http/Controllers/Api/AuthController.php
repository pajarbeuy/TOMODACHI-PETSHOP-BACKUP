<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\User;
use App\Models\Role;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Str;
use Illuminate\Validation\ValidationException;

class AuthController extends Controller
{
    private const CAPTCHA_TTL_MINUTES = 10;

    /**
     * GET /api/auth/captcha
     * Generate captcha sederhana untuk flow login API.
     */
    public function captcha()
    {
        $left = random_int(1, 9);
        $right = random_int(1, 9);
        $key = (string) Str::uuid();

        Cache::put(
            $this->captchaCacheKey($key),
            (string) ($left + $right),
            now()->addMinutes(self::CAPTCHA_TTL_MINUTES)
        );

        return response()->json([
            'status' => true,
            'message' => 'Captcha generated',
            'data' => [
                'captcha_key' => $key,
                'question' => "{$left} + {$right}",
                'expires_in' => self::CAPTCHA_TTL_MINUTES * 60,
            ],
        ]);
    }

    /**
     * POST /api/auth/login
     * Validasi email & password, kembalikan token Sanctum
     */
    public function login(Request $request)
    {
        try {
            // 422: field kosong / format email salah / password kurang dari 6 karakter
            $validated = $request->validate([
                'email' => 'required|email',
                'password' => 'required|string|min:6',
                'captcha_key' => 'required|string',
                'captcha_answer' => 'required|string',
                'remember_me' => 'nullable|boolean',
            ]);

            if (!$this->captchaIsValid($validated['captcha_key'], $validated['captcha_answer'])) {
                return response()->json([
                    'status' => false,
                    'message' => 'Captcha verification failed.',
                    'errors' => [
                        'captcha_answer' => ['Captcha is incorrect or expired.'],
                    ],
                ], 422);
            }

            $user = User::where('email', $validated['email'])->first();

            // 401: email tidak ditemukan atau password salah
            if (!$user || !Hash::check($validated['password'], $user->password)) {
                return response()->json([
                    'status'  => false,
                    'message' => 'Invalid credentials. Email or password is incorrect.',
                ], 401);
            }

            $rememberMe = (bool) ($validated['remember_me'] ?? false);
            $user->forceFill([
                'email_verified_at' => $user->email_verified_at ?? now(),
                'remember_token' => $rememberMe ? Str::random(60) : null,
            ])->save();

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
                'email_verified_at' => now(),
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
     * GET /api/auth/accounts
     * Owner-only account management list.
     */
    public function accounts(Request $request)
    {
        try {
            $users = User::with('role')->orderBy('name')->get()->map(fn ($user) => [
                'id' => $user->id,
                'name' => $user->name,
                'email' => $user->email,
                'role' => [
                    'id' => $user->role?->id,
                    'name' => $user->role?->name,
                ],
                'created_at' => $user->created_at?->toIso8601String(),
                'updated_at' => $user->updated_at?->toIso8601String(),
            ]);

            return response()->json([
                'status' => true,
                'message' => 'Accounts retrieved successfully',
                'data' => $users,
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'status' => false,
                'message' => 'Failed to retrieve accounts: ' . $e->getMessage(),
            ], 500);
        }
    }

    /**
     * PATCH /api/auth/accounts/{user}
     * Owner-only account update.
     */
    public function updateAccount(Request $request, User $user)
    {
        try {
            $validated = $request->validate([
                'name' => 'sometimes|required|string|max:255',
                'email' => 'sometimes|required|email|unique:users,email,' . $user->id,
                'password' => 'nullable|string|min:6|confirmed',
                'role_id' => 'sometimes|required|exists:roles,id',
            ]);

            $payload = [];

            if (array_key_exists('name', $validated)) {
                $payload['name'] = $validated['name'];
            }

            if (array_key_exists('email', $validated)) {
                $payload['email'] = $validated['email'];
            }

            if (array_key_exists('role_id', $validated)) {
                $payload['role_id'] = $validated['role_id'];
            }

            if (array_key_exists('password', $validated) && $validated['password'] !== null) {
                $payload['password'] = Hash::make($validated['password']);
            }

            $user->update($payload);

            return response()->json([
                'status' => true,
                'message' => 'Account updated successfully',
                'data' => [
                    'user' => $user->fresh()->load('role'),
                ],
            ], 200);
        } catch (ValidationException $e) {
            return response()->json([
                'status' => false,
                'message' => 'Validation failed',
                'errors' => $e->errors(),
            ], 422);
        } catch (\Exception $e) {
            return response()->json([
                'status' => false,
                'message' => 'Failed to update account: ' . $e->getMessage(),
            ], 500);
        }
    }

    /**
     * DELETE /api/auth/accounts/{user}
     * Owner-only account deletion.
     */
    public function destroyAccount(User $user)
    {
        try {
            $user->delete();

            return response()->json([
                'status' => true,
                'message' => 'Account deleted successfully',
                'data' => null,
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'status' => false,
                'message' => 'Failed to delete account: ' . $e->getMessage(),
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

    private function captchaCacheKey(string $key): string
    {
        return 'auth_captcha:' . $key;
    }

    private function captchaIsValid(string $key, string $answer): bool
    {
        $expectedAnswer = Cache::pull($this->captchaCacheKey($key));

        if ($expectedAnswer === null) {
            return false;
        }

        return hash_equals((string) $expectedAnswer, trim($answer));
    }
}
