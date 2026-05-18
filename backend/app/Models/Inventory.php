<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Inventory extends Model
{
    use HasFactory;

    protected $table = 'stocks';

    protected $fillable = ['product_id', 'channel', 'quantity', 'min_threshold', 'last_updated_at'];

    protected $casts = [
        'last_updated_at' => 'datetime',
    ];

    public function product()
    {
        return $this->belongsTo(Product::class);
    }
}
