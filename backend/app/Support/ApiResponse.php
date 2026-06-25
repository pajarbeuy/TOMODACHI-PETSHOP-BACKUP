<?php

namespace App\Support;

use Illuminate\Http\JsonResponse;

class ApiResponse
{
    public static function error(
        string $message,
        int $statusCode = 500,
        ?array $errors = null,
        ?array $extra = null
    ): JsonResponse {
        $payload = [
            'status' => false,
            'message' => $message,
        ];

        if ($errors !== null) {
            $payload['errors'] = $errors;
        }

        if ($extra !== null) {
            $payload = array_merge($payload, $extra);
        }

        return response()->json($payload, $statusCode);
    }
}
