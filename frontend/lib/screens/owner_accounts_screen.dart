import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";

import '../auth_service.dart';

class OwnerAccountsScreen extends StatefulWidget {
  final AuthService authService;

  const OwnerAccountsScreen({super.key, required this.authService});

  @override
  State<OwnerAccountsScreen> createState() => _OwnerAccountsScreenState();
}

class _OwnerAccountsScreenState extends State<OwnerAccountsScreen> {
  final _searchCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _passwordConfirmCtrl = TextEditingController();

  bool _loading = true;
  bool _saving = false;
  bool _creating = false;
  String? _error;
  List<AccountModel> _accounts = [];
  List<AccountModel> _filtered = [];
  final _roles = const {'owner': 1, 'admin': 2, 'kasir': 3};
  String _selectedRole = 'kasir';
  AccountModel? _editing;

  TextStyle _text({double size = 14, FontWeight weight = FontWeight.w500, Color color = const Color(0xFF3D2314)}) =>
      GoogleFonts.plusJakartaSans(fontSize: size, fontWeight: weight, color: color);

  @override
  void initState() {
    super.initState();
    _load();
    _searchCtrl.addListener(_applyFilter);
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _passwordConfirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() { _loading = true; _error = null; });
    try {
      final accounts = await widget.authService.getAccounts();
      if (!mounted) return;
      setState(() {
        _accounts = accounts;
        _filtered = _filter(accounts);
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  void _applyFilter() {
    setState(() => _filtered = _filter(_accounts));
  }

  List<AccountModel> _filter(List<AccountModel> source) {
    final q = _searchCtrl.text.trim().toLowerCase();
    if (q.isEmpty) return source;
    return source.where((a) => a.name.toLowerCase().contains(q) || a.email.toLowerCase().contains(q) || a.roleName.toLowerCase().contains(q)).toList();
  }

  void _openForm({AccountModel? account}) {
    _editing = account;
    _creating = account == null;
    _nameCtrl.text = account?.name ?? '';
    _emailCtrl.text = account?.email ?? '';
    _passwordCtrl.clear();
    _passwordConfirmCtrl.clear();
    _selectedRole = account?.roleName ?? 'kasir';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(child: _buildForm()),
        ),
      ),
    );
  }

  Future<void> _save() async {
    if (_nameCtrl.text.trim().isEmpty || _emailCtrl.text.trim().isEmpty) return;
    if (_passwordCtrl.text.isNotEmpty && _passwordCtrl.text != _passwordConfirmCtrl.text) return;
    setState(() => _saving = true);
    final roleId = _roles[_selectedRole];
    try {
      if (_creating) {
        final ok = await widget.authService.register(
          name: _nameCtrl.text.trim(),
          email: _emailCtrl.text.trim(),
          password: _passwordCtrl.text.trim(),
          passwordConfirmation: _passwordConfirmCtrl.text.trim(),
          roleId: roleId ?? 3,
        );
        if (!ok) throw Exception(widget.authService.errorMessage ?? 'Gagal membuat akun');
      } else if (_editing != null) {
        final ok = await widget.authService.updateAccount(
          userId: _editing!.id,
          name: _nameCtrl.text.trim(),
          email: _emailCtrl.text.trim(),
          password: _passwordCtrl.text.isEmpty ? null : _passwordCtrl.text.trim(),
          passwordConfirmation: _passwordCtrl.text.isEmpty ? null : _passwordConfirmCtrl.text.trim(),
          roleId: roleId,
        );
        if (!ok) throw Exception('Gagal mengubah akun');
      }
      if (!mounted) return;
      Navigator.pop(context);
      await _load();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _delete(AccountModel account) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus akun'),
        content: Text('Hapus ${account.name}?'),
        actions: [TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Batal')), FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Hapus'))],
      ),
    );
    if (ok != true) return;
    await widget.authService.deleteAccount(account.id);
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 700;
    return RefreshIndicator(
      onRefresh: _load,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              Expanded(child: Text('Manajemen Akun', style: _text(size: 20, weight: FontWeight.w800))),
              FilledButton.icon(onPressed: () => _openForm(), icon: const Icon(Icons.add), label: const Text('Tambah')),
            ],
          ),
          const SizedBox(height: 12),
          TextField(controller: _searchCtrl, decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Cari nama, email, role')),
          const SizedBox(height: 12),
          if (_loading) const Center(child: Padding(padding: EdgeInsets.all(40), child: CircularProgressIndicator())) else if (_error != null) Text(_error!, style: const TextStyle(color: Colors.red)) else ...[
            if (isWide) _buildTable() else ..._filtered.map(_buildCard),
          ],
        ],
      ),
    );
  }

  Widget _buildTable() {
    return DataTable(columns: const [DataColumn(label: Text('Nama')), DataColumn(label: Text('Email')), DataColumn(label: Text('Role')), DataColumn(label: Text('Aksi'))], rows: _filtered.map((a) => DataRow(cells: [DataCell(Text(a.name)), DataCell(Text(a.email)), DataCell(Text(a.roleName)), DataCell(Row(children: [IconButton(icon: const Icon(Icons.edit), onPressed: () => _openForm(account: a)), IconButton(icon: const Icon(Icons.delete), onPressed: () => _delete(a))]))])).toList());
  }

  Widget _buildCard(AccountModel account) {
    return Card(margin: const EdgeInsets.only(bottom: 12), child: Padding(padding: const EdgeInsets.all(12), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(account.name, style: _text(weight: FontWeight.w700)), Text(account.email), Text(account.roleName), Row(mainAxisAlignment: MainAxisAlignment.end, children: [IconButton(icon: const Icon(Icons.edit), onPressed: () => _openForm(account: account)), IconButton(icon: const Icon(Icons.delete), onPressed: () => _delete(account))])])));
  }

  Widget _buildForm() {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      Text(_creating ? 'Tambah Akun' : 'Ubah Akun', style: _text(size: 18, weight: FontWeight.w800)),
      const SizedBox(height: 12),
      TextField(controller: _nameCtrl, decoration: const InputDecoration(labelText: 'Nama')),
      const SizedBox(height: 12),
      TextField(controller: _emailCtrl, decoration: const InputDecoration(labelText: 'Email')),
      const SizedBox(height: 12),
      DropdownButtonFormField<String>(value: _selectedRole, items: _roles.keys.map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(), onChanged: (v) => setState(() => _selectedRole = v ?? 'kasir'), decoration: const InputDecoration(labelText: 'Role')),
      const SizedBox(height: 12),
      TextField(controller: _passwordCtrl, obscureText: true, decoration: const InputDecoration(labelText: 'Password')),
      const SizedBox(height: 12),
      TextField(controller: _passwordConfirmCtrl, obscureText: true, decoration: const InputDecoration(labelText: 'Konfirmasi Password')),
      const SizedBox(height: 16),
      Row(children: [Expanded(child: OutlinedButton(onPressed: () => Navigator.pop(context), child: const Text('Batal'))), const SizedBox(width: 12), Expanded(child: FilledButton(onPressed: _saving ? null : _save, child: _saving ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Simpan')))]),
    ]);
  }
}
