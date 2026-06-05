import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../payment_url_launcher.dart';
import '../../product_service.dart';
import '../../transaction_service.dart';

class PosTab extends StatefulWidget {
  final ProductService productService;
  final TransactionService transactionService;

  const PosTab({
    super.key,
    required this.productService,
    required this.transactionService,
  });

  @override
  State<PosTab> createState() => _PosTabState();
}

class _PosTabState extends State<PosTab> {
  // Styles helper
  TextStyle _plusJakarta({
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.w500,
    Color color = const Color(0xFF3D2314),
    double letterSpacing = -0.3,
  }) => GoogleFonts.plusJakartaSans(
    fontSize: fontSize,
    fontWeight: fontWeight,
    color: color,
    letterSpacing: letterSpacing,
  );

  final _searchCtrl = TextEditingController();
  List<dynamic> _products = [];
  List<dynamic> _categories = [];
  String? _selectedAnimalType;
  String? _selectedSubCategory;
  bool _loadingProducts = false;
  
  // Cart items: Map of productId -> CartItem
  final Map<String, Map<String, dynamic>> _cart = {};

  // Checkout inputs
  String _paymentMethod = 'cash';
  final _amountPaidCtrl = TextEditingController();
  double _change = 0.0;
  bool _submittingCheckout = false;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
    _fetchProducts();
    _searchCtrl.addListener(_onSearchChanged);
    _amountPaidCtrl.addListener(_onAmountPaidChanged);
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _amountPaidCtrl.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _fetchProducts();
  }

  void _onAmountPaidChanged() {
    _calculateChange();
  }

  Future<void> _fetchCategories() async {
    try {
      final res = await widget.productService.getCategories();
      if (res['status'] == true) {
        setState(() {
          _categories = res['data'];
        });
      }
    } catch (e) {
      // Silently fail categories
    }
  }

  Future<void> _fetchProducts() async {
    if (_loadingProducts) return;
    setState(() => _loadingProducts = true);

    try {
      final res = await widget.productService.getProducts(
        search: _searchCtrl.text.trim(),
        animalType: _selectedAnimalType,
        subCategory: _selectedSubCategory,
        channel: 'offline',
        inStock: true, // Only fetch items with stock > 0
      );

      if (res['status'] == true) {
        setState(() {
          _products = res['data'];
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load products: ${e.toString()}')),
        );
      }
    } finally {
      setState(() => _loadingProducts = false);
    }
  }

  // Cart operations
  void _addToCart(dynamic prod) {
    final String id = prod['id'].toString();
    final String name = prod['name'];
    final double price = double.parse(prod['sell_price'].toString());
    final int maxStock = int.parse((prod['stock']?['offline_qty'] ?? 0).toString());

    setState(() {
      if (_cart.containsKey(id)) {
        final currentQty = _cart[id]!['quantity'] as int;
        if (currentQty < maxStock) {
          _cart[id]!['quantity'] = currentQty + 1;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Cannot exceed available stock ($maxStock)')),
          );
        }
      } else {
        _cart[id] = {
          'product_id': int.parse(id),
          'name': name,
          'unit_price': price,
          'quantity': 1,
          'max_stock': maxStock,
        };
      }
      _calculateChange();
    });
  }

  void _updateQuantity(String id, int delta) {
    setState(() {
      if (_cart.containsKey(id)) {
        final currentQty = _cart[id]!['quantity'] as int;
        final maxStock = _cart[id]!['max_stock'] as int;
        final nextQty = currentQty + delta;

        if (nextQty <= 0) {
          _cart.remove(id);
        } else if (nextQty <= maxStock) {
          _cart[id]!['quantity'] = nextQty;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Cannot exceed available stock ($maxStock)')),
          );
        }
        _calculateChange();
      }
    });
  }

  double _getCartSubtotal() {
    double sub = 0.0;
    _cart.forEach((_, item) {
      sub += (item['unit_price'] as double) * (item['quantity'] as int);
    });
    return sub;
  }

  void _calculateChange() {
    final sub = _getCartSubtotal();
    final paid = double.tryParse(_amountPaidCtrl.text) ?? 0.0;
    setState(() {
      _change = paid > sub ? paid - sub : 0.0;
    });
  }

  void _handleCheckout() async {
    final sub = _getCartSubtotal();
    if (sub <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cart is empty.')),
      );
      return;
    }

    final paid = double.tryParse(_amountPaidCtrl.text) ?? 0.0;
    if (paid < sub && _paymentMethod == 'cash') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Insufficient paid amount.')),
      );
      return;
    }

    setState(() => _submittingCheckout = true);

    try {
      final itemsList = _cart.values.map((item) {
        return {
          'product_id': item['product_id'],
          'quantity': item['quantity'],
          'unit_price': item['unit_price'],
        };
      }).toList();

      final res = await widget.transactionService.checkout(
        channel: 'offline',
        paymentMethod: _paymentMethod,
        amountPaid: _paymentMethod == 'cash' ? paid : sub,
        items: itemsList,
      );

      if (res['status'] == true) {
        final trxId = res['data']['transaction_id'];
        final payment = res['data']['payment'];
        final redirectUrl = payment is Map ? payment['redirect_url']?.toString() : null;

        if (redirectUrl != null && redirectUrl.isNotEmpty) {
          final opened = await openPaymentUrl(redirectUrl);
          if (mounted) {
            _showPaymentPendingDialog(trxId, redirectUrl, opened);
          }
        } else if (mounted) {
          _showReceiptDialog(trxId);
        }

        // Clear state
        setState(() {
          _cart.clear();
          _amountPaidCtrl.clear();
          _change = 0.0;
        });

        // Re-fetch products to update stock quantities
        _fetchProducts();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Checkout failed: ${e.toString()}'),
            backgroundColor: Colors.red.shade700,
          ),
        );
      }
    } finally {
      setState(() => _submittingCheckout = false);
    }
  }

  void _showPaymentPendingDialog(String transactionId, String paymentUrl, bool opened) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFFFFFDF9),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Column(
            children: [
              const Icon(Icons.qr_code_2, color: Color(0xFFFF9A4D), size: 54),
              const SizedBox(height: 8),
              Text(
                'MENUNGGU PEMBAYARAN',
                style: _plusJakarta(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: SizedBox(
            width: 340,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('No: $transactionId', style: _plusJakarta(fontSize: 12, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Text(
                  opened
                      ? 'Halaman pembayaran Midtrans sudah dibuka. Status akan berubah otomatis setelah webhook Midtrans diterima.'
                      : 'Tidak bisa membuka browser otomatis. Buka URL pembayaran ini secara manual:',
                  style: _plusJakarta(fontSize: 12, color: Colors.grey.shade700),
                ),
                if (!opened) ...[
                  const SizedBox(height: 10),
                  SelectableText(paymentUrl, style: _plusJakarta(fontSize: 11, color: const Color(0xFFFF9A4D))),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(foregroundColor: const Color(0xFFFFB570)),
              child: Text('Tutup', style: _plusJakarta(fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  void _showReceiptDialog(String transactionId) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return FutureBuilder<Map<String, dynamic>>(
          future: widget.transactionService.getReceipt(transactionId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError || snapshot.data?['status'] != true) {
              return AlertDialog(
                title: const Text('Error loading receipt'),
                content: const Text('Transaction was completed, but receipt could not be fetched.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('OK'),
                  )
                ],
              );
            }

            final data = snapshot.data!['data'];
            final items = data['items'] as List<dynamic>;

            return AlertDialog(
              backgroundColor: const Color(0xFFFFFDF9),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: Column(
                children: [
                  const Icon(Icons.check_circle, color: Colors.green, size: 54),
                  const SizedBox(height: 8),
                  Text(
                    'TRANSAKSI BERHASIL',
                    style: _plusJakarta(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              content: SingleChildScrollView(
                child: SizedBox(
                  width: 320,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Divider(thickness: 1.5, height: 20),
                      Text('No: ${data['transaction_id']}', style: _plusJakarta(fontSize: 12, fontWeight: FontWeight.bold)),
                      Text('Waktu: ${data['transaction_date'].substring(0, 19).replaceFirst('T', ' ')}', style: _plusJakarta(fontSize: 12, color: Colors.grey.shade600)),
                      Text('Kasir: ${data['kasir_name']}', style: _plusJakarta(fontSize: 12, color: Colors.grey.shade600)),
                      const Divider(thickness: 1.5, height: 20),
                      ...items.map((item) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(item['product_name'], style: _plusJakarta(fontSize: 13, fontWeight: FontWeight.bold)),
                                    Text('${item['quantity']}x Rp ${item['unit_price']}', style: _plusJakarta(fontSize: 11, color: Colors.grey.shade600)),
                                  ],
                                ),
                              ),
                              Text('Rp ${item['subtotal']}', style: _plusJakarta(fontSize: 13, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        );
                      }),
                      const Divider(thickness: 1.5, height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Subtotal', style: _plusJakarta(fontSize: 13)),
                          Text('Rp ${data['subtotal']}', style: _plusJakarta(fontSize: 13)),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Pajak (0%)', style: _plusJakarta(fontSize: 13)),
                          Text('Rp ${data['tax']}', style: _plusJakarta(fontSize: 13)),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Total', style: _plusJakarta(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xFF3D2314))),
                          Text('Rp ${data['total']}', style: _plusJakarta(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xFF3D2314))),
                        ],
                      ),
                      const Divider(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Metode Pembayaran', style: _plusJakarta(fontSize: 12)),
                          Text(data['payment_method'].toString().toUpperCase(), style: _plusJakarta(fontSize: 12, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Bayar', style: _plusJakarta(fontSize: 13)),
                          Text('Rp ${data['amount_paid']}', style: _plusJakarta(fontSize: 13)),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Kembalian', style: _plusJakarta(fontSize: 13, fontWeight: FontWeight.bold)),
                          Text('Rp ${data['change']}', style: _plusJakarta(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.green)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Center(
                        child: Text(
                          '~ Terima Kasih atas Kunjungan Anda ~',
                          style: _plusJakarta(fontSize: 11, color: Colors.grey.shade500),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFFFFB570),
                  ),
                  child: Text('Tutup', style: _plusJakarta(fontWeight: FontWeight.bold)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth >= 1000;

    final productsArea = Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSearchAndFilters(),
          const SizedBox(height: 16),
          Expanded(child: _buildProductsGrid()),
        ],
      ),
    );

    if (!isWide) {
      return Stack(
        children: [
          productsArea,
          Positioned(
            right: 16,
            bottom: 16,
            child: FloatingActionButton.extended(
              onPressed: _openCartSheet,
              backgroundColor: const Color(0xFFFFB570),
              foregroundColor: Colors.white,
              icon: const Icon(Icons.shopping_cart),
              label: Text('${_cart.length} Item - Rp ${_getCartSubtotal().toStringAsFixed(0)}'),
            ),
          ),
        ],
      );
    }

    return Row(
      children: [
        // Left Column: Search, filters, products grid
        Expanded(
          flex: isWide ? 68 : 100,
          child: productsArea,
        ),

        // Right Column: Shopping Cart (Only in wide layouts, otherwise drawer/overlay can be used)
        if (isWide)
          Container(
            width: screenWidth * 0.32,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(left: BorderSide(color: Colors.grey.shade200)),
            ),
            child: _buildCartPanel(),
          ),
      ],
    );
  }

  void _openCartSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.82,
            child: _buildCartPanel(),
          ),
        );
      },
    );
  }

  Widget _buildSearchAndFilters() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Search bar
        TextField(
          controller: _searchCtrl,
          style: _plusJakarta(fontSize: 14),
          decoration: InputDecoration(
            hintText: 'Cari produk berdasarkan nama atau SKU...',
            prefixIcon: const Icon(Icons.search, color: Color(0xFFFFB570)),
            filled: true,
            fillColor: const Color(0xFFFFF9F2),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Animal Type Filters
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildFilterChip(label: 'Semua Hewan', animalType: null),
              _buildFilterChip(label: '🐈 Kucing', animalType: 'cat'),
              _buildFilterChip(label: '🐕 Anjing', animalType: 'dog'),
              _buildFilterChip(label: '🐹 Hamster', animalType: 'hamster'),
              _buildFilterChip(label: '🐇 Kelinci', animalType: 'rabbit'),
              _buildFilterChip(label: '🐟 Ikan', animalType: 'fish'),
              _buildFilterChip(label: '🦜 Burung', animalType: 'bird'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChip({required String label, required String? animalType}) {
    final isSelected = _selectedAnimalType == animalType;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(
          label,
          style: _plusJakarta(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? Colors.white : const Color(0xFF3D2314),
          ),
        ),
        selected: isSelected,
        selectedColor: const Color(0xFFFFB570),
        backgroundColor: const Color(0xFFFFFDFB),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(999),
          side: BorderSide(
            color: isSelected ? const Color(0xFFFFB570) : const Color(0x33FFB570),
          ),
        ),
        onSelected: (selected) {
          setState(() {
            _selectedAnimalType = animalType;
          });
          _fetchProducts();
        },
      ),
    );
  }

  Widget _buildProductsGrid() {
    if (_loadingProducts && _products.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_products.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.pets, size: 54, color: Color(0xFFE2D6CD)),
            const SizedBox(height: 12),
            Text(
              'Tidak ada produk tersedia',
              style: _plusJakarta(fontSize: 15, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 220,
        childAspectRatio: 0.72,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
      ),
      itemCount: _products.length,
      itemBuilder: (context, index) {
        final prod = _products[index];
        final String name = prod['name'];
        final String sku = prod['sku'];
        final double price = double.parse(prod['sell_price'].toString());
        final int stock = int.parse((prod['stock']?['offline_qty'] ?? 0).toString());
        final String? img = prod['image_url'];

        return Card(
          color: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: BorderSide(color: Colors.grey.shade100),
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () => _addToCart(prod),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image or icon
                Expanded(
                  child: Container(
                    width: double.infinity,
                    color: const Color(0xFFFFFDF9),
                    child: img != null && img.isNotEmpty
                        ? Image.network(img, fit: BoxFit.cover, errorBuilder: (_, _, _) => const Icon(Icons.pets, size: 36, color: Color(0xFFFFD4A8)))
                        : const Icon(Icons.pets, size: 36, color: Color(0xFFFFD4A8)),
                  ),
                ),

                // Name & Info
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: _plusJakarta(fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'SKU: $sku',
                        style: _plusJakarta(fontSize: 10, color: Colors.grey.shade500),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Rp ${price.toStringAsFixed(0)}',
                            style: _plusJakarta(fontSize: 13, fontWeight: FontWeight.w900, color: const Color(0xFFFF9A4D)),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFDF1E8),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'Stok: $stock',
                              style: _plusJakarta(fontSize: 10, fontWeight: FontWeight.bold, color: const Color(0xFFE27F3B)),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCartPanel() {
    final subtotal = _getCartSubtotal();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Cart Header
        Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.shopping_cart, color: Color(0xFFFFB570)),
                  const SizedBox(width: 8),
                  Text(
                    'Keranjang Belanja',
                    style: _plusJakarta(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3E6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${_cart.length} Item',
                  style: _plusJakarta(fontSize: 12, fontWeight: FontWeight.bold, color: const Color(0xFFFF9A4D)),
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1),

        // Cart items list
        Expanded(
          child: _cart.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.shopping_cart_outlined, size: 54, color: Color(0xFFE2D6CD)),
                      const SizedBox(height: 12),
                      Text(
                        'Keranjang kosong',
                        style: _plusJakarta(fontSize: 14, color: Colors.grey),
                      )
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  itemCount: _cart.length,
                  itemBuilder: (context, index) {
                    final item = _cart.values.elementAt(index);
                    final String id = item['product_id'].toString();
                    final String name = item['name'];
                    final double price = item['unit_price'];
                    final int qty = item['quantity'];

                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFFDFB),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFFFF3E5)),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: _plusJakarta(fontSize: 13, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Rp ${price.toStringAsFixed(0)}',
                                  style: _plusJakarta(fontSize: 12, color: Colors.grey.shade600),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove_circle_outline, size: 20, color: Color(0xFFFF9A4D)),
                                onPressed: () => _updateQuantity(id, -1),
                              ),
                              Text('$qty', style: _plusJakarta(fontSize: 13, fontWeight: FontWeight.bold)),
                              IconButton(
                                icon: const Icon(Icons.add_circle_outline, size: 20, color: Color(0xFFFF9A4D)),
                                onPressed: () => _updateQuantity(id, 1),
                              ),
                            ],
                          )
                        ],
                      ),
                    );
                  },
                ),
        ),
        const Divider(height: 1),

        // Calculations & Payment Form
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Subtotal', style: _plusJakarta(fontSize: 14)),
                  Text('Rp ${subtotal.toStringAsFixed(0)}', style: _plusJakarta(fontSize: 14, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 12),

              // Payment Method Selectors
              Row(
                children: [
                  Expanded(child: _buildPaymentMethodBtn('Tunai', 'cash', Icons.money)),
                  const SizedBox(width: 8),
                  Expanded(child: _buildPaymentMethodBtn('QRIS/TF', 'qris', Icons.qr_code)),
                ],
              ),
              const SizedBox(height: 16),

              // Paid Amount (Cash only)
              if (_paymentMethod == 'cash') ...[
                TextField(
                  controller: _amountPaidCtrl,
                  keyboardType: TextInputType.number,
                  style: _plusJakarta(fontSize: 14, fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                    labelText: 'Nominal Bayar (Rp)',
                    labelStyle: _plusJakarta(fontSize: 12, color: Colors.grey),
                    prefixText: 'Rp ',
                    filled: true,
                    fillColor: const Color(0xFFFFFDF9),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFFFB570)),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Kembalian', style: _plusJakarta(fontSize: 14)),
                    Text(
                      'Rp ${_change.toStringAsFixed(0)}',
                      style: _plusJakarta(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.green.shade700),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],

              // Checkout Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: (_submittingCheckout || subtotal <= 0) ? null : _handleCheckout,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFB570),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: _submittingCheckout
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : Text(
                          'BAYAR SEKARANG',
                          style: _plusJakarta(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget _buildPaymentMethodBtn(String label, String value, IconData icon) {
    final isSelected = _paymentMethod == value;
    return OutlinedButton.icon(
      icon: Icon(icon, size: 18, color: isSelected ? Colors.white : const Color(0xFF3D2314)),
      label: Text(
        label,
        style: _plusJakarta(
          fontSize: 13,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          color: isSelected ? Colors.white : const Color(0xFF3D2314),
        ),
      ),
      onPressed: () {
        setState(() {
          _paymentMethod = value;
          if (value != 'cash') {
            _amountPaidCtrl.clear();
            _change = 0.0;
          }
        });
      },
      style: OutlinedButton.styleFrom(
        backgroundColor: isSelected ? const Color(0xFFFFB570) : Colors.white,
        side: BorderSide(
          color: isSelected ? const Color(0xFFFFB570) : const Color(0x33FFB570),
          width: 1.5,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
    );
  }
}
