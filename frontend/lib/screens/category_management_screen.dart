import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../category_service.dart';
import '../utils/error_message.dart';
import '../widgets/app_motion.dart';

class CategoryManagementScreen extends StatefulWidget {
  final CategoryService categoryService;

  const CategoryManagementScreen({super.key, required this.categoryService});

  @override
  State<CategoryManagementScreen> createState() =>
      _CategoryManagementScreenState();
}

class _CategoryManagementScreenState extends State<CategoryManagementScreen>
    with TickerProviderStateMixin {
  static const _pageBg = Color(0xFFFFFDF9);
  static const _cardBg = Color(0xFFFFFBF6);
  static const _fieldBg = Color(0xFFF6EDE4);
  static const _brown900 = Color(0xFF3D2314);
  static const _brown700 = Color(0xFF5D4037);
  static const _brown400 = Color(0xFF9E8F85);
  static const _red = Color(0xFFC7153D);
  static const _fabBg = Color(0xFFFFEAD4);

  final _nameCtrl = TextEditingController();
  final _animalCtrl = TextEditingController();
  final _subCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _searchCtrl = TextEditingController();

  late final AnimationController _listController;
  List<Map<String, dynamic>> _categories = [];
  bool _loading = true;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _listController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _searchCtrl.addListener(_handleSearchChanged);
    _load();
  }

  @override
  void dispose() {
    _listController.dispose();
    _nameCtrl.dispose();
    _animalCtrl.dispose();
    _subCtrl.dispose();
    _descCtrl.dispose();
    _searchCtrl
      ..removeListener(_handleSearchChanged)
      ..dispose();
    super.dispose();
  }

  void _handleSearchChanged() {
    final nextQuery = _searchCtrl.text.trim().toLowerCase();
    if (nextQuery == _query) return;
    setState(() => _query = nextQuery);
    _restartListAnimation();
  }

  void _restartListAnimation() {
    _listController
      ..reset()
      ..forward();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final rows = await widget.categoryService.getCategories();
      if (!mounted) return;
      setState(() => _categories = rows);
      _restartListAnimation();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(userFriendlyError(e))));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  List<Map<String, dynamic>> get _filteredCategories {
    if (_query.isEmpty) return _categories;
    return _categories.where((category) {
      final name = category['name']?.toString().toLowerCase() ?? '';
      final animal = category['animal_type']?.toString().toLowerCase() ?? '';
      final sub = category['sub_category']?.toString().toLowerCase() ?? '';
      final desc = category['description']?.toString().toLowerCase() ?? '';
      return name.contains(_query) ||
          animal.contains(_query) ||
          sub.contains(_query) ||
          desc.contains(_query);
    }).toList();
  }

  Future<void> _openForm([Map<String, dynamic>? category]) async {
    final editing = category != null;
    _nameCtrl.text = category?['name']?.toString() ?? '';
    _animalCtrl.text = category?['animal_type']?.toString() ?? '';
    _subCtrl.text = category?['sub_category']?.toString() ?? '';
    _descCtrl.text = category?['description']?.toString() ?? '';

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: _pageBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 22,
            bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  editing ? 'Edit Kategori' : 'Tambah Kategori',
                  style: _text(size: 18, weight: FontWeight.w900),
                ),
                const SizedBox(height: 16),
                _field(_nameCtrl, 'Nama kategori'),
                const SizedBox(height: 12),
                _field(_animalCtrl, 'Kode hewan, contoh: cat, dog'),
                const SizedBox(height: 12),
                _field(_subCtrl, 'Sub kategori, contoh: food'),
                const SizedBox(height: 12),
                _field(_descCtrl, 'Deskripsi', maxLines: 2),
                const SizedBox(height: 18),
                AppBounceTap(
                  onTap: () async {
                    final name = _nameCtrl.text.trim();
                    final animal = _animalCtrl.text.trim().toLowerCase();
                    final sub = _subCtrl.text.trim().toLowerCase();
                    if (name.isEmpty || animal.isEmpty || sub.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Nama, hewan, dan sub kategori wajib diisi',
                          ),
                        ),
                      );
                      return;
                    }

                    try {
                      if (editing) {
                        await widget.categoryService.updateCategory(
                          id: category['id'].toString(),
                          name: name,
                          animalType: animal,
                          subCategory: sub,
                          description: _descCtrl.text.trim(),
                        );
                      } else {
                        await widget.categoryService.createCategory(
                          name: name,
                          animalType: animal,
                          subCategory: sub,
                          description: _descCtrl.text.trim(),
                        );
                      }
                      if (!sheetContext.mounted) return;
                      Navigator.pop(sheetContext);
                      if (mounted) await _load();
                    } catch (e) {
                      if (!sheetContext.mounted) return;
                      ScaffoldMessenger.of(sheetContext).showSnackBar(
                        SnackBar(content: Text(userFriendlyError(e))),
                      );
                    }
                  },
                  child: Container(
                    height: 52,
                    decoration: BoxDecoration(
                      color: _brown700,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: _softShadow(alpha: 0.16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.save_rounded, color: Colors.white),
                        const SizedBox(width: 8),
                        Text(
                          editing ? 'Simpan Perubahan' : 'Tambah Kategori',
                          style: _text(
                            size: 13,
                            weight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _delete(Map<String, dynamic> category) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _pageBg,
        title: Text('Hapus kategori', style: _text(size: 18)),
        content: Text(
          'Hapus kategori "${category['name']}"?',
          style: _text(size: 14, color: _brown400),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: _red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (ok != true) return;

    try {
      await widget.categoryService.deleteCategory(category['id'].toString());
      await _load();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(userFriendlyError(e))));
    }
  }

  Widget _field(
    TextEditingController controller,
    String label, {
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      cursorColor: _brown700,
      style: _text(size: 14),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: _text(size: 13, color: _brown400),
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFE9D9C9)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: _brown700, width: 1.3),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredCategories;

    return Scaffold(
      backgroundColor: _pageBg,
      floatingActionButton: AppBounceTap(
        onTap: () => _openForm(),
        child: Container(
          width: 108,
          height: 78,
          decoration: BoxDecoration(
            color: _fabBg,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: Colors.white.withValues(alpha: 0.78)),
            boxShadow: _softShadow(alpha: 0.18, blur: 20),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.add_rounded, size: 30, color: _brown900),
              const SizedBox(height: 2),
              Text('Kategori', style: _text(size: 14, weight: FontWeight.w800)),
            ],
          ),
        ),
      ),
      body: RefreshIndicator(
        color: _brown700,
        backgroundColor: _cardBg,
        onRefresh: _load,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 14),
                child: _buildSearchBar(),
              ),
            ),
            if (_loading)
              const SliverFillRemaining(
                hasScrollBody: false,
                child: Center(child: CircularProgressIndicator()),
              )
            else if (filtered.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      'Kategori tidak ditemukan',
                      textAlign: TextAlign.center,
                      style: _text(
                        size: 14,
                        weight: FontWeight.w800,
                        color: _brown400,
                      ),
                    ),
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 112),
                sliver: SliverList.separated(
                  itemCount: filtered.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    final category = filtered[index];
                    return _StaggeredCategoryEntrance(
                      controller: _listController,
                      index: index,
                      totalItems: filtered.length,
                      child: _CategoryRow(
                        category: category,
                        onEdit: () => _openForm(category),
                        onDelete: () => _delete(category),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 54,
      decoration: BoxDecoration(
        color: _fieldBg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFE6D3C2)),
        boxShadow: [
          BoxShadow(
            color: _brown900.withValues(alpha: 0.07),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: _searchCtrl,
        cursorColor: _brown700,
        style: _text(size: 15, color: _brown700),
        decoration: InputDecoration(
          hintText: 'Cari Kategori...',
          hintStyle: _text(size: 15, color: _brown400),
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: _brown700,
            size: 26,
          ),
          suffixIcon: _query.isEmpty
              ? null
              : IconButton(
                  tooltip: 'Bersihkan pencarian',
                  onPressed: _searchCtrl.clear,
                  icon: const Icon(Icons.close_rounded, color: _brown400),
                ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 4,
            vertical: 16,
          ),
        ),
      ),
    );
  }

  static List<BoxShadow> _softShadow({double alpha = 0.12, double blur = 18}) {
    return [
      BoxShadow(
        color: Colors.white.withValues(alpha: 0.96),
        blurRadius: 10,
        offset: const Offset(-3, -3),
      ),
      BoxShadow(
        color: const Color(0xFFFF9A4D).withValues(alpha: alpha),
        blurRadius: blur,
        offset: const Offset(5, 8),
      ),
    ];
  }

  static TextStyle _text({
    required double size,
    FontWeight weight = FontWeight.w600,
    Color color = _brown900,
  }) {
    return GoogleFonts.plusJakartaSans(
      fontSize: size,
      fontWeight: weight,
      color: color,
      letterSpacing: 0,
    );
  }
}

