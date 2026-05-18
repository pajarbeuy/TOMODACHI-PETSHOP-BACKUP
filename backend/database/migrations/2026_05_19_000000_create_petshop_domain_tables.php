<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('categories', function (Blueprint $table) {
            $table->id();
            $table->string('name');
            $table->string('animal_type')->index();
            $table->string('sub_category')->index();
            $table->text('description')->nullable();
            $table->timestamps();

            $table->unique(['animal_type', 'sub_category']);
        });

        Schema::create('customers', function (Blueprint $table) {
            $table->id();
            $table->string('name');
            $table->string('email')->nullable()->unique();
            $table->string('phone')->nullable();
            $table->text('address')->nullable();
            $table->string('city')->nullable();
            $table->string('postal_code')->nullable();
            $table->timestamps();
        });

        Schema::create('products', function (Blueprint $table) {
            $table->id();
            $table->foreignId('category_id')->constrained()->cascadeOnUpdate()->restrictOnDelete();
            $table->string('name');
            $table->string('sku')->unique();
            $table->decimal('buy_price', 15, 2);
            $table->decimal('sell_price', 15, 2);
            $table->text('description')->nullable();
            $table->string('image_url')->nullable();
            $table->timestamps();
            $table->softDeletes();
        });

        Schema::create('stocks', function (Blueprint $table) {
            $table->id();
            $table->foreignId('product_id')->constrained()->cascadeOnUpdate()->cascadeOnDelete();
            $table->enum('channel', ['offline', 'online']);
            $table->unsignedInteger('quantity')->default(0);
            $table->unsignedInteger('min_threshold')->default(5);
            $table->timestamp('last_updated_at')->nullable();
            $table->timestamps();

            $table->unique(['product_id', 'channel']);
        });

        Schema::create('transactions', function (Blueprint $table) {
            $table->id();
            $table->string('transaction_code')->unique();
            $table->foreignId('kasir_id')->constrained('users')->cascadeOnUpdate()->restrictOnDelete();
            $table->foreignId('customer_id')->nullable()->constrained()->cascadeOnUpdate()->nullOnDelete();
            $table->enum('channel', ['offline', 'online'])->index();
            $table->enum('status', ['pending', 'completed', 'cancelled'])->default('completed')->index();
            $table->decimal('subtotal', 15, 2);
            $table->decimal('tax', 15, 2)->default(0);
            $table->decimal('total', 15, 2);
            $table->enum('payment_method', ['cash', 'qris', 'transfer']);
            $table->decimal('amount_paid', 15, 2);
            $table->decimal('change_amount', 15, 2)->default(0);
            $table->timestamps();

            $table->index('created_at');
        });

        Schema::create('transaction_items', function (Blueprint $table) {
            $table->id();
            $table->foreignId('transaction_id')->constrained()->cascadeOnUpdate()->cascadeOnDelete();
            $table->foreignId('product_id')->nullable()->constrained()->cascadeOnUpdate()->nullOnDelete();
            $table->string('product_name');
            $table->string('product_sku');
            $table->unsignedInteger('quantity');
            $table->decimal('unit_price', 15, 2);
            $table->decimal('subtotal', 15, 2);
            $table->timestamps();

            $table->index('product_id');
        });

        Schema::create('purchase_orders', function (Blueprint $table) {
            $table->id();
            $table->string('po_number')->unique();
            $table->foreignId('created_by')->constrained('users')->cascadeOnUpdate()->restrictOnDelete();
            $table->enum('status', ['draft', 'ordered', 'received', 'cancelled'])->default('draft');
            $table->string('supplier_name')->nullable();
            $table->text('notes')->nullable();
            $table->decimal('total', 15, 2)->default(0);
            $table->timestamp('ordered_at')->nullable();
            $table->timestamp('received_at')->nullable();
            $table->timestamps();
        });

        Schema::create('purchase_order_items', function (Blueprint $table) {
            $table->id();
            $table->foreignId('purchase_order_id')->constrained()->cascadeOnUpdate()->cascadeOnDelete();
            $table->foreignId('product_id')->constrained()->cascadeOnUpdate()->restrictOnDelete();
            $table->unsignedInteger('quantity');
            $table->decimal('unit_cost', 15, 2);
            $table->decimal('subtotal', 15, 2);
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('purchase_order_items');
        Schema::dropIfExists('purchase_orders');
        Schema::dropIfExists('transaction_items');
        Schema::dropIfExists('transactions');
        Schema::dropIfExists('stocks');
        Schema::dropIfExists('products');
        Schema::dropIfExists('customers');
        Schema::dropIfExists('categories');
    }
};
