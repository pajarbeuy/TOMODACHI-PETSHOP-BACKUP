<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Category extends Model
{
    use HasFactory;

    protected $fillable = ['name', 'animal_type', 'sub_category', 'description'];

    public function products()
    {
        return $this->hasMany(Product::class);
    }
}
