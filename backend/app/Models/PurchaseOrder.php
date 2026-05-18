<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class PurchaseOrder extends Model
{
    use HasFactory;

    protected $fillable = [
        'po_number',
        'created_by',
        'status',
        'supplier_name',
        'notes',
        'total',
        'ordered_at',
        'received_at',
    ];

    protected $casts = [
        'total' => 'decimal:2',
        'ordered_at' => 'datetime',
        'received_at' => 'datetime',
    ];

    public function creator()
    {
        return $this->belongsTo(User::class, 'created_by');
    }

    public function items()
    {
        return $this->hasMany(PurchaseOrderItem::class);
    }
}
