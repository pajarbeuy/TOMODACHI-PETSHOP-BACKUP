import 'package:flutter/material.dart';
import '../category_service.dart';
import '../utils/error_message.dart';
import '../widgets/glass_container.dart';

class CategoryManagementScreen extends StatefulWidget {
  final CategoryService categoryService;

  const CategoryManagementScreen({super.key, required this.categoryService});

  @override
  State<CategoryManagementScreen> createState() =>
      _CategoryManagementScreenState();
}

class _CategoryManagementScreenState extends State<CategoryManagementScreen> {
  final _nameCtrl = TextEditingController();
  final _animalCtrl = TextEditingController();
  final _subCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  List<Map<String, dynamic>> _categories = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _animalCtrl.dispose();
    _subCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final rows = await widget.categoryService.getCategories();
      if (!mounted) return;
      setState(() => _categories = rows);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(userFriendlyError(e))),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
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
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  editing ? 'Edit Kategori' : 'Tambah Kategori',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
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
                FilledButton.icon(
                  onPressed: () async {
                    final name = _nameCtrl.text.trim();
                    final animal = _animalCtrl.text.trim().toLowerCase();
                    final sub = _subCtrl.text.trim().toLowerCase();
                    if (name.isEmpty || animal.isEmpty || sub.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Nama, hewan, dan sub kategori wajib diisi'),
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
                      if (!mounted) return;
                      Navigator.pop(context);
                      await _load();
                    } catch (e) {
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(userFriendlyError(e))),
                      );
                    }
                  },
                  icon: const Icon(Icons.save),
                  label: Text(editing ? 'Simpan Perubahan' : 'Tambah Kategori'),
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
        backgroundColor: const Color(0xFF1E1A38),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
        ),
        title: const Text('Hapus kategori', style: TextStyle(color: Colors.white)),
        content: Text('Hapus kategori "${category['name']}"?', style: const TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal', style: TextStyle(color: Colors.white70)),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(userFriendlyError(e))),
      );
    }
  }

  Widget _field(TextEditingController controller, String label,
      {int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(),
        icon: const Icon(Icons.add),
        label: const Text('Kategori'),
      ),
      body: RefreshIndicator(
        onRefresh: _load,
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : ListView.separated(
                padding: const EdgeInsets.all(20),
                itemCount: _categories.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  return GlassContainer(
                    padding: EdgeInsets.zero,
                    child: ListTile(
                      leading: const Icon(Icons.category_outlined, color: Color(0xFFB570FF)),
                      title: Text(category['name']?.toString() ?? '-', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      subtitle: Text(
                        '${category['animal_type']} / ${category['sub_category']}',
                        style: const TextStyle(color: Colors.white70),
                      ),
                      trailing: Wrap(
                        spacing: 4,
                        children: [
                          IconButton(
                            tooltip: 'Edit',
                            onPressed: () => _openForm(category),
                            icon: const Icon(Icons.edit_outlined, color: Colors.white),
                          ),
                          IconButton(
                            tooltip: 'Hapus',
                            onPressed: () => _delete(category),
                            icon: const Icon(Icons.delete_outline, color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
