<?php

namespace Tests\Feature;

use Illuminate\Foundation\Testing\RefreshDatabase;
use Laravel\Sanctum\Sanctum;
use Tests\Support\BuildsPetShopData;
use Tests\TestCase;

class ApiErrorHandlingTest extends TestCase
{
    use BuildsPetShopData;
    use RefreshDatabase;

    public function test_unknown_api_route_returns_consistent_json_error(): void
    {
        $this->getJson('/api/does-not-exist')
            ->assertNotFound()
            ->assertJsonPath('status', false)
            ->assertJsonPath('message', 'Resource not found.');
    }

    public function test_wrong_http_method_returns_consistent_json_error(): void
    {
        $this->postJson('/api/health')
            ->assertStatus(405)
            ->assertJsonPath('status', false);
    }

    public function test_validation_errors_use_consistent_payload(): void
    {
        Sanctum::actingAs($this->userWithRole('owner'));

        $this->postJson('/api/categories', [])
            ->assertUnprocessable()
            ->assertJsonPath('status', false)
            ->assertJsonPath('message', 'Validation failed')
            ->assertJsonStructure(['errors']);
    }
}
