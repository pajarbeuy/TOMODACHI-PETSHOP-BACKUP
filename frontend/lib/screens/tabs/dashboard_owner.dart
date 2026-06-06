import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../dashboard_service.dart';

class DashboardOwner extends StatefulWidget {
  final DashboardService dashboardService;

  const DashboardOwner({
    super.key,
    required this.dashboardService,
  });

  @override
  State<DashboardOwner> createState() => _DashboardOwnerState();
}

class _DashboardOwnerState extends State<DashboardOwner> {
  TextStyle _plusJakarta({
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.w500,
    Color color = const Color(0xFF3D2314),
    double letterSpacing = -0.3,
  }) =>
      GoogleFonts.plusJakartaSans(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        letterSpacing: letterSpacing,
      );

  bool _loading = false;
  Map<String, dynamic> _kpi = {};
  String _selectedTrendPeriod = '7D';

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
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memuat dashboard: ${e.toString()}')),
        );
      }
    } finally {
      setState(() => _loading = false);
    }
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  @override
  Widget build(BuildContext context) {
    if (_loading && _kpi.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Greeting Header
          _buildGreetingHeader(),
          const SizedBox(height: 24),

          // KPI Cards - Today's Sales, Total Transactions, Monthly Revenue, Active Products
          _buildKpiCardsSection(),
          const SizedBox(height: 32),

          // Sales Trend Section
          _buildSalesTrendSection(),
          const SizedBox(height: 32),

          // Best Sellers Section
          _buildBestSellersSection(),
          const SizedBox(height: 32),

          // Recent Transactions & Low Stock Alert
          if (MediaQuery.of(context).size.width >= 1200)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _buildRecentTransactionsSection()),
                const SizedBox(width: 24),
                Expanded(child: _buildLowStockAlertSection()),
              ],
            )
          else
            Column(
              children: [
                _buildRecentTransactionsSection(),
                const SizedBox(height: 24),
                _buildLowStockAlertSection(),
              ],
            ),
          const SizedBox(height: 32),

          // Monthly Revenue Overview
          _buildMonthlyRevenueSection(),
        ],
      ),
    );
  }

  Widget _buildGreetingHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${_getGreeting()}! ☀️',
              style: _plusJakarta(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Friday, 5 June 2026 · Here\'s what\'s happening at Tomodachi Petshop',
              style: _plusJakarta(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.today, color: Color(0xFFFFB570)),
              onPressed: () {},
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFB570),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.add, size: 18, color: Colors.white),
                  const SizedBox(width: 4),
                  Text(
                    'New Transaction',
                    style: _plusJakarta(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildKpiCardsSection() {
    return GridView.count(
      crossAxisCount: MediaQuery.of(context).size.width >= 1200
          ? 4
          : MediaQuery.of(context).size.width >= 800
              ? 2
              : 1,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.3,
      children: [
        _buildMetricCard(
          icon: Icons.monetization_on,
          title: 'Today\'s Sales',
          value: 'Rp 1.9jt',
          subtitle: 'From 28 transactions',
          colors: [const Color(0xFFFFF0E6)],
          badge: '↑ 12%',
          badgeColor: const Color(0xFFDCFCE7),
        ),
        _buildMetricCard(
          icon: Icons.shopping_bag_outlined,
          title: 'Total Transactions',
          value: '28',
          subtitle: '8 more than yesterday',
          colors: [const Color(0xFFE0F2FE)],
          badge: '↑ 8%',
          badgeColor: const Color(0xFFDCFCE7),
        ),
        _buildMetricCard(
          icon: Icons.trending_up,
          title: 'Monthly Revenue',
          value: 'Rp 42.0jt',
          subtitle: 'June 2024',
          colors: [const Color(0xFFDCFCE7)],
          badge: '↑ 15%',
          badgeColor: const Color(0xFFDCFCE7),
        ),
        _buildMetricCard(
          icon: Icons.inventory,
          title: 'Active Products',
          value: '48',
          subtitle: '4 need restocking',
          colors: [const Color(0xFFCDD5FE)],
          badge: '↓ 2%',
          badgeColor: const Color(0xFFFFE6E6),
        ),
      ],
    );
  }

  Widget _buildMetricCard({
    required IconData icon,
    required String title,
    required String value,
    required String subtitle,
    required List<Color> colors,
    required String badge,
    required Color badgeColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: colors[0],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: const Color(0xFFFFB570), size: 20),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: badgeColor,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  badge,
                  style: _plusJakarta(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: badge.contains('↑')
                        ? const Color(0xFF059669)
                        : const Color(0xFFDC2626),
                  ),
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: _plusJakarta(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                title,
                style: _plusJakarta(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: _plusJakarta(
                  fontSize: 11,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSalesTrendSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
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
                    'Sales Trend',
                    style: _plusJakarta(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Last 7 days',
                    style: _plusJakarta(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
              Row(
                children: ['7D', '30D', '3M'].map((period) {
                  return GestureDetector(
                    onTap: () => setState(() => _selectedTrendPeriod = period),
                    child: Container(
                      margin: const EdgeInsets.only(left: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _selectedTrendPeriod == period
                            ? const Color(0xFFFFB570)
                            : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        period,
                        style: _plusJakarta(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _selectedTrendPeriod == period
                              ? Colors.white
                              : Colors.grey.shade700,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSimpleTrendChart(),
        ],
      ),
    );
  }

  Widget _buildSimpleTrendChart() {
    final data = [
      {'day': 'Mon', 'value': 1.1},
      {'day': 'Tue', 'value': 0.95},
      {'day': 'Wed', 'value': 1.2},
      {'day': 'Thu', 'value': 1.1},
      {'day': 'Fri', 'value': 1.3},
      {'day': 'Sat', 'value': 1.5},
      {'day': 'Sun', 'value': 1.4},
    ];

    final maxValue = 1.6;

    return SizedBox(
      height: 280,
      child: CustomPaint(
        painter: TrendChartPainter(data: data, maxValue: maxValue),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: data.map((item) {
              return SizedBox(
                width: 40,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const SizedBox(height: 80),
                    Text(
                      item['day'].toString(),
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildBestSellersSection() {
    final products = [
      {
        'rank': 1,
        'name': 'Royal Canin Dog Food 2kg',
        'sold': 124,
        'revenue': 'Rp 18.0jt',
        'growth': '+12%',
      },
      {
        'rank': 2,
        'name': 'Whiskas Cat Food 1.2kg',
        'sold': 98,
        'revenue': 'Rp 6.4jt',
        'growth': '+8%',
      },
      {
        'rank': 3,
        'name': 'Kong Classic Dog Toy',
        'sold': 87,
        'revenue': 'Rp 7.7jt',
        'growth': '-3%',
      },
      {
        'rank': 4,
        'name': 'Frontline Plus Antiparasitic',
        'sold': 65,
        'revenue': 'Rp 9.4jt',
        'growth': '+15%',
      },
      {
        'rank': 5,
        'name': 'Dog Shampoo Premium',
        'sold': 54,
        'revenue': 'Rp 3.0jt',
        'growth': '+5%',
      },
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Best Sellers',
            style: _plusJakarta(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'This month',
            style: _plusJakarta(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 20),
          ...products.map((product) {
            final isPositive = (product['growth'] as String).contains('+');
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        product['rank'].toString(),
                        style: _plusJakarta(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: product['rank'] == 1
                              ? const Color(0xFFFFB570)
                              : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product['name'].toString(),
                          style: _plusJakarta(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          '${product['sold']} sold · ${product['revenue']}',
                          style: _plusJakarta(
                            fontSize: 11,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isPositive
                          ? const Color(0xFFDCFCE7)
                          : const Color(0xFFFFE6E6),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      product['growth'].toString(),
                      style: _plusJakarta(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: isPositive
                            ? const Color(0xFF059669)
                            : const Color(0xFFDC2626),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildRecentTransactionsSection() {
    final transactions = [
      {
        'name': 'Budi Santoso',
        'code': 'TRX-0241',
        'items': '3 items',
        'type': 'Cash',
        'amount': 'Rp 285.000',
        'time': '10 min ago',
        'color': const Color(0xFF6EE7B7),
      },
      {
        'name': 'Siti Rahayu',
        'code': 'TRX-0240',
        'items': '2 items',
        'type': 'QRIS',
        'amount': 'Rp 155.000',
        'time': '28 min ago',
        'color': const Color(0xFFC084FC),
      },
      {
        'name': 'Ahmad Fadli',
        'code': 'TRX-0239',
        'items': '5 items',
        'type': 'Card',
        'amount': 'Rp 520.000',
        'time': '1h ago',
        'color': const Color(0xFF60A5FA),
      },
      {
        'name': 'Dewi Kusuma',
        'code': 'TRX-0238',
        'items': '1 items',
        'type': 'Cash',
        'amount': 'Rp 89.000',
        'time': '2h ago',
        'color': const Color(0xFFFFB570),
      },
      {
        'name': 'Rizki Pratama',
        'code': 'TRX-0237',
        'items': '4 items',
        'type': 'Transfer',
        'amount': 'Rp 375.000',
        'time': '3h ago',
        'color': const Color(0xFF6EE7B7),
      },
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Transactions',
                style: _plusJakarta(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'View all →',
                style: _plusJakarta(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFFFB570),
                ),
              ),
            ],
          ),
          Text(
            'Today\'s activity',
            style: _plusJakarta(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 16),
          ...transactions.map((trx) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: (trx['color'] as Color).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.shopping_bag_outlined,
                        color: trx['color'] as Color,
                        size: 18,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          trx['name'].toString(),
                          style: _plusJakarta(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '${trx['code']} · ${trx['items']} · ${trx['type']}',
                          style: _plusJakarta(
                            fontSize: 10,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        trx['amount'].toString(),
                        style: _plusJakarta(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        trx['time'].toString(),
                        style: _plusJakarta(
                          fontSize: 10,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildLowStockAlertSection() {
    final lowStockItems = [
      {
        'name': 'Cat Litter Silica Gel 5kg',
        'stock': 3,
        'status': 'CRITICAL',
        'icon': '🐱',
      },
      {
        'name': 'Whiskas Tuna Cat Food',
        'stock': 8,
        'status': 'WARNING',
        'icon': '🐱',
      },
      {
        'name': 'Aquarium Starter Kit 20L',
        'stock': 5,
        'status': 'LOW',
        'icon': '🐠',
      },
      {
        'name': 'Bird Cage Medium',
        'stock': 7,
        'status': 'WARNING',
        'icon': '🐦',
      },
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Low Stock Alert',
                style: _plusJakarta(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE6E6),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '4 items need restocking',
                  style: _plusJakarta(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFFDC2626),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...lowStockItems.map((item) {
            Color statusColor = const Color(0xFF059669);
            if (item['status'] == 'CRITICAL') {
              statusColor = const Color(0xFFDC2626);
            } else if (item['status'] == 'WARNING') {
              statusColor = const Color(0xFFFFB570);
            }

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        item['icon'].toString(),
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['name'].toString(),
                          style: _plusJakarta(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: Text(
                          '${item['stock']} left',
                          style: _plusJakarta(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: statusColor,
                          ),
                        ),
                      ),
                      Text(
                        item['status'].toString(),
                        style: _plusJakarta(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: statusColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }).toList(),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFB570),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Restock All',
              textAlign: TextAlign.center,
              style: _plusJakarta(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlyRevenueSection() {
    final months = [
      {'month': 'Jan', 'value': 30.0},
      {'month': 'Feb', 'value': 28.0},
      {'month': 'Mar', 'value': 32.0},
      {'month': 'Apr', 'value': 40.0},
      {'month': 'May', 'value': 22.0},
      {'month': 'Jun', 'value': 50.0},
    ];

    final maxValue = 60.0;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
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
                    'Monthly Revenue Overview',
                    style: _plusJakarta(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'January - June 2024',
                    style: _plusJakarta(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFDCFCE7),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '↑ +18.5% YoY',
                  style: _plusJakarta(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF059669),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 280,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: months.map((item) {
                final barHeight = ((item['value'] as double) / maxValue) * 200;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '${(item['value'] as double).toStringAsFixed(0)}jt',
                      style: _plusJakarta(fontSize: 10, color: Colors.grey.shade600),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: 30,
                      height: barHeight,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFB570),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4),
                          topRight: Radius.circular(4),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      item['month'].toString(),
                      style: _plusJakarta(fontSize: 11, color: Colors.grey.shade600),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class TrendChartPainter extends CustomPainter {
  final List<dynamic> data;
  final double maxValue;

  TrendChartPainter({required this.data, required this.maxValue});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFFFB570)
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final fillPaint = Paint()
      ..color = const Color(0xFFFFB570).withOpacity(0.1)
      ..style = PaintingStyle.fill;

    // Draw grid lines
    final gridPaint = Paint()
      ..color = Colors.grey.shade200
      ..strokeWidth = 1;

    final gridY = 200 / 4;
    for (int i = 1; i < 4; i++) {
      canvas.drawLine(
        Offset(0, gridY * i),
        Offset(size.width, gridY * i),
        gridPaint,
      );
    }

    // Calculate points
    final points = <Offset>[];
    for (int i = 0; i < data.length; i++) {
      final value = data[i]['value'] as double;
      final normalizedValue = (value / maxValue) * 200;
      final x = (size.width / (data.length - 1)) * i;
      final y = 200 - normalizedValue;
      points.add(Offset(x, y));
    }

    // Draw filled area under line
    if (points.isNotEmpty) {
      final path = Path();
      path.moveTo(points.first.dx, points.first.dy);
      for (int i = 1; i < points.length; i++) {
        path.cubicTo(
          points[i - 1].dx + 30,
          points[i - 1].dy,
          points[i].dx - 30,
          points[i].dy,
          points[i].dx,
          points[i].dy,
        );
      }
      path.lineTo(points.last.dx, 200);
      path.lineTo(points.first.dx, 200);
      path.close();
      canvas.drawPath(path, fillPaint);

      // Draw smooth line
      final linePath = Path();
      linePath.moveTo(points.first.dx, points.first.dy);
      for (int i = 1; i < points.length; i++) {
        linePath.cubicTo(
          points[i - 1].dx + 30,
          points[i - 1].dy,
          points[i].dx - 30,
          points[i].dy,
          points[i].dx,
          points[i].dy,
        );
      }
      canvas.drawPath(linePath, paint);

      // Draw dots
      final dotPaint = Paint()
        ..color = const Color(0xFFFFB570)
        ..style = PaintingStyle.fill;

      for (final point in points) {
        canvas.drawCircle(point, 5, dotPaint);
        canvas.drawCircle(
          point,
          5,
          Paint()
            ..color = Colors.white
            ..strokeWidth = 2
            ..style = PaintingStyle.stroke,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}