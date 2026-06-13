import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/app_logo.dart';

// ─── Model ────────────────────────────────────────────────────────────────────
class Product {
  final int id;
  String name;
  String category;
  String description;
  int price;
  int stock;
  int minStock;
  String status;
  String emoji;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.price,
    required this.stock,
    required this.minStock,
    required this.status,
    required this.emoji,
  });

  Product copyWith({
    String? name,
    String? category,
    String? description,
    int? price,
    int? stock,
    int? minStock,
    String? status,
    String? emoji,
  }) => Product(
    id: id,
    name: name ?? this.name,
    category: category ?? this.category,
    description: description ?? this.description,
    price: price ?? this.price,
    stock: stock ?? this.stock,
    minStock: minStock ?? this.minStock,
    status: status ?? this.status,
    emoji: emoji ?? this.emoji,
  );
}

// ─── Initial data ─────────────────────────────────────────────────────────────
final _initialProducts = <Product>[
  Product(
    id: 1,
    name: 'Royal Canin Adult Dog Food 2kg',
    category: 'Food',
    description: 'Premium dog food for adult dogs',
    price: 145000,
    stock: 24,
    minStock: 10,
    status: 'active',
    emoji: '🐕',
  ),
  Product(
    id: 2,
    name: 'Whiskas Tuna Cat Food 1.2kg',
    category: 'Food',
    description: 'Delicious tuna flavor cat food',
    price: 65000,
    stock: 8,
    minStock: 15,
    status: 'active',
    emoji: '🐈',
  ),
  Product(
    id: 3,
    name: 'Kong Classic Dog Toy',
    category: 'Toys',
    description: 'Durable chew toy for dogs',
    price: 89000,
    stock: 35,
    minStock: 8,
    status: 'active',
    emoji: '🦴',
  ),
  Product(
    id: 4,
    name: 'Cat Scratching Post Premium',
    category: 'Accessories',
    description: 'Tall scratching post with base',
    price: 125000,
    stock: 0,
    minStock: 5,
    status: 'inactive',
    emoji: '🐈',
  ),
  Product(
    id: 5,
    name: 'Dog Shampoo Premium 500ml',
    category: 'Grooming',
    description: 'Gentle formula for all breeds',
    price: 55000,
    stock: 15,
    minStock: 10,
    status: 'active',
    emoji: '🛁',
  ),
  Product(
    id: 6,
    name: 'Aquarium Starter Kit 20L',
    category: 'Accessories',
    description: 'Complete starter kit for fish',
    price: 350000,
    stock: 5,
    minStock: 3,
    status: 'active',
    emoji: '🐠',
  ),
  Product(
    id: 7,
    name: 'Hamster Running Wheel 20cm',
    category: 'Accessories',
    description: 'Silent spinner for hamsters',
    price: 45000,
    stock: 20,
    minStock: 8,
    status: 'active',
    emoji: '🐹',
  ),
  Product(
    id: 8,
    name: 'Frontline Plus Antiparasitic',
    category: 'Medicine',
    description: 'Monthly flea & tick treatment',
    price: 145000,
    stock: 18,
    minStock: 10,
    status: 'active',
    emoji: '💊',
  ),
  Product(
    id: 9,
    name: 'Cat Litter Silica Gel 5kg',
    category: 'Accessories',
    description: 'Odor control silica gel litter',
    price: 85000,
    stock: 3,
    minStock: 10,
    status: 'active',
    emoji: '🐈',
  ),
  Product(
    id: 10,
    name: 'Bird Cage Medium Decorative',
    category: 'Accessories',
    description: 'Elegant cage for parrots',
    price: 275000,
    stock: 7,
    minStock: 5,
    status: 'active',
    emoji: '🦜',
  ),
  Product(
    id: 11,
    name: 'Pedigree Puppy Food 1.5kg',
    category: 'Food',
    description: 'Nutritious food for puppies',
    price: 95000,
    stock: 12,
    minStock: 10,
    status: 'active',
    emoji: '🐕',
  ),
  Product(
    id: 12,
    name: 'Cat Treat Temptations 85g',
    category: 'Food',
    description: 'Irresistible cat treats',
    price: 25000,
    stock: 45,
    minStock: 15,
    status: 'active',
    emoji: '🐈',
  ),
];

