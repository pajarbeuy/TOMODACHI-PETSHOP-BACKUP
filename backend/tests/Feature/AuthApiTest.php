<?php

namespace Tests\Feature;

use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\Cache;
use Laravel\Sanctum\Sanctum;
use Tests\Support\BuildsPetShopData;
use Tests\TestCase;

class AuthApiTest extends TestCase
{
    use BuildsPetShopData;
    use RefreshDatabase;

    public function test_captcha_endpoint_returns_key_question_and_expiry(): void
    {
        $this->getJson('/api/auth/captcha')
            ->assertOk()
            ->assertJsonPath('status', true)
            ->assertJsonStructure(['data' => ['captcha_key', 'question', 'expires_in']]);
    }

    public function test_login_succeeds_with_valid_captcha_and_credentials(): void
    {
        $user = $this->userWithRole('owner', ['email' => 'owner@login.test']);
        Cache::put('auth_captcha:test-key', '7', now()->addMinutes(10));

        $this->postJson('/api/auth/login', [
            'email' => $user->email,
            'password' => 'password123',
            'captcha_key' => 'test-key',
            'captcha_answer' => '7',
        ])
            ->assertOk()
            ->assertJsonPath('status', true)
            ->assertJsonStructure(['data' => ['user', 'token', 'token_type']]);
    }

    public function test_login_rejects_invalid_captcha(): void
    {
        $user = $this->userWithRole('owner', ['email' => 'captcha@login.test']);
        Cache::put('auth_captcha:bad-key', '9', now()->addMinutes(10));

        $this->postJson('/api/auth/login', [
            'email' => $user->email,
            'password' => 'password123',
            'captcha_key' => 'bad-key',
            'captcha_answer' => '1',
        ])->assertUnprocessable();
    }

    public function test_login_rejects_invalid_password(): void
    {
        $user = $this->userWithRole('owner', ['email' => 'wrong-password@login.test']);
        Cache::put('auth_captcha:password-key', '4', now()->addMinutes(10));

        $this->postJson('/api/auth/login', [
            'email' => $user->email,
            'password' => 'password123-wrong',
            'captcha_key' => 'password-key',
            'captcha_answer' => '4',
        ])->assertUnauthorized();
    }

    public function test_me_returns_authenticated_user_payload(): void
    {
        $user = $this->userWithRole('admin', ['email' => 'admin@me.test']);
        Sanctum::actingAs($user);

        $this->getJson('/api/auth/me')
            ->assertOk()
            ->assertJsonPath('data.user.email', 'admin@me.test')
            ->assertJsonPath('data.user.role.name', 'admin');
    }

    public function test_logout_revokes_authenticated_session(): void
    {
        Sanctum::actingAs($this->userWithRole('kasir'));

        $this->postJson('/api/auth/logout')
            ->assertOk()
            ->assertJsonPath('status', true);
    }

    public function test_owner_can_register_new_user(): void
    {
        Sanctum::actingAs($this->userWithRole('owner'));
        $kasirRole = $this->role('kasir');

        $this->postJson('/api/auth/register', [
            'name' => 'New Kasir',
            'email' => 'new-kasir@test.local',
            'password' => 'password123',
            'password_confirmation' => 'password123',
            'role_id' => $kasirRole->id,
        ])
            ->assertCreated()
            ->assertJsonPath('data.user.email', 'new-kasir@test.local');

        $this->assertDatabaseHas('users', ['email' => 'new-kasir@test.local']);
    }


    public function test_owner_can_list_accounts(): void
    {
        Sanctum::actingAs($this->userWithRole('owner'));

        $response = $this->getJson('/api/auth/accounts');

        $response->assertOk()
            ->assertJsonPath('status', true);
    }

    public function test_admin_cannot_list_accounts(): void
    {
        Sanctum::actingAs($this->userWithRole('admin'));

        $response = $this->getJson('/api/auth/accounts');

        $response->assertForbidden();
    }

    public function test_owner_can_update_account(): void
    {
        Sanctum::actingAs($this->userWithRole('owner'));
        $target = $this->userWithRole('kasir', ['email' => 'change-me@test.local']);
        $role = $this->role('admin');

        $response = $this->patchJson('/api/auth/accounts/' . $target->id, [
            'name' => 'Updated Name',
            'role_id' => $role->id,
        ]);

        $response->assertOk()
            ->assertJsonPath('status', true)
            ->assertJsonPath('data.user.name', 'Updated Name')
            ->assertJsonPath('data.user.role.name', 'admin');
    }

    public function test_owner_can_delete_account(): void
    {
        Sanctum::actingAs($this->userWithRole('owner'));
        $target = $this->userWithRole('kasir', ['email' => 'delete-me@test.local']);

        $response = $this->deleteJson('/api/auth/accounts/' . $target->id);

        $response->assertOk()
            ->assertJsonPath('status', true);

        $this->assertDatabaseMissing('users', ['id' => $target->id]);
    }

    public function test_owner_register_validates_duplicate_email(): void
    {
        $existing = $this->userWithRole('kasir', ['email' => 'duplicate@test.local']);
        Sanctum::actingAs($this->userWithRole('owner'));

        $this->postJson('/api/auth/register', [
            'name' => 'Duplicate',
            'email' => $existing->email,
            'password' => 'password123',
            'password_confirmation' => 'password123',
            'role_id' => $existing->role_id,
        ])->assertUnprocessable();
    }
}
