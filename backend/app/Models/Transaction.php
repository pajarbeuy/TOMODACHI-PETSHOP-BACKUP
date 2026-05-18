<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Transaction extends Model
{
    use HasFactory;

    protected $fillable = [
        'kasir_id',
        'transaction_code',
        'channel',
        'subtotal',
        'tax',
        'total',
        'payment_method',
        'amount_paid',
        'change_amount',
        'status',
    ];

    public function cashier()
    {
        return $this->belongsTo(User::class, 'kasir_id');
    }

    public function items()
    {
        return $this->hasMany(TransactionItem::class);
    }
}
