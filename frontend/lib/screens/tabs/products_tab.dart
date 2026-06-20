import 'dart:async';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../product_image_picker.dart';
import '../../product_service.dart';
import '../../utils/currency_formatter.dart';
import '../../utils/error_message.dart';

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
    double letterSpacing = 0,
  }) => GoogleFonts.plusJakartaSans(
    fontSize: fontSize,
    fontWeight: fontWeight,
    color: color,
    letterSpacing: letterSpacing,
  );

  final _searchCtrl = TextEditingController();
  Timer? _searchDebounce;
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
    _searchDebounce?.cancel();
    _searchCtrl.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    if (mounted) {
      setState(() {});
    }
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 300), _fetchProducts);
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
            content: Text(userFriendlyError(e, fallback: 'Gagal memuat produk')),
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
          SnackBar(
            content: Text(
              userFriendlyError(e, fallback: 'Gagal menghapus produk'),
            ),
          ),
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
      text: isEdit ? formatCurrencyInput(product['buy_price']) : '',
    );
    final sellPriceCtrl = TextEditingController(
      text: isEdit ? formatCurrencyInput(product['sell_price']) : '',
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

    InputDecoration modalInputDecoration(
      String label, {
      String? prefixText,
      String? hintText,
    }) {
      return InputDecoration(
        labelText: label,
        hintText: hintText,
        prefixText: prefixText,
        isDense: true,
        filled: true,
        fillColor: const Color(0xFFFFF9F2),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.brown.shade100),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.brown.shade100),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFFFB570), width: 1.4),
        ),
      );
    }

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
                top: 22,
                left: 20,
                right: 20,
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
                        Expanded(
                          child: Text(
                            isEdit
                                ? 'Ubah Informasi Produk'
                                : 'Tambah Produk Baru',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: _plusJakarta(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
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
                      decoration: modalInputDecoration('Nama Produk *'),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: skuCtrl,
                      style: _plusJakarta(fontSize: 14),
                      decoration: modalInputDecoration('SKU Produk *'),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: selectedCategoryId,
                      isExpanded: true,
                      style: _plusJakarta(fontSize: 14),
                      decoration: modalInputDecoration('Kategori *'),
                      items: _categoriesList.map((cat) {
                        return DropdownMenuItem<String>(
                          value: cat['id'].toString(),
                          child: Text(
                            cat['name'],
                            overflow: TextOverflow.ellipsis,
                            style: _plusJakarta(fontSize: 13),
                          ),
                        );
                      }).toList(),
                      onChanged: (v) =>
                          setModalState(() => selectedCategoryId = v),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: buyPriceCtrl,
                      keyboardType: TextInputType.number,
                      inputFormatters: [RupiahInputFormatter()],
                      style: _plusJakarta(fontSize: 14),
                      decoration: modalInputDecoration(
                        'Harga Beli *',
                        prefixText: 'Rp ',
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: sellPriceCtrl,
                      keyboardType: TextInputType.number,
                      inputFormatters: [RupiahInputFormatter()],
                      style: _plusJakarta(fontSize: 14),
                      decoration: modalInputDecoration(
                        'Harga Jual *',
                        prefixText: 'Rp ',
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: offlineQtyCtrl,
                            keyboardType: TextInputType.number,
                            style: _plusJakarta(fontSize: 14),
                            decoration: modalInputDecoration('Stok Offline *'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: onlineQtyCtrl,
                            keyboardType: TextInputType.number,
                            style: _plusJakarta(fontSize: 14),
                            decoration: modalInputDecoration('Stok Online *'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: minThresholdCtrl,
                      keyboardType: TextInputType.number,
                      style: _plusJakarta(fontSize: 14),
                      decoration: modalInputDecoration('Batas Minimum *'),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: imgUrlCtrl,
                      style: _plusJakarta(fontSize: 14),
                      decoration: modalInputDecoration(
                        'URL Foto Produk',
                        hintText: 'Opsional jika tidak upload file',
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
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFF8A5A2B),
                              minimumSize: const Size.fromHeight(48),
                              side: BorderSide(color: Colors.brown.shade200),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
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
                                        userFriendlyError(
                                          e,
                                          fallback: 'Gagal memilih foto',
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        if (selectedImage != null)
                          IconButton(
                            tooltip: 'Hapus foto terpilih',
                            icon: const Icon(Icons.close),
                            onPressed: () =>
                                setModalState(() => selectedImage = null),
                          ),
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
                              : CachedNetworkImage(
                                  imageUrl: widget.productService.resolveImageUrl(
                                    imgUrlCtrl.text.trim(),
                                  ),
                                  fit: BoxFit.cover,
                                  errorWidget: (context, url, error) => Center(
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
                      maxLines: 3,
                      style: _plusJakarta(fontSize: 14),
                      decoration: modalInputDecoration('Deskripsi Produk'),
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
                          final buyVal = parseCurrency(buyPriceCtrl.text);
                          final sellVal = parseCurrency(sellPriceCtrl.text);
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
                                    userFriendlyError(
                                      e,
                                      fallback: 'Gagal menyimpan produk',
                                    ),
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
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
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
    final screenWidth = MediaQuery.of(context).size.width;
    final isCompact = screenWidth < 430;

    return Padding(
      padding: EdgeInsets.all(isCompact ? 16 : 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header & Add Button
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  'Manajemen Inventori Produk',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: _plusJakarta(
                    fontSize: isCompact ? 17 : 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (isOwnerOrAdmin)
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: ElevatedButton(
                    onPressed: () => _showProductForm(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFB570),
                      foregroundColor: Colors.white,
                      minimumSize: Size(isCompact ? 44 : 0, 44),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: isCompact ? 12 : 16,
                        vertical: 12,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.add, color: Colors.white),
                        if (!isCompact) ...[
                          const SizedBox(width: 8),
                          Text(
                            'Tambah Produk',
                            style: _plusJakarta(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),

          // Search & Filters panel
          if (isCompact)
            Column(
              children: [
                _buildSearchField(),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(child: _buildAnimalDropdown()),
                    const SizedBox(width: 10),
                    Expanded(child: _buildSubCategoryDropdown()),
                  ],
                ),
              ],
            )
          else
            Row(
              children: [
                Expanded(flex: 3, child: _buildSearchField()),
                const SizedBox(width: 12),
                Expanded(flex: 2, child: _buildAnimalDropdown()),
                const SizedBox(width: 12),
                Expanded(flex: 2, child: _buildSubCategoryDropdown()),
              ],
            ),
          const SizedBox(height: 16),

          // Table / List of products
          Expanded(child: _buildProductsList()),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchCtrl,
      style: _plusJakarta(fontSize: 14),
      decoration: InputDecoration(
        hintText: 'Cari nama atau SKU...',
        prefixIcon: const Icon(Icons.search, color: Color(0xFFFFB570)),
        filled: true,
        fillColor: const Color(0xFFFFF9F2),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildAnimalDropdown() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9F2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedAnimalType,
          isExpanded: true,
          hint: Text(
            'Hewan',
            overflow: TextOverflow.ellipsis,
            style: _plusJakarta(fontSize: 13, color: Colors.grey),
          ),
          items: [
            DropdownMenuItem<String>(
              value: null,
              child: Text(
                'Semua Hewan',
                overflow: TextOverflow.ellipsis,
                style: _plusJakarta(fontSize: 13),
              ),
            ),
            DropdownMenuItem<String>(
              value: 'cat',
              child: Text(
                'Kucing',
                overflow: TextOverflow.ellipsis,
                style: _plusJakarta(fontSize: 13),
              ),
            ),
            DropdownMenuItem<String>(
              value: 'dog',
              child: Text(
                'Anjing',
                overflow: TextOverflow.ellipsis,
                style: _plusJakarta(fontSize: 13),
              ),
            ),
            DropdownMenuItem<String>(
              value: 'hamster',
              child: Text(
                'Hamster',
                overflow: TextOverflow.ellipsis,
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
    );
  }

  Widget _buildSubCategoryDropdown() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9F2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedSubCategory,
          isExpanded: true,
          hint: Text(
            'Sub-kategori',
            overflow: TextOverflow.ellipsis,
            style: _plusJakarta(fontSize: 13, color: Colors.grey),
          ),
          items: [
            DropdownMenuItem<String>(
              value: null,
              child: Text(
                'Semua Sub-kategori',
                overflow: TextOverflow.ellipsis,
                style: _plusJakarta(fontSize: 13),
              ),
            ),
            ..._availableSubCategories().map((subCategory) {
              return DropdownMenuItem<String>(
                value: subCategory,
                child: Text(
                  subCategory,
                  overflow: TextOverflow.ellipsis,
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
    final isCompact = MediaQuery.of(context).size.width < 430;

    return ListView.builder(
      itemCount: _products.length,
      itemBuilder: (context, index) {
        final prod = _products[index];
        final id = prod['id'].toString();
        final name = prod['name']?.toString() ?? '-';
        final sku = prod['sku']?.toString() ?? '-';
        final sellPrice = parseCurrency(prod['sell_price']);
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
        final buyPrice = isOwner ? parseCurrency(prod['buy_price']) : null;

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
                  width: isCompact ? 54 : 58,
                  height: isCompact ? 54 : 58,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFDF9),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: imageUrl != null
                      ? CachedNetworkImage(
                          imageUrl: imageUrl,
                          fit: BoxFit.cover,
                          errorWidget: (context, url, error) =>
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
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: _plusJakarta(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'SKU: $sku',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: _plusJakarta(
                          fontSize: 11,
                          color: Colors.grey.shade500,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Jual: ${formatRupiah(sellPrice)}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: _plusJakarta(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFFF9A4D),
                        ),
                      ),
                      if (isOwner && buyPrice != null) ...[
                        const SizedBox(height: 3),
                        Text(
                          'Beli: ${formatRupiah(buyPrice)}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: _plusJakarta(
                            fontSize: 11,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
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
                        mainAxisSize: MainAxisSize.min,
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
                      SizedBox(
                        width: isCompact ? 86 : 110,
                        child: Text(
                          'Margin: $marginPct%',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.end,
                          style: _plusJakarta(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo.shade700,
                          ),
                        ),
                      ),
                  ],
                ),

                // Edit/Delete buttons (For owner and admin only)
                if (isOwnerOrAdmin) ...[
                  SizedBox(width: isCompact ? 4 : 12),
                  SizedBox(
                    width: 34,
                    height: 40,
                    child: PopupMenuButton<String>(
                      padding: EdgeInsets.zero,
                      iconSize: 22,
                      constraints: const BoxConstraints(minWidth: 128),
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
                                Text(
                                  'Hapus',
                                  style: _plusJakarta(fontSize: 13),
                                ),
                              ],
                            ),
                          ),
                        ];
                      },
                    ),
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