class _CategoryRow extends StatelessWidget {
  final Map<String, dynamic> category;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _CategoryRow({
    required this.category,
    required this.onEdit,
    required this.onDelete,
  });

  static const _cardBg = Color(0xFFFFFBF6);
  static const _brown900 = Color(0xFF3D2314);
  static const _brown400 = Color(0xFF9E8F85);
  static const _green = Color(0xFF5B8B57);
  static const _greenBg = Color(0xFFDCEED7);
  static const _red = Color(0xFFB82044);
  static const _redBg = Color(0xFFFFD6DF);

  String get _name => category['name']?.toString() ?? '-';
  String get _animal => category['animal_type']?.toString() ?? '-';
  String get _sub => category['sub_category']?.toString() ?? '-';

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 7,
            child: AppBounceTap(
              onTap: () {},
              child: Container(
                constraints: const BoxConstraints(minHeight: 82),
                padding: const EdgeInsets.fromLTRB(12, 11, 14, 11),
                decoration: BoxDecoration(
                  color: _cardBg,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFF2E5D8)),
                  boxShadow: _CategoryManagementScreenState._softShadow(),
                ),
                child: Row(
                  children: [
                    _CategoryIllustration(animal: _animal, subCategory: _sub),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: _text(size: 14, weight: FontWeight.w400),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            '$_animal / $_sub',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: _text(
                              size: 12,
                              weight: FontWeight.w400,
                              color: _brown400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 18),
          SizedBox(
            width: 96,
            child: Container(
              constraints: const BoxConstraints(minHeight: 82),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              decoration: BoxDecoration(
                color: _cardBg,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFF2E5D8)),
                boxShadow: _CategoryManagementScreenState._softShadow(),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _RoundActionButton(
                    tooltip: 'Edit',
                    icon: Icons.edit_rounded,
                    foreground: _green,
                    background: _greenBg,
                    onTap: onEdit,
                  ),
                  _RoundActionButton(
                    tooltip: 'Hapus',
                    icon: Icons.delete_rounded,
                    foreground: _red,
                    background: _redBg,
                    onTap: onDelete,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static TextStyle _text({
    required double size,
    FontWeight weight = FontWeight.w600,
    Color color = _brown900,
  }) {
    return GoogleFonts.plusJakartaSans(
      fontSize: size,
      fontWeight: weight,
      color: color,
      letterSpacing: 0,
    );
  }
}

class _RoundActionButton extends StatelessWidget {
  final String tooltip;
  final IconData icon;
  final Color foreground;
  final Color background;
  final VoidCallback onTap;

  const _RoundActionButton({
    required this.tooltip,
    required this.icon,
    required this.foreground,
    required this.background,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: AppBounceTap(
        onTap: onTap,
        child: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: background.withValues(alpha: 0.72),
            boxShadow: [
              BoxShadow(
                color: foreground.withValues(alpha: 0.2),
                blurRadius: 16,
                offset: const Offset(0, 7),
              ),
              BoxShadow(
                color: Colors.white.withValues(alpha: 0.9),
                blurRadius: 8,
                offset: const Offset(-2, -2),
              ),
            ],
          ),
          child: Icon(icon, color: foreground, size: 21),
        ),
      ),
    );
  }
}

class _CategoryIllustration extends StatelessWidget {
  final String animal;
  final String subCategory;

  const _CategoryIllustration({
    required this.animal,
    required this.subCategory,
  });

  @override
  Widget build(BuildContext context) {
    final animalLower = animal.toLowerCase();
    final subLower = subCategory.toLowerCase();
    final icon = _iconFor(animalLower, subLower);
    final bg = _backgroundFor(subLower);
    final color = _iconColorFor(subLower);

    return Container(
      width: 54,
      height: 54,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: Colors.white.withValues(alpha: 0.9)),
      ),
      child: Center(child: Icon(icon, color: color, size: 27)),
    );
  }

