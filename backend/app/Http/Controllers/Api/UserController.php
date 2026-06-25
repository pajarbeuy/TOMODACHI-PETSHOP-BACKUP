<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Validation\ValidationException;

class UserController extends Controller
{
    /**
     * GET /api/users
     * List semua users (owner only)
     */
    public function index(Request $request)
    {
        try {
            $page = $request->query('page', 1);
            $perPage = $request->query('per_page', 10);
            $search = $request->query('search', '');
            $roleFilter = $request->query('role', '');

            $query = User::with('role');

            // Search by name or email
            if ($search) {
                $query->where('name', 'like', "%{$search}%")
                    ->orWhere('email', 'like', "%{$search}%");
            }

            // Filter by role
            if ($roleFilter) {
                $query->whereHas('role', function ($q) use ($roleFilter) {
                    $q->where('name', $roleFilter);
                });
            }

            $users = $query->paginate($perPage, ['*'], 'page', $page);

            return response()->json([
                'status' => true,
                'message' => 'Users retrieved successfully',
                'data' => [
                    'users' => $users->items(),
                    'pagination' => [
                        'current_page' => $users->currentPage(),
                        'per_page' => $users->perPage(),
                        'total' => $users->total(),
                        'last_page' => $users->lastPage(),
                    ],
                ],
            ], 200);

        } catch (\Exception $e) {
            return response()->json([
                'status' => false,
                'message' => 'Failed to retrieve users: ' . $e->getMessage(),
            ], 500);
        }
    }

    /**
     * GET /api/users/{id}
     * Ambil detail user berdasarkan ID (owner only)
     */
    public function show(Request $request, User $user)
    {
        try {
            $user->load('role');

            return response()->json([
                'status' => true,
                'message' => 'User retrieved successfully',
                'data' => [
                    'user' => $user,
                ],
            ], 200);

        } catch (\Exception $e) {
            return response()->json([
                'status' => false,
                'message' => 'Failed to retrieve user: ' . $e->getMessage(),
            ], 500);
        }
    }

    /**
     * POST /api/users
     * Buat user baru (owner only) - sama seperti register tapi lebih fleksibel
     */
    public function store(Request $request)
    {
        try {
            $validated = $request->validate([
                'name' => 'required|string|max:255',
                'email' => 'required|email|unique:users,email',
                'password' => 'required|string|min:6',
                'role_id' => 'required|exists:roles,id',
            ]);

            $newUser = User::create([
                'name' => $validated['name'],
                'email' => $validated['email'],
                'password' => Hash::make($validated['password']),
                'role_id' => $validated['role_id'],
                'email_verified_at' => now(),
            ]);

            $newUser->load('role');

            return response()->json([
                'status' => true,
                'message' => 'User created successfully',
                'data' => [
                    'user' => $newUser,
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
                'message' => 'Failed to create user: ' . $e->getMessage(),
            ], 500);
        }
    }

    /**
     * PUT /api/users/{id}
     * Update user (owner only)
     */
    public function update(Request $request, User $user)
    {
        try {
            $validated = $request->validate([
                'name' => 'sometimes|required|string|max:255',
                'email' => 'sometimes|required|email|unique:users,email,' . $user->id,
                'password' => 'sometimes|required|string|min:6',
                'role_id' => 'sometimes|required|exists:roles,id',
            ]);

            // Update fields yang ada di validated
            if (isset($validated['name'])) {
                $user->name = $validated['name'];
            }

            if (isset($validated['email'])) {
                $user->email = $validated['email'];
            }

            if (isset($validated['password'])) {
                $user->password = Hash::make($validated['password']);
            }

            if (isset($validated['role_id'])) {
                $user->role_id = $validated['role_id'];
            }

            $user->save();
            $user->load('role');

            return response()->json([
                'status' => true,
                'message' => 'User updated successfully',
                'data' => [
                    'user' => $user,
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
                'message' => 'Failed to update user: ' . $e->getMessage(),
            ], 500);
        }
    }

    /**
     * DELETE /api/users/{id}
     * Hapus user (owner only)
     */
    public function destroy(Request $request, User $user)
    {
        try {
            // Prevent deleting the owner itself
            $requestingUser = $request->user();
            if ($requestingUser->id === $user->id) {
                return response()->json([
                    'status' => false,
                    'message' => 'Cannot delete your own account',
                ], 403);
            }

            $deletedUser = $user->replicate();
            $user->delete();

            return response()->json([
                'status' => true,
                'message' => 'User deleted successfully',
                'data' => [
                    'user' => $deletedUser->load('role'),
                ],
            ], 200);

        } catch (\Exception $e) {
            return response()->json([
                'status' => false,
                'message' => 'Failed to delete user: ' . $e->getMessage(),
            ], 500);
        }
    }

    /**
     * GET /api/users/stats/count
     * Hitung total users per role (owner only)
     */
    public function stats(Request $request)
    {
        try {
            $stats = User::with('role')
                ->get()
                ->groupBy('role.name')
                ->map(function ($group) {
                    return $group->count();
                });

            $total = User::count();

            return response()->json([
                'status' => true,
                'message' => 'User statistics retrieved',
                'data' => [
                    'total' => $total,
                    'by_role' => $stats,
                ],
            ], 200);

        } catch (\Exception $e) {
            return response()->json([
                'status' => false,
                'message' => 'Failed to retrieve statistics: ' . $e->getMessage(),
            ], 500);
        }
    }
}
