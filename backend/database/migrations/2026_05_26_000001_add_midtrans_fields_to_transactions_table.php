<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('transactions', function (Blueprint $table) {
            $table->string('midtrans_order_id')->nullable()->unique()->after('status');
            $table->string('midtrans_transaction_id')->nullable()->after('midtrans_order_id');
            $table->string('midtrans_payment_type')->nullable()->after('midtrans_transaction_id');
            $table->string('midtrans_transaction_status')->nullable()->after('midtrans_payment_type');
            $table->string('midtrans_fraud_status')->nullable()->after('midtrans_transaction_status');
            $table->string('midtrans_snap_token')->nullable()->after('midtrans_fraud_status');
            $table->text('midtrans_redirect_url')->nullable()->after('midtrans_snap_token');
            $table->json('midtrans_payload')->nullable()->after('midtrans_redirect_url');
            $table->timestamp('paid_at')->nullable()->after('midtrans_payload');

            $table->index(['midtrans_transaction_status', 'created_at']);
        });
    }

    public function down(): void
    {
        Schema::table('transactions', function (Blueprint $table) {
            $table->dropIndex(['midtrans_transaction_status', 'created_at']);
            $table->dropColumn([
                'midtrans_order_id',
                'midtrans_transaction_id',
                'midtrans_payment_type',
                'midtrans_transaction_status',
                'midtrans_fraud_status',
                'midtrans_snap_token',
                'midtrans_redirect_url',
                'midtrans_payload',
                'paid_at',
            ]);
        });
    }
};
