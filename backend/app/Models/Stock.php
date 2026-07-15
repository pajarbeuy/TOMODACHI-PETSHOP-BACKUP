<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Stock extends Model
{
    use HasFactory;

    protected $fillable = [
        'product_id',
        'offline_qty',
        'online_qty',
        'min_threshold',
        'last_updated',
    ];

    protected $casts = [
        'last_updated' => 'datetime',
    ];

    protected static function booted()
    {
        static::updated(function ($stock) {
            $isOfflineLow = $stock->offline_qty <= $stock->min_threshold;
            $wasOfflineLow = $stock->getOriginal('offline_qty') <= $stock->getOriginal('min_threshold');

            $isOnlineLow = $stock->online_qty <= $stock->min_threshold;
            $wasOnlineLow = $stock->getOriginal('online_qty') <= $stock->getOriginal('min_threshold');

            $offlineTriggered = $isOfflineLow && !$wasOfflineLow;
            $onlineTriggered = $isOnlineLow && !$wasOnlineLow;

            if ($offlineTriggered || $onlineTriggered) {
                $type = 'both';
                if ($offlineTriggered && !$onlineTriggered) {
                    $type = 'offline';
                } elseif ($onlineTriggered && !$offlineTriggered) {
                    $type = 'online';
                }

                try {
                    $owners = \App\Models\User::whereHas('role', function ($query) {
                        $query->where('name', 'owner');
                    })->get();

                    if ($owners->isNotEmpty()) {
                        \Illuminate\Support\Facades\Notification::send(
                            $owners,
                            new \App\Notifications\LowStockAlert($stock, $type)
                        );
                    }
                } catch (\Throwable $e) {
                    \Illuminate\Support\Facades\Log::error('Gagal mengirim notifikasi stok menipis: ' . $e->getMessage(), [
                        'exception' => $e
                    ]);
                }
            }
        });
    }

    public function product()
    {
        return $this->belongsTo(Product::class);
    }
}
