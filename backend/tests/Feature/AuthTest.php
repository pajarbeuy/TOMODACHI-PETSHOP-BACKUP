<?php

namespace Tests\Feature;

use App\Models\Role;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\Cache;
use Laravel\Sanctum\Sanctum;
use Tests\TestCase;

class AuthTest extends TestCase
{
    use RefreshDatabase;

    private User $owner;
    private User $kasir;
    private Role $ownerRole;
    private Role $kasirRole;

    protected function setUp(): void
    {
        parent::setUp();

        $this->ownerRole = Role::create(['name' => 'owner']);
        $this->kasirRole = Role::create(['name' => 'kasir']);

        $this->owner = User::create([
            'name'     => 'Owner Test',
            'email'    => 'owner@test.com',
            'password' => bcrypt('password123'),
            'role_id'  => $this->ownerRole->id,
        ]);

        $this->kasir = User::create([
            'name'     => 'Kasir Test',
            'email'    => 'kasir@test.com',
            'password' => bcrypt('password123'),
            'role_id'  => $this->kasirRole->id,
        ]);
    }

    // ─── Captcha ────────────────────────────────────────────────────────────────

    /** @test */
    public function it_generates_a_captcha_challenge()
    {
        $response = $this->getJson('/api/auth/captcha');

        $response->assertStatus(200)
            ->assertJsonPath('status', true)
            ->assertJsonStructure([
                'data' => ['captcha_key', 'question', 'expires_in'],
            ]);

        $this->assertNotEmpty($response->json('data.captcha_key'));
        $this->assertMatchesRegularExpression('/^\d+ \+ \d+$/', $response->json('data.question'));
    }

    // ─── Login ───────────────────────────────────────────────────────────────────

    private function makeCaptcha(): array
    {
        $captchaResponse = $this->getJson('/api/auth/captcha')->json('data');
        $question = $captchaResponse['question']; // "3 + 5"
        [$a, $b] = array_map('intval', explode(' + ', $question));

        return [
            'key'    => $captchaResponse['captcha_key'],
            'answer' => (string) ($a + $b),
        ];
    }

    /** @test */
    public function it_logs_in_with_valid_credentials_and_captcha()
    {
        $captcha = $this->makeCaptcha();

        $response = $this->postJson('/api/auth/login', [
            'email'          => 'owner@test.com',
            'password'       => 'password123',
            'captcha_key'    => $captcha['key'],
            'captcha_answer' => $captcha['answer'],
        ]);

        $response->assertStatus(200)
            ->assertJsonPath('status', true)
            ->assertJsonStructure([
                'data' => ['token', 'token_type', 'user' => ['id', 'name', 'email', 'role']],
            ]);

        $this->assertNotEmpty($response->json('data.token'));
    }

    /** @test */
    public function it_rejects_login_with_wrong_password()
    {
        $captcha = $this->makeCaptcha();

        $response = $this->postJson('/api/auth/login', [
            'email'          => 'owner@test.com',
            'password'       => 'wrongpassword',
            'captcha_key'    => $captcha['key'],
            'captcha_answer' => $captcha['answer'],
        ]);

        $response->assertStatus(401)
            ->assertJsonPath('status', false);
    }

    /** @test */
    public function it_rejects_login_with_wrong_captcha()
    {
        $captcha = $this->makeCaptcha();

        $response = $this->postJson('/api/auth/login', [
            'email'          => 'owner@test.com',
            'password'       => 'password123',
            'captcha_key'    => $captcha['key'],
            'captcha_answer' => '999', // wrong answer
        ]);

        $response->assertStatus(422)
            ->assertJsonPath('status', false);
    }

    /** @test */
    public function it_rejects_login_with_missing_fields()
    {
        $response = $this->postJson('/api/auth/login', []);

        $response->assertStatus(422)
            ->assertJsonPath('status', false);
    }

    // ─── Me ──────────────────────────────────────────────────────────────────────