const _categories = ['Food', 'Toys', 'Grooming', 'Accessories', 'Medicine'];
const _emojiOptions = [
  '🐕',
  '🐈',
  '🦴',
  '🎾',
  '🛁',
  '💊',
  '🐠',
  '🐹',
  '🦜',
  '🌿',
  '📦',
  '✂️',
];

// ─── Helpers ──────────────────────────────────────────────────────────────────
String formatRp(int n) {
  final s = n.toString();
  final buf = StringBuffer('Rp ');
  final rem = s.length % 3;
  for (int i = 0; i < s.length; i++) {
    if (i != 0 && (i - rem) % 3 == 0) buf.write('.');
    buf.write(s[i]);
  }
  return buf.toString();
}

class _StockStatus {
  final String label;
  final Color bg;
  final Color fg;
  final Color dot;
  const _StockStatus({
    required this.label,
    required this.bg,
    required this.fg,
    required this.dot,
  });
}

_StockStatus getStockStatus(int stock, int minStock) {
  if (stock == 0) {
    return const _StockStatus(
      label: 'Out of Stock',
      bg: Color(0xFFFFD4D4),
      fg: Color(0xFFC0392B),
      dot: Color(0xFFFF6B6B),
    );
  }
  if (stock <= minStock * 0.5) {
    return const _StockStatus(
      label: 'Critical',
      bg: Color(0xFFFFD4D4),
      fg: Color(0xFFC0392B),
      dot: Color(0xFFFF6B6B),
    );
  }
  if (stock <= minStock) {
    return const _StockStatus(
      label: 'Low Stock',
      bg: Color(0xFFFFF0CC),
      fg: Color(0xFF8B6914),
      dot: Color(0xFFFFB570),
    );
  }
  return const _StockStatus(
    label: 'In Stock',
    bg: Color(0xFFD4F5EE),
    fg: Color(0xFF1B7A65),
    dot: Color(0xFFB8F2E6),
  );
}

// ─── Main Screen ──────────────────────────────────────────────────────────────
class ProductManagementScreen extends StatefulWidget {
  const ProductManagementScreen({super.key});

  @override
  State<ProductManagementScreen> createState() =>
      _ProductManagementScreenState();
}

class _ProductManagementScreenState extends State<ProductManagementScreen> {
  List<Product> _products = List.from(_initialProducts);
  final _searchCtrl = TextEditingController();
  String _search = '';
  String _categoryFilter = 'All';
  String _statusFilter = 'All';
  int _currentPage = 1;
  static const int _perPage = 8;

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<Product> get _filtered {
    return _products.where((p) {
      final matchSearch = p.name.toLowerCase().contains(_search.toLowerCase());
      final matchCat =
          _categoryFilter == 'All' || p.category == _categoryFilter;
      bool matchStatus;
      switch (_statusFilter) {
        case 'active':
          matchStatus = p.status == 'active';
          break;
        case 'inactive':
          matchStatus = p.status == 'inactive';
          break;
        case 'low':
          matchStatus = p.stock > 0 && p.stock <= p.minStock;
          break;
        case 'out':
          matchStatus = p.stock == 0;
          break;
        default:
          matchStatus = true;
      }
      return matchSearch && matchCat && matchStatus;
    }).toList();
  }

  void _openAdd() => _showProductModal(context, null);
  void _openEdit(Product p) => _showProductModal(context, p);

