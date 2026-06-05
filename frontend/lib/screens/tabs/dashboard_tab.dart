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
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading && _kpi.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    final width = MediaQuery.of(context).size.width;
    final isWide = width >= 900;
    final isCompact = width < 520;

    final todaySales =
        double.tryParse((_kpi['today_sales'] ?? 0).toString()) ?? 0.0;
    final todayTrx =
        int.tryParse((_kpi['total_transactions_today'] ?? 0).toString()) ?? 0;
    final todayItems =
        int.tryParse((_kpi['items_sold_today'] ?? 0).toString()) ?? 0;
    final avgValue =
        double.tryParse((_kpi['average_transaction_value'] ?? 0).toString()) ??
        0.0;

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        isCompact ? 16 : 24,
        isCompact ? 18 : 24,
        isCompact ? 16 : 24,
        24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(isCompact),
          SizedBox(height: isCompact ? 18 : 24),
          GridView.count(
            crossAxisCount: isWide ? 4 : 2,
            crossAxisSpacing: isCompact ? 10 : 16,
            mainAxisSpacing: isCompact ? 10 : 16,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: isCompact ? 1.18 : 1.5,
            children: [
              _buildKpiCard(
                title: 'Omzet Hari Ini',
                value: 'Rp ${todaySales.toStringAsFixed(0)}',
                icon: Icons.monetization_on_rounded,
                gradientColors: const [Color(0xFFFFB570), Color(0xFFFF9A4D)],
              ),
              _buildKpiCard(
                title: 'Jumlah Transaksi',
                value: '$todayTrx Transaksi',
                icon: Icons.receipt_long_rounded,
                gradientColors: const [Color(0xFF6EE7B7), Color(0xFF34D399)],
              ),
              _buildKpiCard(
                title: 'Item Terjual',
                value: '$todayItems Pcs',
                icon: Icons.shopping_bag_rounded,
                gradientColors: const [Color(0xFF93C5FD), Color(0xFF60A5FA)],
              ),
              _buildKpiCard(
                title: 'Rata-Rata Order',
                value: 'Rp ${avgValue.toStringAsFixed(0)}',
                icon: Icons.analytics_rounded,
                gradientColors: const [Color(0xFFC084FC), Color(0xFFA855F7)],
              ),
            ],
          ),
          SizedBox(height: isCompact ? 18 : 28),
          if (isWide)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 6,
                  child: _buildTopProductsSection(isCompact: false),
                ),
                const SizedBox(width: 24),
                Expanded(
                  flex: 4,
                  child: _buildCategoryBreakdownSection(isCompact: false),
                ),
              ],
            )
          else
            Column(
              children: [
                _buildTopProductsSection(isCompact: isCompact),
                const SizedBox(height: 14),
                _buildCategoryBreakdownSection(isCompact: isCompact),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isCompact) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Dashboard Analitik',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: _plusJakarta(
                  fontSize: isCompact ? 22 : 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Ringkasan performa penjualan hari ini',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: _plusJakarta(fontSize: 12, color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
        IconButton(
          icon: _loading
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.refresh_rounded, color: Color(0xFFFFB570)),
          onPressed: _loading ? null : _fetchAnalytics,
        ),
      ],
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
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: gradientColors.first.withValues(alpha: 0.28),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: _plusJakarta(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Colors.white70,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Icon(icon, color: Colors.white, size: 22),
            ],
          ),
          Text(
            value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: _plusJakarta(
              fontSize: 17,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopProductsSection({required bool isCompact}) {
    return _sectionShell(
      isCompact: isCompact,
      icon: Icons.emoji_events_rounded,
      title: 'Produk Terlaris',
      child: _topProducts.isEmpty
          ? _emptyState('Belum ada data penjualan tercatat hari ini.')
          : ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _topProducts.length,
              itemBuilder: (context, index) {
                final item = _topProducts[index];
                final name = item['product_name']?.toString() ?? '-';
                final qty = int.tryParse(item['quantity_sold'].toString()) ?? 0;

                return Padding(
                  padding: EdgeInsets.only(top: index == 0 ? 0 : 14),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: const Color(0xFFFFF3E6),
                        child: Text(
                          '#${index + 1}',
                          style: _plusJakarta(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFFFF9A4D),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: _plusJakarta(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '$qty Pcs',
                        style: _plusJakarta(
                          fontSize: 13,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  Widget _buildCategoryBreakdownSection({required bool isCompact}) {
    return _sectionShell(
      isCompact: isCompact,
      icon: Icons.bar_chart_rounded,
      title: 'Distribusi Kategori',
      child: _categoryBreakdown.isEmpty
          ? _emptyState('Belum ada distribusi data.')
          : Column(
              children: _categoryBreakdown.entries.map((entry) {
                final key = entry.key;
                final val = double.tryParse(entry.value.toString()) ?? 0.0;

                Color barColor = Colors.grey;
                if (key == 'cat') {
                  barColor = Colors.orange;
                } else if (key == 'dog') {
                  barColor = Colors.blue;
                } else if (key == 'hamster') {
                  barColor = Colors.green;
                } else if (key == 'rabbit') {
                  barColor = Colors.red;
                }

                return Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.pets_rounded, color: barColor, size: 16),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              key.toUpperCase(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: _plusJakarta(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
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
                        value: val.clamp(0, 100) / 100.0,
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
    );
  }

  Widget _sectionShell({
    required bool isCompact,
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade100),
      ),
      padding: EdgeInsets.all(isCompact ? 16 : 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFFFFB570), size: 22),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: _plusJakarta(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(height: 1),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }

  Widget _emptyState(String message) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 22),
      child: Center(
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: _plusJakarta(color: Colors.grey),
        ),
      ),
    );
  }
}
