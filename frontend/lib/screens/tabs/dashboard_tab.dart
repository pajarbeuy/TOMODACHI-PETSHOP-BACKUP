import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../dashboard_service.dart';

class DashboardTab extends StatefulWidget {
  final DashboardService dashboardService;

  const DashboardTab({super.key, required this.dashboardService});

  @override
  State<DashboardTab> createState() => _DashboardTabState();
}

class _DashboardTabState extends State<DashboardTab> {
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

  bool _loading = false;
  Map<String, dynamic> _kpi = {};
  List<dynamic> _topProducts = [];
  Map<String, dynamic> _categoryBreakdown = {};

  @override
  void initState() {
    super.initState();
    _fetchAnalytics();
  }

  Future<void> _fetchAnalytics() async {
    if (_loading) return;
    setState(() => _loading = true);

    try {
      final res = await widget.dashboardService.getAnalytics();
      if (res['status'] == true) {
        final data = res['data'];
        setState(() {
          _kpi = data['kpi'] ?? {};
          _topProducts = data['top_products'] ?? [];
          _categoryBreakdown = data['category_breakdown'] ?? {};
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load dashboard metrics: ${e.toString()}'),
          ),
        );
      }
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading && _kpi.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    final double todaySales =
        double.tryParse((_kpi['today_sales'] ?? 0).toString()) ?? 0.0;
    final int todayTrx =
        int.tryParse((_kpi['total_transactions_today'] ?? 0).toString()) ?? 0;
    final int todayItems =
        int.tryParse((_kpi['items_sold_today'] ?? 0).toString()) ?? 0;
    final double avgValue =
        double.tryParse((_kpi['average_transaction_value'] ?? 0).toString()) ??
        0.0;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Dashboard Analitik Penjualan',
                    style: _plusJakarta(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Metrik performa bisnis riil Toko Tomodachi Pet Shop',
                    style: _plusJakarta(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.refresh, color: Color(0xFFFFB570)),
                onPressed: _fetchAnalytics,
              ),
            ],
          ),
          const SizedBox(height: 24),

          // KPI Metrik grid
          GridView.count(
            crossAxisCount: MediaQuery.of(context).size.width >= 900 ? 4 : 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 1.5,
            children: [
              _buildKpiCard(
                title: 'Omzet Hari Ini',
                value: 'Rp ${todaySales.toStringAsFixed(0)}',
                icon: Icons.monetization_on,
                gradientColors: [
                  const Color(0xFFFFB570),
                  const Color(0xFFFF9A4D),
                ],
              ),
              _buildKpiCard(
                title: 'Jumlah Transaksi',
                value: '$todayTrx Transaksi',
                icon: Icons.receipt_long,
                gradientColors: [
                  const Color(0xFF6EE7B7),
                  const Color(0xFF34D399),
                ],
              ),
              _buildKpiCard(
                title: 'Item Terjual',
                value: '$todayItems Pcs',
                icon: Icons.shopping_bag,
                gradientColors: [
                  const Color(0xFF93C5FD),
                  const Color(0xFF60A5FA),
                ],
              ),
              _buildKpiCard(
                title: 'Rata-Rata Order',
                value: 'Rp ${avgValue.toStringAsFixed(0)}',
                icon: Icons.analytics,
                gradientColors: [
                  const Color(0xFFC084FC),
                  const Color(0xFFA855F7),
                ],
              ),
            ],
          ),
          const SizedBox(height: 28),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left: Top products rank
              Expanded(flex: 6, child: _buildTopProductsSection()),
              const SizedBox(width: 24),

              // Right: Category Share breakdown
              Expanded(flex: 4, child: _buildCategoryBreakdownSection()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKpiCard({
    required String title,
    required String value,
    required IconData icon,
    required List<Color> gradientColors,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: gradientColors.first.withValues(alpha: 0.35),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: _plusJakarta(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Colors.white70,
                ),
              ),
              Icon(icon, color: Colors.white, size: 22),
            ],
          ),
          Text(
            value,
            style: _plusJakarta(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopProductsSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade100),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '🏆 Produk Terlaris Teratas',
            style: _plusJakarta(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 14),
          const Divider(height: 1),
          _topProducts.isEmpty
              ? Padding(
                  padding: const EdgeInsets.all(32),
                  child: Center(
                    child: Text(
                      'Belum ada data penjualan tercatat hari ini.',
                      style: _plusJakarta(color: Colors.grey),
                    ),
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _topProducts.length,
                  itemBuilder: (context, index) {
                    final item = _topProducts[index];
                    final String name = item['product_name'];
                    final int qty = int.parse(item['quantity_sold'].toString());

                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                        backgroundColor: const Color(0xFFFFF3E6),
                        child: Text(
                          '#${index + 1}',
                          style: _plusJakarta(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFFFF9A4D),
                          ),
                        ),
                      ),
                      title: Text(
                        name,
                        style: _plusJakarta(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: Text(
                        '$qty Pcs',
                        style: _plusJakarta(
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFF3D2314),
                        ),
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }

  Widget _buildCategoryBreakdownSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade100),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '📊 Distribusi Kategori Hewan',
            style: _plusJakarta(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 18),
          _categoryBreakdown.isEmpty
              ? Padding(
                  padding: const EdgeInsets.all(32),
                  child: Center(
                    child: Text(
                      'Belum ada distribusi data.',
                      style: _plusJakarta(color: Colors.grey),
                    ),
                  ),
                )
              : Column(
                  children: _categoryBreakdown.entries.map((entry) {
                    final String key = entry.key;
                    final double val =
                        double.tryParse(entry.value.toString()) ?? 0.0;

                    Color barColor = Colors.grey;
                    String emoji = '🐾';
                    if (key == 'cat') {
                      barColor = Colors.orange;
                      emoji = '🐈';
                    } else if (key == 'dog') {
                      barColor = Colors.blue;
                      emoji = '🐕';
                    } else if (key == 'hamster') {
                      barColor = Colors.green;
                      emoji = '🐹';
                    } else if (key == 'rabbit') {
                      barColor = Colors.red;
                      emoji = '🐇';
                    }

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '$emoji ${key.toUpperCase()}',
                                style: _plusJakarta(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${val.toStringAsFixed(1)}%',
                                style: _plusJakarta(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          LinearProgressIndicator(
                            value: val / 100.0,
                            color: barColor,
                            backgroundColor: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(999),
                            minHeight: 8,
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
        ],
      ),
    );
  }
}
