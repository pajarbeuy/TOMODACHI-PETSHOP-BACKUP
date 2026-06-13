<?php

namespace Tests\Feature;

use Illuminate\Foundation\Testing\RefreshDatabase;
use Laravel\Sanctum\Sanctum;
use Tests\Support\BuildsPetShopData;
use Tests\TestCase;

class SecurityRouteTest extends TestCase
{
    use BuildsPetShopData;
    use RefreshDatabase;

    /**
     * @dataProvider protectedRouteProvider
     */
    public function test_protected_routes_reject_guests(string $method, string $uri, array $payload = []): void
    {
        $this->json($method, $uri, $payload)->assertUnauthorized();
    }

    public static function protectedRouteProvider(): array
    {
        return [
            'logout' => ['POST', '/api/auth/logout'],
            'me' => ['GET', '/api/auth/me'],
            'register' => ['POST', '/api/auth/register'],
            'user' => ['GET', '/api/user'],
            'categories index' => ['GET', '/api/categories'],
            'categories show' => ['GET', '/api/categories/1'],
            'categories store' => ['POST', '/api/categories'],
            'categories put' => ['PUT', '/api/categories/1'],
            'categories patch' => ['PATCH', '/api/categories/1'],
            'categories delete' => ['DELETE', '/api/categories/1'],
            'product categories' => ['GET', '/api/products/categories'],
            'products index' => ['GET', '/api/products'],
            'products show' => ['GET', '/api/products/1'],
            'products store' => ['POST', '/api/products'],
            'products post update' => ['POST', '/api/products/1/update'],
            'products put' => ['PUT', '/api/products/1'],
            'products delete' => ['DELETE', '/api/products/1'],
            'transactions store' => ['POST', '/api/transactions'],
            'transactions index' => ['GET', '/api/transactions'],
            'transactions show' => ['GET', '/api/transactions/1'],
            'transactions receipt' => ['GET', '/api/transactions/1/receipt'],
            'sales report' => ['GET', '/api/reports/sales'],
            'sales summary' => ['GET', '/api/reports/sales/summary'],
            'top products' => ['GET', '/api/reports/top-products'],
            'dashboard analytics' => ['GET', '/api/dashboard/analytics'],
            'ai chat' => ['POST', '/api/ai/chat'],
            'ai history' => ['GET', '/api/ai/chat/history'],
            'ai restock' => ['GET', '/api/ai/restock'],
        ];
    }

    /**
     * @dataProvider ownerOrAdminRouteProvider
     */
    public function test_owner_or_admin_routes_reject_kasir(string $method, string $uri, array $payload = []): void
    {
        Sanctum::actingAs($this->userWithRole('kasir'));

        $this->json($method, $uri, $payload)->assertForbidden();
    }

    public static function ownerOrAdminRouteProvider(): array
    {
        return [
            'register user' => ['POST', '/api/auth/register'],
            'create category' => ['POST', '/api/categories'],
            'update category put' => ['PUT', '/api/categories/1'],
            'update category patch' => ['PATCH', '/api/categories/1'],
            'delete category' => ['DELETE', '/api/categories/1'],
            'create product' => ['POST', '/api/products'],
            'update product post' => ['POST', '/api/products/1/update'],
            'update product put' => ['PUT', '/api/products/1'],
            'delete product' => ['DELETE', '/api/products/1'],
            'sales report' => ['GET', '/api/reports/sales'],
            'sales summary' => ['GET', '/api/reports/sales/summary'],
            'top products' => ['GET', '/api/reports/top-products'],
            'dashboard analytics' => ['GET', '/api/dashboard/analytics'],
        ];
    }

    /**
     * @dataProvider publicRouteProvider
     */
    public function test_expected_public_routes_do_not_require_authentication(string $method, string $uri): void
    {
        $response = $this->json($method, $uri);

        $this->assertNotSame(401, $response->getStatusCode());
    }

    public static function publicRouteProvider(): array
    {
        return [
            'health' => ['GET', '/api/health'],
            'captcha' => ['GET', '/api/auth/captcha'],
        ];
    }
}
