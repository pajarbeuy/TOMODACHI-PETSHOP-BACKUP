<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

class ProductController extends Controller
{
     public function index()
    {
        return response()->json([
            [
                "id" => 1,
                "name" => "Laptop",
                "price" => 10000
            ],
            [
                "id" => 2,
                "name" => "Mouse",
                "price" => 500
            ]
        ]);
    }
}