  IconData _iconFor(String animal, String sub) {
    if (sub.contains('medicine') ||
        sub.contains('obat') ||
        sub.contains('health')) {
      return Icons.medical_services_rounded;
    }
    if (sub.contains('equipment') ||
        sub.contains('perlengkapan') ||
        sub.contains('accessor')) {
      return Icons.inventory_2_rounded;
    }
    if (animal.contains('cat') || animal.contains('kucing')) {
      return Icons.pets_rounded;
    }
    if (animal.contains('dog') || animal.contains('anjing')) {
      return Icons.cruelty_free_rounded;
    }
    if (animal.contains('bird') || animal.contains('burung')) {
      return Icons.flutter_dash_rounded;
    }
    if (animal.contains('fish') || animal.contains('ikan')) {
      return Icons.set_meal_rounded;
    }
    if (animal.contains('rabbit') || animal.contains('kelinci')) {
      return Icons.cruelty_free_rounded;
    }
    if (sub.contains('food') || sub.contains('makan')) {
      return Icons.restaurant_rounded;
    }
    return Icons.pets_rounded;
  }

  Color _backgroundFor(String sub) {
    if (sub.contains('food') || sub.contains('makan')) {
      return const Color(0xFFFFE1B8);
    }
    if (sub.contains('medicine') ||
        sub.contains('obat') ||
        sub.contains('health')) {
      return const Color(0xFFFFDDE5);
    }
    if (sub.contains('equipment') ||
        sub.contains('perlengkapan') ||
        sub.contains('accessor')) {
      return const Color(0xFFDDEDD8);
    }
    return const Color(0xFFE7EFF8);
  }