  void _confirmDelete(Product p) {
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (_) => _DeleteDialog(
        product: p,
        onConfirm: () {
          setState(() => _products.removeWhere((x) => x.id == p.id));
        },
      ),
    );
  }

  void _showProductModal(BuildContext ctx, Product? editing) {
    showDialog(
      context: ctx,
      barrierColor: Colors.black54,
      builder: (_) => _ProductModal(
        product: editing,
        isEdit: editing != null,
        onSave: (updated) {
          setState(() {
            if (editing != null) {
              final idx = _products.indexWhere((x) => x.id == editing.id);
              if (idx != -1) _products[idx] = updated;
            } else {
              // Generate new ID
              final newId = _products.isEmpty
                  ? 1
                  : _products.map((x) => x.id).reduce((a, b) => a > b ? a : b) +
                        1;
              _products.add(
                Product(
                  id: newId,
                  name: updated.name,
                  category: updated.category,
                  description: updated.description,
                  price: updated.price,
                  stock: updated.stock,
                  minStock: updated.minStock,
                  status: updated.status,
                  emoji: updated.emoji,
                ),
              );
            }
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;
    final totalPages = (filtered.length / _perPage).ceil().clamp(1, 999);
    final page = _currentPage.clamp(1, totalPages);
    final paged = filtered.skip((page - 1) * _perPage).take(_perPage).toList();

    final statsTotal = _products.length;
    final statsActive = _products.where((p) => p.status == 'active').length;
    final statsLow = _products
        .where((p) => p.stock > 0 && p.stock <= p.minStock)
        .length;
    final statsOut = _products.where((p) => p.stock == 0).length;

    // ✅ Wrap with Material so Dropdown & other Material widgets work
    return Material(
      color: const Color(0xFFFFF6E9),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──────────────────────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: const [
                      AppLogo(size: 44),
                      SizedBox(width: 12),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Product Management',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF3D2314),
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Manage your petshop inventory',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF9B7B6B),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                _GradientButton(
                  onPressed: _openAdd,
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add, size: 18, color: Colors.white),
                      SizedBox(width: 6),
                      Text(
                        'Add Product',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // ── Stats cards ──────────────────────────────────────────────────
            Row(
              children: [
                _statCard(
                  'Total Products',
                  statsTotal,
                  '📦',
                  const Color(0xFFFFF6E9),
                  const Color(0xFFFF9A4D),
                ),
                const SizedBox(width: 12),
                _statCard(
                  'Active',
                  statsActive,
                  '✅',
                  const Color(0xFFF0FDF9),
                  const Color(0xFF1B7A65),
                ),
                const SizedBox(width: 12),
                _statCard(
                  'Low Stock',
                  statsLow,
                  '⚠️',
                  const Color(0xFFFFF8E8),
                  const Color(0xFF8B6914),
                ),
                const SizedBox(width: 12),
                _statCard(
                  'Out of Stock',
                  statsOut,
                  '❌',
                  const Color(0xFFFFF0F0),
                  const Color(0xFFC0392B),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // ── Filters ──────────────────────────────────────────────────────
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0x1FFFB570), width: 1),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x08000000),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Search
                  Expanded(
                    child: TextField(
                      controller: _searchCtrl,
                      onChanged: (v) => setState(() {
                        _search = v;
                        _currentPage = 1;
                      }),
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF3D2314),
                      ),
                      decoration: InputDecoration(
                        hintText: 'Search products by name...',
                        hintStyle: const TextStyle(
                          color: Color(0xFFC5A882),
                          fontSize: 13,
                        ),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Color(0xFFC5A882),
                          size: 18,
                        ),
                        filled: true,
                        fillColor: const Color(0xFFFFF8F2),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0x33FFB570),
                            width: 2,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFFFB570),
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Category dropdown
                  _FilterDropdown(
                    value: _categoryFilter,
                    items: const [
                      'All',
                      'Food',
                      'Toys',
                      'Grooming',
                      'Accessories',
                      'Medicine',
                    ],
                    labels: const [
                      'All Categories',
                      'Food',
                      'Toys',
                      'Grooming',
                      'Accessories',
                      'Medicine',
                    ],
                    onChanged: (v) => setState(() {
                      _categoryFilter = v;
                      _currentPage = 1;
                    }),
                  ),
                  const SizedBox(width: 12),
                  // Status dropdown
                  _FilterDropdown(
                    value: _statusFilter,
                    items: const ['All', 'active', 'inactive', 'low', 'out'],
                    labels: const [
                      'All Status',
                      'Active',
                      'Inactive',
                      'Low Stock',
                      'Out of Stock',
                    ],
                    onChanged: (v) => setState(() {
                      _statusFilter = v;
                      _currentPage = 1;
                    }),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ── Table ────────────────────────────────────────────────────────
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0x1FFFB570), width: 1),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x08000000),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                    child: Text(
                      '${filtered.length} products found',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3D2314),
                      ),
                    ),
                  ),

                  const Divider(height: 1, color: Color(0x1FFFB570)),

                  if (filtered.isEmpty) _emptyState() else _buildTable(paged),

                  const Divider(height: 1, color: Color(0x1AFFB570)),

                  // Pagination
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Showing ${paged.length} of ${_products.length} products',
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF9B7B6B),
                          ),
                        ),
                        Row(
                          children: List.generate(totalPages.clamp(1, 10), (i) {
                            final n = i + 1;
                            final active = n == page;
                            return Padding(
                              padding: const EdgeInsets.only(left: 4),
                              child: GestureDetector(
                                onTap: () => setState(() => _currentPage = n),
                                child: Container(
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    color: active
                                        ? const Color(0xFFFFB570)
                                        : const Color(0xFFFFF0E0),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '$n',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: active
                                            ? Colors.white
                                            : const Color(0xFF9B7B6B),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _statCard(String label, int value, String icon, Color bg, Color fg) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0x26FFB570), width: 1),
          boxShadow: const [
            BoxShadow(
              color: Color(0x06000000),
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF9B7B6B),
                  ),
                ),
                Text(icon, style: const TextStyle(fontSize: 18)),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              '$value',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                color: fg,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTable(List<Product> rows) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: MediaQuery.of(context).size.width - 48,
        ),
        child: Table(
          columnWidths: const {
            0: FlexColumnWidth(3),
            1: FlexColumnWidth(1.4),
            2: FlexColumnWidth(1.6),
            3: FlexColumnWidth(1.8),
            4: FlexColumnWidth(2.2),
            5: FlexColumnWidth(1.4),
          },
          children: [
            TableRow(
              decoration: const BoxDecoration(
                color: Color(0xFFFFF8F2),
                border: Border(
                  bottom: BorderSide(color: Color(0x1FFFB570), width: 1),
                ),
              ),
              children:
                  ['PRODUCT', 'CATEGORY', 'PRICE', 'STOCK', 'STATUS', 'ACTIONS']
                      .map(
                        (h) => Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          child: Text(
                            h,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF9B7B6B),
                              letterSpacing: 0.8,
                            ),
                          ),
                        ),
                      )
                      .toList(),
            ),
            ...rows.map((p) => _buildRow(p)),
          ],
        ),
      ),
    );
  }

  TableRow _buildRow(Product p) {
    final ss = getStockStatus(p.stock, p.minStock);
    return TableRow(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0x0DFFB570), width: 1)),
      ),
      children: [
        // Product
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF0E0),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(p.emoji, style: const TextStyle(fontSize: 20)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      p.name,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3D2314),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      p.description,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF9B7B6B),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Category
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF0E0),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                p.category,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFFF9A4D),
                ),
              ),
            ),
          ),
        ),
        // Price
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Text(
            formatRp(p.price),
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w900,
              color: Color(0xFF3D2314),
            ),
          ),
        ),
        // Stock
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: ss.dot,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                '${p.stock}',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3D2314),
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '/ min ${p.minStock}',
                style: const TextStyle(fontSize: 11, color: Color(0xFF9B7B6B)),
              ),
            ],
          ),
        ),
        // Status
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: ss.bg,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  ss.label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: ss.fg,
                  ),
                ),
              ),
              if (p.status == 'inactive') ...[
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F0F0),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Inactive',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF9B7B6B),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        // Actions
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            children: [
              _ActionBtn(
                color: const Color(0xFFFFF0E0),
                iconColor: const Color(0xFFFF9A4D),
                icon: Icons.edit_outlined,
                onTap: () => _openEdit(p),
              ),
              const SizedBox(width: 6),
              _ActionBtn(
                color: const Color(0xFFFFD4D4),
                iconColor: const Color(0xFFC0392B),
                icon: Icons.delete_outline,
                onTap: () => _confirmDelete(p),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _emptyState() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 64),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.inventory_2_outlined,
              size: 48,
              color: Color(0xFFC5A882),
            ),
            SizedBox(height: 12),
            Text(
              'No products found',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFFC5A882),
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Try adjusting your search or filters',
              style: TextStyle(fontSize: 12, color: Color(0xFFC5A882)),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Reusable widgets ─────────────────────────────────────────────────────────

