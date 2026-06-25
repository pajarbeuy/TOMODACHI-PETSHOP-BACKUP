import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../auth_service.dart';

// ── Colors ───────────────────────────────────────────────────────────────────
const _brown900 = Color(0xFF3D2314);
const _brown700 = Color(0xFF5A3D2B);
const _brown500 = Color(0xFF6B4F3E);
const _brown400 = Color(0xFF9B7B6B);
const _brown200 = Color(0xFFC5A882);
const _orange = Color(0xFFFFB570);
const _orangeDark = Color(0xFFFF9A4D);
const _bgPage = Color(0xFFFFF6E9);
const _bgInput = Color(0xFFFFF8F2);
const _borderLight = Color(0x4DFFB570);
const _success = Color(0xFF4CAF50);
const _error = Color(0xFFE53935);

// ── TextStyle helpers ────────────────────────────────────────────────────────
TextStyle _iosStyle({
  double fontSize = 14,
  FontWeight fontWeight = FontWeight.w500,
  Color color = _brown900,
  double letterSpacing = -0.3,
  double height = 1.4,
}) =>
    GoogleFonts.plusJakartaSans(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
    );

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
  String? _errorMessage;
  List<AccountModel> _accounts = [];
  List<AccountModel> _filtered = [];
  final _roles = const {'owner': 1, 'admin': 2, 'kasir': 3};
  String _selectedRole = 'kasir';
  bool _showPassword = false;
  bool _showPasswordConfirm = false;
  AccountModel? _editing;

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
    setState(() { _loading = true; _errorMessage = null; });
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
        _errorMessage = e.toString();
        _loading = false;
      });
    }
  }

  void _applyFilter() {
    setState(() => _filtered = _filter(_accounts));
  }

  List<AccountModel> _filter(List<AccountModel> source) {
    // Akun dengan role owner tidak ditampilkan di halaman manajemen
    final nonOwner = source.where((a) => a.roleName.toLowerCase() != 'owner').toList();
    final q = _searchCtrl.text.trim().toLowerCase();
    if (q.isEmpty) return nonOwner;
    return nonOwner
        .where(
          (a) =>
              a.name.toLowerCase().contains(q) ||
              a.email.toLowerCase().contains(q) ||
              a.roleName.toLowerCase().contains(q),
        )
        .toList();
  }

  void _openForm({AccountModel? account}) {
    _editing = account;
    _creating = account == null;
    _nameCtrl.text = account?.name ?? '';
    _emailCtrl.text = account?.email ?? '';
    _passwordCtrl.clear();
    _passwordConfirmCtrl.clear();
    
    final initialRole = account?.roleName.toLowerCase() ?? 'kasir';
    _selectedRole = ['admin', 'kasir'].contains(initialRole) ? initialRole : 'kasir';
    
    _showPassword = false;
    _showPasswordConfirm = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => StatefulBuilder(
        builder: (context, setState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            decoration: const BoxDecoration(
              color: _bgPage,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(24),
              ),
            ),
            padding: const EdgeInsets.all(24),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _creating ? 'Tambah Akun Baru' : 'Edit Akun',
                          style: _iosStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: _brown900,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Name Field
                  _buildLabel('Nama Lengkap'),
                  const SizedBox(height: 8),
                  _buildTextField(
                    controller: _nameCtrl,
                    hintText: 'Masukkan nama lengkap',
                  ),
                  const SizedBox(height: 16),

                  // Email Field
                  _buildLabel('Email'),
                  const SizedBox(height: 8),
                  _buildTextField(
                    controller: _emailCtrl,
                    hintText: 'Masukkan email',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),

                  // Role Dropdown
                  _buildLabel('Role'),
                  const SizedBox(height: 8),
                  _buildRoleDropdown(setState),
                  const SizedBox(height: 16),

                  // Password Field
                  _buildLabel(
                    _creating
                        ? 'Password (Wajib diisi)'
                        : 'Password (Biarkan kosong jika tidak diubah)',
                  ),
                  const SizedBox(height: 8),
                  _buildPasswordField(setState, _passwordCtrl, _showPassword,
                      (val) {
                    setState(() => _showPassword = val);
                  }),
                  const SizedBox(height: 16),

                  // Password Confirmation
                  _buildLabel('Konfirmasi Password'),
                  const SizedBox(height: 8),
                  _buildPasswordField(setState, _passwordConfirmCtrl,
                      _showPasswordConfirm, (val) {
                    setState(() => _showPasswordConfirm = val);
                  }),
                  const SizedBox(height: 28),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _saving
                              ? null
                              : () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            side: const BorderSide(color: _borderLight),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Batal',
                            style: _iosStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: _brown700,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton(
                          onPressed: _saving ? null : _save,
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            backgroundColor: _orange,
                            disabledBackgroundColor: _brown200,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: _saving
                              ? SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor:
                                        AlwaysStoppedAnimation<Color>(_bgPage),
                                  ),
                                )
                              : Text(
                                  'Simpan',
                                  style: _iosStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _save() async {
    final name = _nameCtrl.text.trim();
    final email = _emailCtrl.text.trim();
    final password = _passwordCtrl.text.trim();
    final passwordConfirm = _passwordConfirmCtrl.text.trim();

    // Validation
    if (name.isEmpty || email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nama dan Email tidak boleh kosong')),
      );
      return;
    }

    if (_creating && password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password wajib diisi untuk akun baru')),
      );
      return;
    }

    if (password.isNotEmpty && password != passwordConfirm) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password dan Konfirmasi tidak cocok')),
      );
      return;
    }

    setState(() => _saving = true);
    final roleId = _roles[_selectedRole.toLowerCase()] ?? 3; // Ensure explicit role lookup with fallback

    try {
      if (_creating) {
        final ok = await widget.authService.register(
          name: name,
          email: email,
          password: password,
          passwordConfirmation: passwordConfirm,
          roleId: roleId,
        );
        if (!ok) {
          throw Exception(
            widget.authService.errorMessage ?? 'Gagal membuat akun',
          );
        }
      } else if (_editing != null) {
        final ok = await widget.authService.updateAccount(
          userId: _editing!.id,
          name: name,
          email: email,
          password: password.isEmpty ? null : password,
          passwordConfirmation: password.isEmpty ? null : passwordConfirm,
          roleId: roleId,
          roleName: _selectedRole.toLowerCase(),
        );
        if (!ok) {
          throw Exception(
            widget.authService.errorMessage ?? 'Gagal mengubah akun',
          );
        }
      }

      if (!mounted) return;
      Navigator.pop(context);
      await _load();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _creating ? 'Akun berhasil dibuat' : 'Akun berhasil diubah',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
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
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (ok != true) return;
    await widget.authService.deleteAccount(account.id);
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgPage,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _load,
          color: _orange,
          child: CustomScrollView(
            slivers: [
              // Header
              SliverAppBar(
                backgroundColor: _bgPage,
                elevation: 0,
                pinned: true,
                expandedHeight: 120,
                flexibleSpace: FlexibleSpaceBar(
                  background: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Manajemen Akun',
                          style: _iosStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: _brown900,
                          ),
                        ),
                        Text(
                          'Kelola semua akun pengguna',
                          style: _iosStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: _brown400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Content
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Search & Add Button
                      Row(
                        children: [
                          Expanded(
                            child: _buildSearchField(),
                          ),
                          const SizedBox(width: 12),
                          FilledButton.icon(
                            onPressed: () => _openForm(),
                            icon: const Icon(Icons.add),
                            label: const Text('Tambah'),
                            style: FilledButton.styleFrom(
                              backgroundColor: _orange,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Loading / Error / Content
                      if (_loading)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(40),
                            child: Column(
                              children: [
                                CircularProgressIndicator(
                                  color: _orange,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Memuat data...',
                                  style: _iosStyle(
                                    color: _brown400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      else if (_errorMessage != null)
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: _errorMessage!.contains('404')
                                ? _errorMessage!.contains('role')
                                    ? Colors.yellow[50]
                                    : _errorMessage!.contains('email')
                                        ? Colors.red[50]
                                        : Colors.orange[50]
                                : Colors.red[50],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _errorMessage!.contains('404')
                                  ? Colors.yellow[300] ?? Colors.yellow
                                  : Colors.red[300] ?? Colors.red,
                              width: 1,
                            ),
                          ),
                          child: Text(
                            _errorMessage ?? 'Ada kesalahan',
                            style: _iosStyle(
                              color: _brown900,
                              fontSize: 13,
                            ),
                          ),
                        )
                      else if (_filtered.isEmpty)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(40),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.people_outline,
                                  size: 48,
                                  color: _brown200,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Tidak ada akun',
                                  style: _iosStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: _brown400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      else
                        Column(
                          children: _filtered.map(_buildAccountCard).toList(),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: _iosStyle(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: _brown700,
        letterSpacing: -0.1,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: _iosStyle(fontSize: 14, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: _iosStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: _brown200,
        ),
        filled: true,
        fillColor: _bgInput,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _borderLight, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _borderLight, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _orange, width: 2),
        ),
      ),
    );
  }

  Widget _buildPasswordField(
    StateSetter setState,
    TextEditingController controller,
    bool isVisible,
    Function(bool) onToggle,
  ) {
    return TextField(
      controller: controller,
      obscureText: !isVisible,
      style: _iosStyle(fontSize: 14, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        hintText: 'Masukkan password',
        hintStyle: _iosStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: _brown200,
        ),
        filled: true,
        fillColor: _bgInput,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _borderLight, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _borderLight, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _orange, width: 2),
        ),
        suffixIcon: IconButton(
          onPressed: () => setState(() => onToggle(!isVisible)),
          icon: Icon(
            isVisible ? Icons.visibility : Icons.visibility_off,
            color: _brown400,
          ),
        ),
      ),
    );
  }

  Widget _buildRoleDropdown(StateSetter setState) {
    final availableRoles = ['admin', 'kasir'];
    final dropdownValue = availableRoles.contains(_selectedRole) ? _selectedRole : 'kasir';

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: _borderLight, width: 2),
        borderRadius: BorderRadius.circular(12),
        color: _bgInput,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: dropdownValue,
          items: availableRoles
              .map((role) => DropdownMenuItem(
                    value: role,
                    child: Text(
                      role[0].toUpperCase() + role.substring(1),
                      style: _iosStyle(),
                    ),
                  ))
              .toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() => _selectedRole = value);
              this.setState(() => _selectedRole = value);
            }
          },
          isExpanded: true,
          isDense: true,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          style: _iosStyle(fontSize: 14, fontWeight: FontWeight.w500),
          icon: const Icon(Icons.keyboard_arrow_down, color: _brown400),
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchCtrl,
      style: _iosStyle(fontSize: 14, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        hintText: 'Cari akun...',
        hintStyle: _iosStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: _brown200,
        ),
        prefixIcon: const Icon(Icons.search, color: _brown400),
        filled: true,
        fillColor: _bgInput,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _borderLight, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _borderLight, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _orange, width: 2),
        ),
      ),
    );
  }

  Widget _buildAccountCard(AccountModel account) {
    final roleEmoji = {
      'owner': '👑',
      'admin': '🔑',
      'kasir': '💳',
    };

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _borderLight, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: _bgPage,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        roleEmoji[account.roleName] ?? '👤',
                        style: const TextStyle(fontSize: 24),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          account.name,
                          style: _iosStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: _brown900,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          account.email,
                          style: _iosStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: _brown400,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _orange.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      account.roleName[0].toUpperCase() + account.roleName.substring(1),
                      style: _iosStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: _orangeDark,
                      ),
                    ),
                  ),
                  if (account.roleName.toLowerCase() != 'owner')
                    PopupMenuButton(
                      onSelected: (value) async {
                        if (value == 'edit') {
                          _openForm(account: account);
                        } else if (value == 'delete') {
                          await _delete(account);
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              const Icon(Icons.edit, size: 18, color: _orange),
                              const SizedBox(width: 8),
                              const Text('Edit'),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete, size: 18, color: _error),
                              const SizedBox(width: 8),
                              Text(
                                'Hapus',
                                style: _iosStyle(color: _error),
                              ),
                            ],
                          ),
                        ),
                      ],
                      icon: const Icon(Icons.more_vert, color: _brown400),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