  Color _iconColorFor(String sub) {
    if (sub.contains('food') || sub.contains('makan')) {
      return const Color(0xFFFF8A3D);
    }
    if (sub.contains('medicine') ||
        sub.contains('obat') ||
        sub.contains('health')) {
      return const Color(0xFF6A6268);
    }
    if (sub.contains('equipment') ||
        sub.contains('perlengkapan') ||
        sub.contains('accessor')) {
      return const Color(0xFF4F8A55);
    }
    return const Color(0xFF4A7FAB);
  }
}

class _StaggeredCategoryEntrance extends StatelessWidget {
  final AnimationController controller;
  final int index;
  final int totalItems;
  final Widget child;

  const _StaggeredCategoryEntrance({
    required this.controller,
    required this.index,
    required this.totalItems,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final cappedTotal = totalItems.clamp(1, 18);
    final itemSlot = 0.72 / cappedTotal;
    final start = (index.clamp(0, 17) * itemSlot).clamp(0.0, 0.82);
    final end = (start + 0.28).clamp(start + 0.01, 1.0);
    final curved = CurvedAnimation(
      parent: controller,
      curve: Interval(start, end, curve: Curves.easeOutCubic),
    );

    return FadeTransition(
      opacity: curved,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.16),
          end: Offset.zero,
        ).animate(curved),
        child: child,
      ),
    );
  }
}