class _GradientButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;
  const _GradientButton({required this.child, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFB570), Color(0xFFFF9A4D)],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x4DFF9650),
            blurRadius: 14,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: child,
      ),
    );
  }
}

class _FilterDropdown extends StatelessWidget {
  final String value;
  final List<String> items;
  final List<String> labels;
  final ValueChanged<String> onChanged;

  const _FilterDropdown({
    required this.value,
    required this.items,
    required this.labels,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    // ✅ Wrap with Material to fix "No Material widget found" error
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF8F2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0x33FFB570), width: 2),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: value,
            icon: const Icon(
              Icons.keyboard_arrow_down,
              size: 18,
              color: Color(0xFFC5A882),
            ),
            style: const TextStyle(fontSize: 13, color: Color(0xFF3D2314)),
            dropdownColor: Colors.white,
            items: List.generate(
              items.length,
              (i) => DropdownMenuItem(value: items[i], child: Text(labels[i])),
            ),
            onChanged: (v) {
              if (v != null) onChanged(v);
            },
          ),
        ),
      ),
    );
  }
}

class _ActionBtn extends StatefulWidget {
  final Color color;
  final Color iconColor;
  final IconData icon;
  final VoidCallback onTap;
  const _ActionBtn({
    required this.color,
    required this.iconColor,
    required this.icon,
    required this.onTap,
  });

