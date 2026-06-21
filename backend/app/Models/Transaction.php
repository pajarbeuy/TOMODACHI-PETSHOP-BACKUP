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
        'midtrans_order_id',
        'midtrans_transaction_id',
        'midtrans_payment_type',
        'midtrans_transaction_status',
        'midtrans_fraud_status',
        'midtrans_snap_token',
        'midtrans_redirect_url',
        'midtrans_payload',
        'paid_at',
    ];

    protected $casts = [
        'subtotal' => 'decimal:2',
        'tax' => 'decimal:2',
        'total' => 'decimal:2',
        'amount_paid' => 'decimal:2',
        'change_amount' => 'decimal:2',
        'midtrans_payload' => 'array',
        'paid_at' => 'datetime',
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