    /** @test */
    public function it_returns_authenticated_user_on_me_endpoint()
    {
        Sanctum::actingAs($this->owner);

        $response = $this->getJson('/api/auth/me');

        $response->assertStatus(200)
            ->assertJsonPath('status', true)
            ->assertJsonPath('data.user.email', 'owner@test.com')
            ->assertJsonPath('data.user.role.name', 'owner');
    }

    /** @test */
    public function it_returns_401_on_me_without_auth()
    {
        $response = $this->getJson('/api/auth/me');

        $response->assertStatus(401);
    }

    // ─── Logout ──────────────────────────────────────────────────────────────────

    /** @test */
    public function it_logs_out_and_revokes_token()
    {
        Sanctum::actingAs($this->kasir);

        $response = $this->postJson('/api/auth/logout');

        $response->assertStatus(200)
            ->assertJsonPath('status', true);

        // Token should be gone from DB
        $this->assertDatabaseCount('personal_access_tokens', 0);
    }

    // ─── Register ─────────────────────────────────────────────────────────────────

    /** @test */
    public function owner_can_register_new_user()
    {
        Sanctum::actingAs($this->owner);

        $response = $this->postJson('/api/auth/register', [
            'name'                  => 'New Kasir',
            'email'                 => 'newkasir@test.com',
            'password'              => 'secret123',
            'password_confirmation' => 'secret123',
            'role_id'               => $this->kasirRole->id,
        ]);

        $response->assertStatus(201)
            ->assertJsonPath('status', true);

        $this->assertDatabaseHas('users', ['email' => 'newkasir@test.com']);
    }

    /** @test */
    public function kasir_cannot_register_new_user()
    {
        Sanctum::actingAs($this->kasir);

        $response = $this->postJson('/api/auth/register', [
            'name'                  => 'Another User',
            'email'                 => 'another@test.com',
            'password'              => 'secret123',
            'password_confirmation' => 'secret123',
            'role_id'               => $this->kasirRole->id,
        ]);

        $response->assertStatus(403)
            ->assertJsonPath('status', false);
    }

    /** @test */
    public function register_fails_with_duplicate_email()
    {
        Sanctum::actingAs($this->owner);

        $response = $this->postJson('/api/auth/register', [
            'name'                  => 'Duplicate',
            'email'                 => 'kasir@test.com', // already exists
            'password'              => 'secret123',
            'password_confirmation' => 'secret123',
            'role_id'               => $this->kasirRole->id,
        ]);

        $response->assertStatus(422)
            ->assertJsonPath('status', false);
    }

    // ─── Account Management ───────────────────────────────────────────────────────

    /** @test */
    public function owner_can_list_all_accounts()
    {
        Sanctum::actingAs($this->owner);

        $response = $this->getJson('/api/auth/accounts');

        $response->assertStatus(200)
            ->assertJsonPath('status', true)
            ->assertJsonCount(2, 'data'); // owner + kasir
    }

    /** @test */
    public function kasir_cannot_access_accounts_list()
    {
        Sanctum::actingAs($this->kasir);

        $response = $this->getJson('/api/auth/accounts');

        $response->assertStatus(403);
    }

    /** @test */
    public function owner_can_update_another_account()
    {
        Sanctum::actingAs($this->owner);

        $response = $this->patchJson("/api/auth/accounts/{$this->kasir->id}", [
            'name' => 'Kasir Updated',
        ]);

        $response->assertStatus(200)
            ->assertJsonPath('status', true);

        $this->assertDatabaseHas('users', [
            'id'   => $this->kasir->id,
            'name' => 'Kasir Updated',
        ]);
    }

    /** @test */
    public function owner_cannot_delete_own_account()
    {
        Sanctum::actingAs($this->owner);

        $response = $this->deleteJson("/api/auth/accounts/{$this->owner->id}");

        $response->assertStatus(403)
            ->assertJsonPath('status', false);
    }

    /** @test */
    public function owner_can_delete_another_account()
    {
        Sanctum::actingAs($this->owner);

        $response = $this->deleteJson("/api/auth/accounts/{$this->kasir->id}");

        $response->assertStatus(200)
            ->assertJsonPath('status', true);

        $this->assertDatabaseMissing('users', ['id' => $this->kasir->id]);
    }
}