  @override
  State<_ActionBtn> createState() => _ActionBtnState();
}

class _ActionBtnState extends State<_ActionBtn> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: _hover ? widget.color.withOpacity(0.7) : widget.color,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(widget.icon, size: 15, color: widget.iconColor),
        ),
      ),
    );
  }
}

// ─── Product Modal ────────────────────────────────────────────────────────────
class _ProductModal extends StatefulWidget {
  final Product? product;
  final bool isEdit;
  final void Function(Product) onSave;

  const _ProductModal({
    required this.product,
    required this.isEdit,
    required this.onSave,
  });

  @override
  State<_ProductModal> createState() => _ProductModalState();
}

class _ProductModalState extends State<_ProductModal> {
  late String _name;
  late String _category;
  late String _description;
  late String _status;
  late String _emoji;

  late TextEditingController _nameCtrl;
  late TextEditingController _descCtrl;
  late TextEditingController _priceCtrl;
  late TextEditingController _stockCtrl;
  late TextEditingController _minStockCtrl;

  @override
  void initState() {
    super.initState();
    final p = widget.product;
    _name = p?.name ?? '';
    _category = p?.category ?? 'Food';
    _description = p?.description ?? '';
    _status = p?.status ?? 'active';
    _emoji = p?.emoji ?? '📦';

    _nameCtrl = TextEditingController(text: _name);
    _descCtrl = TextEditingController(text: _description);
    _priceCtrl = TextEditingController(
      text: (p?.price ?? 0) == 0 ? '' : '${p!.price}',
    );
    _stockCtrl = TextEditingController(
      text: (p?.stock ?? 0) == 0 ? '' : '${p!.stock}',
    );
    _minStockCtrl = TextEditingController(
      text: p?.minStock == null ? '5' : '${p!.minStock}',
    );
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    _priceCtrl.dispose();
    _stockCtrl.dispose();
    _minStockCtrl.dispose();
    super.dispose();
  }

