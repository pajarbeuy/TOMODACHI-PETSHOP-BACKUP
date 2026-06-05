import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../product_image_picker.dart';
import '../../product_service.dart';

class ProductsTab extends StatefulWidget {
  final ProductService productService;
  final String userRole; // owner, kasir, admin

  const ProductsTab({
    super.key,
    required this.productService,
    required this.userRole,
  });

  @override
  State<ProductsTab> createState() => _ProductsTabState();
}

class _ProductsTabState extends State<ProductsTab> {
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
  List<dynamic> _categoriesList = [];
  bool _loading = false;
  String? _selectedAnimalType;
  String? _selectedSubCategory;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
    _fetchProducts();
    _searchCtrl.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _fetchProducts();
  }

  Future<void> _fetchCategories() async {
    try {
      final res = await widget.productService.getCategories();
      if (res['status'] == true) {
        setState(() {
          // Flat list of individual categories
          final List<dynamic> list = [];
          for (var group in res['data']) {
            if (group['categories'] != null) {
              list.addAll(group['categories']);
            }
          }
          _categoriesList = list;
        });
      }
    } catch (e) {
      // Silently fail categories load
    }
  }

  Future<void> _fetchProducts() async {
    if (_loading) return;
    setState(() => _loading = true);

    try {
      final res = await widget.productService.getProducts(
        search: _searchCtrl.text.trim(),
        animalType: _selectedAnimalType,
        subCategory: _selectedSubCategory,
      );

      if (res['status'] == true) {
        setState(() {
          _products = res['data'];
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading products: ${e.toString()}'),
            backgroundColor: Colors.red.shade700,
          ),
        );
      }
    } finally {
      setState(() => _loading = false);
    }
  }

  List<String> _availableSubCategories() {
    final subCategories = _categoriesList
        .where(
          (cat) =>
              _selectedAnimalType == null ||
              cat['animal_type'] == _selectedAnimalType,
        )
        .map((cat) => cat['sub_category']?.toString())
        .whereType<String>()
        .where((value) => value.isNotEmpty)
        .toSet()
        .toList();
    subCategories.sort();
    return subCategories;
  }

  void _handleDeleteProduct(String id, String name) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Hapus Produk'),
          content: Text(
            'Apakah Anda yakin ingin menghapus produk "$name"? Data transaksi historis akan tetap tersimpan.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );

    if (confirm != true) return;

    try {
      final res = await widget.productService.deleteProduct(id);
      if (res['status'] == true) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Produk berhasil dihapus (soft delete)'),
            ),
          );
        }
        _fetchProducts();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menghapus produk: ${e.toString()}')),
        );
      }
    }
  }

  void _showProductForm({dynamic product}) {
    final isEdit = product != null;
    final id = isEdit ? product['id'].toString() : null;

    final nameCtrl = TextEditingController(text: isEdit ? product['name'] : '');
    final skuCtrl = TextEditingController(text: isEdit ? product['sku'] : '');
    final buyPriceCtrl = TextEditingController(
      text: isEdit ? product['buy_price']?.toString() ?? '' : '',
    );
    final sellPriceCtrl = TextEditingController(
      text: isEdit ? product['sell_price']?.toString() ?? '' : '',
    );
    final offlineQtyCtrl = TextEditingController(
      text: isEdit ? product['offline_qty']?.toString() ?? '0' : '0',
    );
    final onlineQtyCtrl = TextEditingController(
      text: isEdit ? product['online_qty']?.toString() ?? '0' : '0',
    );
    final minThresholdCtrl = TextEditingController(
      text: isEdit ? product['min_threshold']?.toString() ?? '5' : '5',
    );
    final descCtrl = TextEditingController(
      text: isEdit ? product['description'] ?? '' : '',
    );
    final imgUrlCtrl = TextEditingController(
      text: isEdit ? product['image_url'] ?? '' : '',
    );

    String? selectedCategoryId = isEdit
        ? product['category_id']?.toString()
        : null;
    bool confirmBelowCost = false;
    ProductImageSelection? selectedImage;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                top: 24,
                left: 24,
                right: 24,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          isEdit
                              ? 'Ubah Informasi Produk'
                              : 'Tambah Produk Baru',
                          style: _plusJakarta(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const Divider(height: 20),

                    // Inputs fields
                    TextField(
                      controller: nameCtrl,
                      style: _plusJakarta(fontSize: 14),
                      decoration: const InputDecoration(
                        labelText: 'Nama Produk *',
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: skuCtrl,
                            style: _plusJakarta(fontSize: 14),
                            decoration: const InputDecoration(
                              labelText: 'SKU Produk *',
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            initialValue: selectedCategoryId,
                            style: _plusJakarta(fontSize: 14),
                            decoration: const InputDecoration(
                              labelText: 'Kategori *',
                            ),
                            items: _categoriesList.map((cat) {
                              return DropdownMenuItem<String>(
                                value: cat['id'].toString(),
                                child: Text(
                                  cat['name'],
                                  style: _plusJakarta(fontSize: 13),
                                ),
                              );
                            }).toList(),
                            onChanged: (v) =>
                                setModalState(() => selectedCategoryId = v),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: buyPriceCtrl,
                            keyboardType: TextInputType.number,
                            style: _plusJakarta(fontSize: 14),
                            decoration: const InputDecoration(
                              labelText: 'Harga Beli (Rp) *',
                              prefixText: 'Rp ',
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: sellPriceCtrl,
                            keyboardType: TextInputType.number,
                            style: _plusJakarta(fontSize: 14),
                            decoration: const InputDecoration(
                              labelText: 'Harga Jual (Rp) *',
                              prefixText: 'Rp ',
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: offlineQtyCtrl,
                            keyboardType: TextInputType.number,
                            style: _plusJakarta(fontSize: 14),
                            decoration: const InputDecoration(
                              labelText: 'Stok Offline *',
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: onlineQtyCtrl,
                            keyboardType: TextInputType.number,
                            style: _plusJakarta(fontSize: 14),
                            decoration: const InputDecoration(
                              labelText: 'Stok Online *',
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: minThresholdCtrl,
                            keyboardType: TextInputType.number,
                            style: _plusJakarta(fontSize: 14),
                            decoration: const InputDecoration(
                              labelText: 'Batas Minimum *',
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: imgUrlCtrl,
                      style: _plusJakarta(fontSize: 14),
                      decoration: const InputDecoration(
                        labelText:
                            'URL Foto Produk (Opsional jika tidak upload file)',
                      ),
                      onChanged: (_) => setModalState(() {}),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            icon: const Icon(Icons.upload_file),
                            label: Text(
                              selectedImage == null
                                  ? 'Pilih Foto JPEG/PNG'
                                  : selectedImage!.name,
                              overflow: TextOverflow.ellipsis,
                            ),
                            onPressed: () async {
                              try {
                                final image = await pickProductImage();
                                if (image == null) {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Pemilihan file tidak tersedia di platform ini.',
                                        ),
                                      ),
                                    );
                                  }
                                  return;
                                }

                                final isSupportedType =
                                    image.mimeType == 'image/jpeg' ||
                                    image.mimeType == 'image/png';
                                final isWithinLimit =
                                    image.sizeInBytes <= 2 * 1024 * 1024;

                                if (!isSupportedType || !isWithinLimit) {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Foto harus JPEG/PNG dan maksimal 2MB.',
                                        ),
                                      ),
                                    );
                                  }
                                  return;
                                }

                                setModalState(() {
                                  selectedImage = image;
                                  imgUrlCtrl.clear();
                                });
                              } catch (e) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Gagal memilih foto: ${e.toString()}',
                                      ),
                                    ),
                                  );
                                }
                              }
                            },
                          ),
                        ),
                        if (selectedImage != null) ...[
                          const SizedBox(width: 8),
                          IconButton(
                            tooltip: 'Hapus foto terpilih',
                            icon: const Icon(Icons.close),
                            onPressed: () =>
                                setModalState(() => selectedImage = null),
                          ),
                        ],
                      ],
                    ),
                    if (selectedImage != null ||
                        imgUrlCtrl.text.trim().isNotEmpty) ...[
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          width: double.infinity,
                          height: 160,
                          color: const Color(0xFFFFF7ED),
                          child: selectedImage != null
                              ? Image.memory(
                                  Uint8List.fromList(selectedImage!.bytes),
                                  fit: BoxFit.cover,
                                )
                              : Image.network(
                                  widget.productService.resolveImageUrl(
                                    imgUrlCtrl.text.trim(),
                                  ),
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, _, _) => Center(
                                    child: Text(
                                      'Preview foto tidak dapat dimuat',
                                      style: _plusJakarta(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 12),
                    TextField(
                      controller: descCtrl,
                      maxLines: 2,
                      style: _plusJakarta(fontSize: 14),
                      decoration: const InputDecoration(
                        labelText: 'Deskripsi Produk',
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Actions buttons
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () async {
                          final name = nameCtrl.text.trim();
                          final sku = skuCtrl.text.trim();
                          final buyVal =
                              double.tryParse(buyPriceCtrl.text) ?? 0.0;
                          final sellVal =
                              double.tryParse(sellPriceCtrl.text) ?? 0.0;
                          final offQty = int.tryParse(offlineQtyCtrl.text) ?? 0;
                          final onQty = int.tryParse(onlineQtyCtrl.text) ?? 0;
                          final minThresh =
                              int.tryParse(minThresholdCtrl.text) ?? 5;
                          final desc = descCtrl.text.trim();
                          final imgUrl = imgUrlCtrl.text.trim();

                          if (name.isEmpty ||
                              sku.isEmpty ||
                              selectedCategoryId == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Lengkapi kolom bertanda bintang (*)',
                                ),
                              ),
                            );
                            return;
                          }

                          // 1. Client-side safeguard price validation:
                          if (sellVal < buyVal && !confirmBelowCost) {
                            // Prompt for confirmation
                            final confirmCost = await showDialog<bool>(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Peringatan Harga'),
                                  content: const Text(
                                    'Harga jual lebih rendah dari harga beli! Apakah Anda yakin ingin melanjutkan tindakan ini?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, false),
                                      child: const Text('Ubah Harga'),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, true),
                                      style: TextButton.styleFrom(
                                        foregroundColor: Colors.red,
                                      ),
                                      child: const Text('Ya, Lanjutkan'),
                                    ),
                                  ],
                                );
                              },
                            );

                            if (confirmCost != true) return;
                            setModalState(() {
                              confirmBelowCost = true;
                            });
                          }

                          try {
                            Map<String, dynamic> res;
                            if (isEdit) {
                              res = await widget.productService.updateProduct(
                                id: id!,
                                name: name,
                                sku: sku,
                                categoryId: selectedCategoryId!,
                                buyPrice: buyVal,
                                sellPrice: sellVal,
                                offlineQty: offQty,
                                onlineQty: onQty,
                                minThreshold: minThresh,
                                description: desc,
                                imageUrl: imgUrl.isEmpty ? null : imgUrl,
                                imageBytes: selectedImage?.bytes,
                                imageName: selectedImage?.name,
                                imageMimeType: selectedImage?.mimeType,
                                confirmPriceBelowCost: confirmBelowCost,
                              );
                            } else {
                              res = await widget.productService.createProduct(
                                name: name,
                                sku: sku,
                                categoryId: selectedCategoryId!,
                                buyPrice: buyVal,
                                sellPrice: sellVal,
                                offlineQty: offQty,
                                onlineQty: onQty,
                                minThreshold: minThresh,
                                description: desc,
                                imageUrl: imgUrl.isEmpty ? null : imgUrl,
                                imageBytes: selectedImage?.bytes,
                                imageName: selectedImage?.name,
                                imageMimeType: selectedImage?.mimeType,
                                confirmPriceBelowCost: confirmBelowCost,
                              );
                            }

                            if (res['status'] == true) {
                              if (context.mounted) {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      isEdit
                                          ? 'Produk berhasil diperbarui'
                                          : 'Produk berhasil ditambahkan',
                                    ),
                                  ),
                                );
                              }
                              _fetchProducts();
                            }
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Gagal menyimpan: ${e.toString()}',
                                  ),
                                  backgroundColor: Colors.red.shade700,
                                ),
                              );
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFB570),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          isEdit ? 'SIMPAN PERUBAHAN' : 'TAMBAH PRODUK',
                          style: _plusJakarta(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isOwnerOrAdmin =
        widget.userRole == 'owner' || widget.userRole == 'admin';

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header & Add Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Manajemen Inventori Produk',
                style: _plusJakarta(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              if (isOwnerOrAdmin)
                ElevatedButton.icon(
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: const Text('Tambah Produk'),
                  onPressed: () => _showProductForm(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFB570),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),

          // Search & Filters panel
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchCtrl,
                  style: _plusJakarta(fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'Cari berdasarkan Nama atau SKU...',
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Color(0xFFFFB570),
                    ),
                    filled: true,
                    fillColor: const Color(0xFFFFF9F2),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Animal filters dropdown
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF9F2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedAnimalType,
                    hint: Text(
                      'Filter Hewan',
                      style: _plusJakarta(fontSize: 13, color: Colors.grey),
                    ),
                    items: [
                      DropdownMenuItem<String>(
                        value: null,
                        child: Text(
                          'Semua Hewan',
                          style: _plusJakarta(fontSize: 13),
                        ),
                      ),
                      DropdownMenuItem<String>(
                        value: 'cat',
                        child: Text(
                          '🐈 Kucing',
                          style: _plusJakarta(fontSize: 13),
                        ),
                      ),
                      DropdownMenuItem<String>(
                        value: 'dog',
                        child: Text(
                          '🐕 Anjing',
                          style: _plusJakarta(fontSize: 13),
                        ),
                      ),
                      DropdownMenuItem<String>(
                        value: 'hamster',
                        child: Text(
                          '🐹 Hamster',
                          style: _plusJakarta(fontSize: 13),
                        ),
                      ),
                    ],
                    onChanged: (v) {
                      setState(() {
                        _selectedAnimalType = v;
                        _selectedSubCategory = null;
                      });
                      _fetchProducts();
                    },
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF9F2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedSubCategory,
                    hint: Text(
                      'Sub-kategori',
                      style: _plusJakarta(fontSize: 13, color: Colors.grey),
                    ),
                    items: [
                      DropdownMenuItem<String>(
                        value: null,
                        child: Text(
                          'Semua Sub-kategori',
                          style: _plusJakarta(fontSize: 13),
                        ),
                      ),
                      ..._availableSubCategories().map((subCategory) {
                        return DropdownMenuItem<String>(
                          value: subCategory,
                          child: Text(
                            subCategory,
                            style: _plusJakarta(fontSize: 13),
                          ),
                        );
                      }),
                    ],
                    onChanged: (v) {
                      setState(() {
                        _selectedSubCategory = v;
                      });
                      _fetchProducts();
                    },
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Table / List of products
          Expanded(child: _buildProductsList()),
        ],
      ),
    );
  }

  Widget _buildProductsList() {
    if (_loading && _products.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_products.isEmpty) {
      return Center(
        child: Text(
          'Tidak ada data produk ditemukan.',
          style: _plusJakarta(color: Colors.grey),
        ),
      );
    }

    final isOwner = widget.userRole == 'owner';
    final isOwnerOrAdmin =
        widget.userRole == 'owner' || widget.userRole == 'admin';

    return ListView.builder(
      itemCount: _products.length,
      itemBuilder: (context, index) {
        final prod = _products[index];
        final id = prod['id'].toString();
        final name = prod['name'];
        final sku = prod['sku'];
        final sellPrice = double.parse(prod['sell_price'].toString());
        final offlineQty = int.parse(
          (prod['stock']?['offline_qty'] ?? 0).toString(),
        );
        final minThresh = int.parse(
          (prod['stock']?['min_threshold'] ?? 5).toString(),
        );
        final String? img = prod['image_url'];
        final imageUrl = img != null && img.isNotEmpty
            ? widget.productService.resolveImageUrl(img)
            : null;

        final isLowStock = offlineQty <= minThresh;

        // Margin info (only accessible by Owner)
        final marginPct = isOwner
            ? prod['margin_percentage']?.toString() ?? '0'
            : null;
        final buyPrice = isOwner
            ? double.tryParse(prod['buy_price']?.toString() ?? '0')
            : null;

        return Card(
          color: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Colors.grey.shade100),
          ),
          margin: const EdgeInsets.only(bottom: 10),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Image
                Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFDF9),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: imageUrl != null
                      ? Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) =>
                              const Icon(Icons.pets, color: Color(0xFFFFB570)),
                        )
                      : const Icon(Icons.pets, color: Color(0xFFFFB570)),
                ),
                const SizedBox(width: 14),

                // Core Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: _plusJakarta(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'SKU: $sku',
                        style: _plusJakarta(
                          fontSize: 11,
                          color: Colors.grey.shade500,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Text(
                            'Jual: Rp ${sellPrice.toStringAsFixed(0)}',
                            style: _plusJakarta(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFFFF9A4D),
                            ),
                          ),
                          if (isOwner && buyPrice != null) ...[
                            const SizedBox(width: 12),
                            Text(
                              'Beli: Rp ${buyPrice.toStringAsFixed(0)}',
                              style: _plusJakarta(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),

                // Stocks & Margin KPIs
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: isLowStock
                            ? const Color(0xFFFFF0F1)
                            : const Color(0xFFF0FDF4),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            isLowStock
                                ? Icons.warning_amber
                                : Icons.check_circle_outline,
                            size: 13,
                            color: isLowStock ? Colors.red : Colors.green,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Stok: $offlineQty',
                            style: _plusJakarta(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: isLowStock
                                  ? Colors.red.shade700
                                  : Colors.green.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                    if (isOwner && marginPct != null)
                      Text(
                        'Margin: $marginPct%',
                        style: _plusJakarta(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo.shade700,
                        ),
                      ),
                  ],
                ),

                // Edit/Delete buttons (For owner and admin only)
                if (isOwnerOrAdmin) ...[
                  const SizedBox(width: 12),
                  PopupMenuButton<String>(
                    onSelected: (action) {
                      if (action == 'edit') {
                        _showProductForm(product: prod);
                      } else if (action == 'delete') {
                        _handleDeleteProduct(id, name);
                      }
                    },
                    itemBuilder: (context) {
                      return [
                        PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              const Icon(
                                Icons.edit,
                                size: 16,
                                color: Colors.blue,
                              ),
                              const SizedBox(width: 8),
                              Text('Ubah', style: _plusJakarta(fontSize: 13)),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              const Icon(
                                Icons.delete,
                                size: 16,
                                color: Colors.red,
                              ),
                              const SizedBox(width: 8),
                              Text('Hapus', style: _plusJakarta(fontSize: 13)),
                            ],
                          ),
                        ),
                      ];
                    },
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
