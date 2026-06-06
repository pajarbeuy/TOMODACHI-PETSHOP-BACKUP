import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../auth_service.dart';
import '../product_service.dart';
import '../transaction_service.dart';
import '../dashboard_service.dart';
import 'tabs/pos_tab.dart';
import 'tabs/products_tab.dart';
import 'tabs/transactions_history_tab.dart';
import 'tabs/dashboard_owner.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  final AuthService authService;

  const HomeScreen({super.key, required this.authService});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _NavigationItem {
  final String label;
  final IconData icon;
  final Widget widget;

  const _NavigationItem({
    required this.label,
    required this.icon,
    required this.widget,
  });
}

class _HomeScreenState extends State<HomeScreen> {
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

  late final ProductService _productService;
  late final TransactionService _transactionService;
  late final DashboardService _dashboardService;

  int _currentIndex = 0;
  bool _loadingLogout = false;

  @override
  void initState() {
    super.initState();
    // Initialize services by accessing apiClient from AuthService
    final client = widget.authService.apiClient;
    _productService = ProductService(client);
    _transactionService = TransactionService(client);
    _dashboardService = DashboardService(client);
  }

  List<_NavigationItem> _getNavigationItems(String role) {
    switch (role.toLowerCase()) {
      case 'owner':
        return [
          _NavigationItem(
            label: 'Dasbor Analitik',
            icon: Icons.dashboard,
            widget: DashboardOwner(dashboardService: _dashboardService),
          ),
          _NavigationItem(
            label: 'POS Kasir',
            icon: Icons.point_of_sale,
            widget: PosTab(productService: _productService, transactionService: _transactionService),
          ),
          _NavigationItem(
            label: 'Manajemen Produk',
            icon: Icons.inventory,
            widget: ProductsTab(productService: _productService, userRole: role),
          ),
          _NavigationItem(
            label: 'Riwayat Transaksi',
            icon: Icons.history,
            widget: TransactionsHistoryTab(transactionService: _transactionService),
          ),
        ];

      case 'admin':
        return [
          _NavigationItem(
            label: 'Manajemen Produk',
            icon: Icons.inventory,
            widget: ProductsTab(productService: _productService, userRole: role),
          ),
          _NavigationItem(
            label: 'POS Kasir',
            icon: Icons.point_of_sale,
            widget: PosTab(productService: _productService, transactionService: _transactionService),
          ),
          _NavigationItem(
            label: 'Riwayat Transaksi',
            icon: Icons.history,
            widget: TransactionsHistoryTab(transactionService: _transactionService),
          ),
        ];

      case 'kasir':
      default:
        return [
          _NavigationItem(
            label: 'POS Kasir',
            icon: Icons.point_of_sale,
            widget: PosTab(productService: _productService, transactionService: _transactionService),
          ),
          _NavigationItem(
            label: 'Stok Produk',
            icon: Icons.inventory_2,
            widget: ProductsTab(productService: _productService, userRole: role), // Read-only for Kasir
          ),
          _NavigationItem(
            label: 'Riwayat Kasir',
            icon: Icons.history,
            widget: TransactionsHistoryTab(transactionService: _transactionService),
          ),
        ];
    }
  }

  void _handleLogout() async {
    setState(() => _loadingLogout = true);
    final success = await widget.authService.logout();

    if (!mounted) return;

    if (success) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    } else {
      setState(() => _loadingLogout = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.authService.errorMessage ?? 'Gagal melakukan Logout'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.authService.currentUser;
    final role = user?.role ?? 'kasir';
    final items = _getNavigationItems(role);

    // Adjust selected index if navigation items count changed dynamically
    if (_currentIndex >= items.length) {
      _currentIndex = 0;
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth >= 900;

    return Scaffold(
      backgroundColor: const Color(0xFFFFFDF9),
      appBar: _buildAppBar(user?.name ?? 'Pengguna', role),
      body: isWide
          ? Row(
              children: [
                // Premium Sidebar
                _buildSidebar(items),
                const VerticalDivider(width: 1, thickness: 1),
                // Core screen content
                Expanded(
                  child: items[_currentIndex].widget,
                ),
              ],
            )
          : items[_currentIndex].widget,
      bottomNavigationBar: !isWide
          ? BottomNavigationBar(
              currentIndex: _currentIndex,
              selectedItemColor: const Color(0xFFFFB570),
              unselectedItemColor: const Color(0xFF9E8F85),
              showUnselectedLabels: true,
              onTap: (index) => setState(() => _currentIndex = index),
              items: items.map((item) {
                return BottomNavigationBarItem(
                  icon: Icon(item.icon),
                  label: item.label,
                );
              }).toList(),
            )
          : null,
    );
  }

  PreferredSizeWidget _buildAppBar(String userName, String role) {
    String roleLabel = 'Kasir';
    Color roleColor = const Color(0xFFFFC7D1);
    Color roleText = const Color(0xFFC7153D);

    if (role.toLowerCase() == 'owner') {
      roleLabel = 'Owner';
      roleColor = const Color(0xFFD1FAE5);
      roleText = const Color(0xFF065F46);
    } else if (role.toLowerCase() == 'admin') {
      roleLabel = 'Admin';
      roleColor = const Color(0xFFDBEAFE);
      roleText = const Color(0xFF1E40AF);
    }

    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0.5,
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFFB570), Color(0xFFFF9A4D)],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.pets, size: 20, color: Colors.white),
          ),
          const SizedBox(width: 10),
          Text(
            'Tomodachi Pet Shop',
            style: _plusJakarta(fontSize: 16, fontWeight: FontWeight.w900, color: const Color(0xFF3D2314)),
          ),
        ],
      ),
      actions: [
        // User profile capsule
        Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  userName,
                  style: _plusJakarta(fontSize: 13, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 2),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                  decoration: BoxDecoration(
                    color: roleColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    roleLabel,
                    style: _plusJakarta(fontSize: 9, fontWeight: FontWeight.w900, color: roleText),
                  ),
                )
              ],
            ),
            const SizedBox(width: 8),
            CircleAvatar(
              backgroundColor: const Color(0xFFFFEAD4),
              foregroundColor: const Color(0xFFFF9A4D),
              child: Text(userName.substring(0, 1).toUpperCase()),
            ),
          ],
        ),
        const SizedBox(width: 12),
        // Logout Icon
        IconButton(
          icon: _loadingLogout
              ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
              : const Icon(Icons.logout, color: Color(0xFFC7153D)),
          tooltip: 'Logout',
          onPressed: _loadingLogout ? null : _handleLogout,
        ),
        const SizedBox(width: 12),
      ],
    );
  }

  Widget _buildSidebar(List<_NavigationItem> items) {
    return Container(
      width: 250,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                final isSelected = _currentIndex == index;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: ListTile(
                    selected: isSelected,
                    selectedTileColor: const Color(0xFFFFF2E6),
                    iconColor: const Color(0xFF9E8F85),
                    selectedColor: const Color(0xFFFF9A4D),
                    leading: Icon(item.icon),
                    title: Text(
                      item.label,
                      style: _plusJakarta(
                        fontSize: 13,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        color: isSelected ? const Color(0xFFFF9A4D) : const Color(0xFF3D2314),
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    onTap: () => setState(() => _currentIndex = index),
                  ),
                );
              },
            ),
          ),
          // Footer
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              'Tomodachi POS v1.0',
              style: _plusJakarta(fontSize: 11, color: Colors.grey.shade400),
            ),
          )
        ],
      ),
    );
  }
}
