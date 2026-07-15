<?php

namespace App\Notifications;

use Illuminate\Bus\Queueable;
use Illuminate\Notifications\Messages\MailMessage;
use Illuminate\Notifications\Notification;
use App\Models\Stock;

class LowStockAlert extends Notification
{
    use Queueable;

    public Stock $stock;
    public string $type; // 'offline' or 'online' or 'both'

    /**
     * Create a new notification instance.
     */
    public function __construct(Stock $stock, string $type)
    {
        $this->stock = $stock;
        $this->type = $type;
    }

    /**
     * Get the notification's delivery channels.
     *
     * @return array<int, string>
     */
    public function via(object $notifiable): array
    {
        return ['mail'];
    }

    /**
     * Get the mail representation of the notification.
     */
    public function toMail(object $notifiable): MailMessage
    {
        $product = $this->stock->product;
        $sku = $product ? $product->sku : 'N/A';
        $name = $product ? $product->name : 'Produk Tidak Dikenal';
        $offlineQty = $this->stock->offline_qty;
        $onlineQty = $this->stock->online_qty;
        $minThreshold = $this->stock->min_threshold;

        $subject = "🚨 [PERINGATAN] Stok Menipis: {$name}";

        $mailMessage = (new MailMessage)
            ->subject($subject)
            ->greeting("Halo Owner Tomodachi Pet Shop,")
            ->line("Produk berikut terdeteksi memiliki sisa stok di bawah batas minimum (threshold) yang aman:");

        if ($this->type === 'offline') {
            $mailMessage->line("🔴 **Stok Offline**: {$offlineQty} unit (Batas Minimum: {$minThreshold})");
        } elseif ($this->type === 'online') {
            $mailMessage->line("🔵 **Stok Online**: {$onlineQty} unit (Batas Minimum: {$minThreshold})");
        } else {
            $mailMessage->line("⚠️ **Stok Offline & Online Menipis**:")
                ->line("- Sisa Offline: {$offlineQty} unit")
                ->line("- Sisa Online: {$onlineQty} unit")
                ->line("- Batas Minimum: {$minThreshold}");
        }

        return $mailMessage
            ->line("")
            ->line("**Detail Informasi Produk:**")
            ->line("• **Nama Produk**: {$name}")
            ->line("• **SKU / Kode**: {$sku}")
            ->action('Buka Analisis Restock', env('LOW_STOCK_REDIRECT_URL', url('/')))
            ->line("Segera hubungi supplier atau lakukan restock agar penjualan produk tidak terhenti. Terima kasih!");
    }
}