  void _save() {
    final saved = Product(
      id: widget.product?.id ?? 0,
      name: _nameCtrl.text.trim(),
      category: _category,
      description: _descCtrl.text.trim(),
      price: int.tryParse(_priceCtrl.text) ?? 0,
      stock: int.tryParse(_stockCtrl.text) ?? 0,
      minStock: int.tryParse(_minStockCtrl.text) ?? 5,
      status: _status,
      emoji: _emoji,
    );
    widget.onSave(saved);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 520, maxHeight: 700),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: const [
            BoxShadow(
              color: Color(0x33000000),
              blurRadius: 60,
              offset: Offset(0, 20),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Sticky header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                border: Border(
                  bottom: BorderSide(color: Color(0x26FFB570), width: 1),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.isEdit ? '✏️  Edit Product' : '➕  Add New Product',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF3D2314),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF0E0),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.close,
                        size: 16,
                        color: Color(0xFF6B4F3E),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Scrollable body
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Emoji display area
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF8F2),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0x66FFB570),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(_emoji, style: const TextStyle(fontSize: 48)),
                          const SizedBox(height: 8),
                          const Text(
                            'Select icon below',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF9B7B6B),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Emoji picker
                    _label('Product Icon'),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _emojiOptions.map((e) {
                        final active = _emoji == e;
                        return GestureDetector(
                          onTap: () => setState(() => _emoji = e),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 120),
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: active
                                  ? const Color(0xFFFFB570)
                                  : const Color(0xFFFFF0E0),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                e,
                                style: const TextStyle(fontSize: 18),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 16),

                    _label('Product Name *'),
                    const SizedBox(height: 6),
                    _textField(_nameCtrl, 'Enter product name'),

                    const SizedBox(height: 14),

                    // Category + Status
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _label('Category *'),
                              const SizedBox(height: 6),
                              _dropField(
                                value: _category,
                                items: _categories,
                                onChanged: (v) => setState(() => _category = v),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _label('Status'),
                              const SizedBox(height: 6),
                              _dropField(
                                value: _status,
                                items: const ['active', 'inactive'],
                                labels: const ['Active', 'Inactive'],
                                onChanged: (v) => setState(() => _status = v),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    _label('Description'),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _descCtrl,
                      maxLines: 2,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF3D2314),
                      ),
                      decoration: _inputDeco('Short product description'),
                    ),

                    const SizedBox(height: 14),

                    // Price / Stock / MinStock
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _label('Price (Rp) *'),
                              const SizedBox(height: 6),
                              _textField(_priceCtrl, '0', isNumber: true),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _label('Stock'),
                              const SizedBox(height: 6),
                              _textField(_stockCtrl, '0', isNumber: true),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _label('Min. Stock'),
                              const SizedBox(height: 6),
                              _textField(_minStockCtrl, '5', isNumber: true),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Sticky footer
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(24),
                ),
                border: Border(
                  top: BorderSide(color: Color(0x26FFB570), width: 1),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: TextButton.styleFrom(
                        backgroundColor: const Color(0xFFFFF0E0),
                        foregroundColor: const Color(0xFF6B4F3E),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFFB570), Color(0xFFFF9A4D)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x4DFF9650),
                            blurRadius: 14,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: _save,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          widget.isEdit ? 'Save Changes' : 'Add Product',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) => Text(
    text,
    style: const TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.bold,
      color: Color(0xFF5A3D2B),
    ),
  );

  InputDecoration _inputDeco(String hint) => InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(color: Color(0xFFC5A882), fontSize: 13),
    filled: true,
    fillColor: const Color(0xFFFFF8F2),
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0x40FFB570), width: 2),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFFFFB570), width: 2),
    ),
  );

  Widget _textField(
    TextEditingController ctrl,
    String hint, {
    bool isNumber = false,
  }) {
    return TextField(
      controller: ctrl,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      inputFormatters: isNumber
          ? [FilteringTextInputFormatter.digitsOnly]
          : null,
      style: const TextStyle(fontSize: 13, color: Color(0xFF3D2314)),
      decoration: _inputDeco(hint),
    );
  }

  Widget _dropField({
    required String value,
    required List<String> items,
    List<String>? labels,
    required ValueChanged<String> onChanged,
  }) {
    // ✅ Wrap with Material to fix dropdown error inside Dialog
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF8F2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0x40FFB570), width: 2),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: value,
            isExpanded: true,
            dropdownColor: Colors.white,
            icon: const Icon(
              Icons.keyboard_arrow_down,
              size: 16,
              color: Color(0xFFC5A882),
            ),
            style: const TextStyle(fontSize: 13, color: Color(0xFF3D2314)),
            items: List.generate(
              items.length,
              (i) => DropdownMenuItem(
                value: items[i],
                child: Text(labels != null ? labels[i] : items[i]),
              ),
            ),
            onChanged: (v) {
              if (v != null) onChanged(v);
            },
          ),
        ),
      ),
    );
  }
}

// ─── Delete Dialog ────────────────────────────────────────────────────────────
class _DeleteDialog extends StatelessWidget {
  final Product product;
  final VoidCallback onConfirm;

  const _DeleteDialog({required this.product, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 360),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: const [
            BoxShadow(
              color: Color(0x33000000),
              blurRadius: 60,
              offset: Offset(0, 20),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: const Color(0xFFFFD4D4),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.delete_outline,
                size: 28,
                color: Color(0xFFC0392B),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Delete Product?',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: Color(0xFF3D2314),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "You're about to delete:",
              style: TextStyle(fontSize: 13, color: Color(0xFF6B4F3E)),
            ),
            const SizedBox(height: 6),
            Text(
              '${product.emoji} ${product.name}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Color(0xFF3D2314),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'This action cannot be undone.',
              style: TextStyle(fontSize: 11, color: Color(0xFF9B7B6B)),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFFF5E8D5),
                      foregroundColor: const Color(0xFF6B4F3E),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFF6B6B), Color(0xFFE05252)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        onConfirm();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Delete',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
