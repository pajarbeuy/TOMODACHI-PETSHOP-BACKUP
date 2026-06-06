import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SalesData {
  final String day;
  final double sales;
  final int transactions;

  SalesData({
    required this.day,
    required this.sales,
    required this.transactions,
  });
}

class MonthlyData {
  final String month;
  final double revenue;

  MonthlyData({required this.month, required this.revenue});
}

class Product {
  final int id;
  final String name;
  final String category;
  final int sales;
  final double revenue;
  final String emoji;
  final int trend;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.sales,
    required this.revenue,
    required this.emoji,
    required this.trend,
  });
}

class Transaction {
  final String id;
  final String customer;
  final int items;
  final double total;
  final String method;
  final String time;
  final String status;

  Transaction({
    required this.id,
    required this.customer,
    required this.items,
    required this.total,
    required this.method,
    required this.time,
    required this.status,
  });
}

class LowStockItem {
  final int id;
  final String name;
  final int stock;
  final int min;
  final String emoji;
  final bool critical;

  LowStockItem({
    required this.id,
    required this.name,
    required this.stock,
    required this.min,
    required this.emoji,
    required this.critical,
  });
}

class DashboardTab extends StatelessWidget {
  DashboardTab({super.key});

  final List<SalesData> salesData = [
    SalesData(day: 'Mon', sales: 1250000, transactions: 18),
    SalesData(day: 'Tue', sales: 980000, transactions: 14),
    SalesData(day: 'Wed', sales: 1450000, transactions: 22),
    SalesData(day: 'Thu', sales: 1100000, transactions: 16),
    SalesData(day: 'Fri', sales: 1680000, transactions: 25),
    SalesData(day: 'Sat', sales: 2100000, transactions: 32),
    SalesData(day: 'Sun', sales: 1890000, transactions: 28),
  ];

  final List<MonthlyData> monthlyData = [
    MonthlyData(month: 'Jan', revenue: 32000000),
    MonthlyData(month: 'Feb', revenue: 28500000),
    MonthlyData(month: 'Mar', revenue: 35200000),
    MonthlyData(month: 'Apr', revenue: 31800000),
    MonthlyData(month: 'May', revenue: 38500000),
    MonthlyData(month: 'Jun', revenue: 42000000),
  ];

  final List<Product> bestSellers = [
    Product(
      id: 1,
      name: 'Royal Canin Dog Food 2kg',
      category: 'Food',
      sales: 124,
      revenue: 18045000,
      emoji: '🐕',
      trend: 12,
    ),
    Product(
      id: 2,
      name: 'Whiskas Cat Food 1.2kg',
      category: 'Food',
      sales: 98,
      revenue: 6370000,
      emoji: '🐈',
      trend: 8,
    ),
    Product(
      id: 3,
      name: 'Kong Classic Dog Toy',
      category: 'Toys',
      sales: 87,
      revenue: 7743000,
      emoji: '🦴',
      trend: -3,
    ),
    Product(
      id: 4,
      name: 'Frontline Plus Antiparasitic',
      category: 'Medicine',
      sales: 65,
      revenue: 9425000,
      emoji: '💊',
      trend: 15,
    ),
    Product(
      id: 5,
      name: 'Dog Shampoo Premium',
      category: 'Grooming',
      sales: 54,
      revenue: 2970000,
      emoji: '🛁',
      trend: 5,
    ),
  ];

  final List<Transaction> recentTransactions = [
    Transaction(
      id: 'TRX-0241',
      customer: 'Budi Santoso',
      items: 3,
      total: 285000,
      method: 'Cash',
      time: '10 min ago',
      status: 'completed',
    ),
    Transaction(
      id: 'TRX-0240',
      customer: 'Siti Rahayu',
      items: 2,
      total: 155000,
      method: 'QRIS',
      time: '28 min ago',
      status: 'completed',
    ),
    Transaction(
      id: 'TRX-0239',
      customer: 'Ahmad Fadli',
      items: 5,
      total: 520000,
      method: 'Card',
      time: '1h ago',
      status: 'completed',
    ),
    Transaction(
      id: 'TRX-0238',
      customer: 'Dewi Kusuma',
      items: 1,
      total: 89000,
      method: 'Cash',
      time: '2h ago',
      status: 'completed',
    ),
    Transaction(
      id: 'TRX-0237',
      customer: 'Rizki Pratama',
      items: 4,
      total: 375000,
      method: 'Transfer',
      time: '3h ago',
      status: 'completed',
    ),
  ];

  final List<LowStockItem> lowStockItems = [
    LowStockItem(
      id: 1,
      name: 'Cat Litter Silica Gel 5kg',
      stock: 3,
      min: 10,
      emoji: '🐈',
      critical: true,
    ),
    LowStockItem(
      id: 2,
      name: 'Whiskas Tuna Cat Food',
      stock: 8,
      min: 15,
      emoji: '🐈',
      critical: false,
    ),
    LowStockItem(
      id: 3,
      name: 'Aquarium Starter Kit 20L',
      stock: 5,
      min: 10,
      emoji: '🐠',
      critical: false,
    ),
    LowStockItem(
      id: 4,
      name: 'Bird Cage Medium',
      stock: 7,
      min: 10,
      emoji: '🦜',
      critical: false,
    ),
  ];

  String formatRp(double n) {
    if (n >= 1000000) return 'Rp ${(n / 1000000).toStringAsFixed(1)}jt';
    if (n >= 1000) return 'Rp ${(n / 1000).toStringAsFixed(0)}rb';
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(n);
  }

  String formatRpFull(double n) {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(n);
  }

  @override
  Widget build(BuildContext context) {
    final hour = DateTime.now().hour;
    final greeting = hour < 12
        ? 'Good Morning'
        : hour < 17
        ? 'Good Afternoon'
        : 'Good Evening';
    final todayStr = DateFormat('EEEE, d MMMM yyyy').format(DateTime.now());

    return Scaffold(
      backgroundColor: const Color(0xFFFDFBF7),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(greeting, todayStr),
            const SizedBox(height: 24),
            _buildStats(context),
            const SizedBox(height: 24),
            _buildResponsivePair(
              firstFlex: 2,
              secondFlex: 1,
              first: _buildSalesTrendCard(),
              second: _buildBestSellersCard(),
            ),
            const SizedBox(height: 16),
            _buildResponsivePair(
              firstFlex: 2,
              secondFlex: 1,
              first: _buildRecentTransactionsCard(),
              second: _buildLowStockCard(),
            ),
            const SizedBox(height: 16),
            _buildMonthlyBarChartCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(String greeting, String todayStr) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 640;
        final title = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$greeting! 🌟',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: Color(0xFF3D2314),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '$todayStr · Here\'s what\'s happening at Tomodachi Petshop',
              style: const TextStyle(color: Color(0xFF9B7B6B), fontSize: 13),
            ),
          ],
        );
        final actions = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF6B4F3E),
                side: const BorderSide(color: Color(0x4DFFB570)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 1,
              ),
              child: const Text(
                'Today',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 8),
            _gradientButton('+ New Transaction', onPressed: () {}),
          ],
        );

        if (!isWide) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [title, const SizedBox(height: 16), actions],
          );
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: title),
            const SizedBox(width: 16),
            actions,
          ],
        );
      },
    );
  }

  Widget _buildStats(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        _buildStatCard(
          context,
          label: "Today's Sales",
          value: formatRp(1890000),
          sub: 'From 28 transactions',
          icon: const Icon(Icons.attach_money, color: Color(0xFFFF9A4D)),
          trend: 12,
          gradient: const [Color(0xFFFFF6E9), Color(0xFFFFE8CC)],
          iconBg: const Color(0x33FFB570),
        ),
        _buildStatCard(
          context,
          label: 'Total Transactions',
          value: '28',
          sub: '8 more than yesterday',
          icon: const Icon(
            Icons.shopping_bag_outlined,
            color: Color(0xFFE07B9E),
          ),
          trend: 8,
          gradient: const [Color(0xFFFFF0F5), Color(0xFFFFE0EC)],
          iconBg: const Color(0x4DFFC7D1),
        ),
        _buildStatCard(
          context,
          label: 'Monthly Revenue',
          value: formatRp(42000000),
          sub: 'June 2024',
          icon: const Icon(Icons.trending_up, color: Color(0xFF1B9E85)),
          trend: 15,
          gradient: const [Color(0xFFF0FDF9), Color(0xFFD4F5EE)],
          iconBg: const Color(0x80B8F2E6),
        ),
        _buildStatCard(
          context,
          label: 'Active Products',
          value: '48',
          sub: '4 need restocking',
          icon: const Icon(
            Icons.inventory_2_outlined,
            color: Color(0xFF4A9FD4),
          ),
          trend: -2,
          gradient: const [Color(0xFFF0FAFE), Color(0xFFD4EFFD)],
          iconBg: const Color(0x66A0E7E5),
        ),
      ],
    );
  }

  Widget _buildResponsivePair({
    required int firstFlex,
    required int secondFlex,
    required Widget first,
    required Widget second,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth <= 800) {
          return Column(children: [first, const SizedBox(height: 16), second]);
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: firstFlex, child: first),
            const SizedBox(width: 16),
            Expanded(flex: secondFlex, child: second),
          ],
        );
      },
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required String label,
    required String value,
    required String sub,
    required Widget icon,
    required int trend,
    required List<Color> gradient,
    required Color iconBg,
  }) {
    double cardWidth = (MediaQuery.of(context).size.width - 64) / 2;
    if (MediaQuery.of(context).size.width > 1100) {
      cardWidth = (MediaQuery.of(context).size.width - 96) / 4;
    }

    return Container(
      width: cardWidth < 170 ? 170 : cardWidth,
      padding: const EdgeInsets.all(20),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.6)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -36,
            bottom: -36,
            child: Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.2),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          label,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF6B4F3E),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          value,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF3D2314),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          sub,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF9B7B6B),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: iconBg,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: icon,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: trend >= 0
                          ? const Color(0xFFB8F2E6)
                          : const Color(0xFFFFD4D4),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Transform.rotate(
                          angle: trend >= 0 ? 0 : 3.14159,
                          child: Icon(
                            Icons.arrow_outward,
                            size: 11,
                            color: trend >= 0
                                ? const Color(0xFF1B7A65)
                                : const Color(0xFFC0392B),
                          ),
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '${trend.abs()}%',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w900,
                            color: trend >= 0
                                ? const Color(0xFF1B7A65)
                                : const Color(0xFFC0392B),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    'vs last week',
                    style: TextStyle(fontSize: 11, color: Color(0xFF9B7B6B)),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSalesTrendCard() {
    return Container(
      height: 300,
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sales Trend',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF3D2314),
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Last 7 days',
                    style: TextStyle(fontSize: 11, color: Color(0xFF9B7B6B)),
                  ),
                ],
              ),
              Row(
                children: [
                  _rangeButton('7D', selected: true),
                  const SizedBox(width: 6),
                  _rangeButton('30D'),
                  const SizedBox(width: 6),
                  _rangeButton('3M'),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (v) => FlLine(
                    color: const Color(0xFFFFB570).withValues(alpha: 0.15),
                    strokeWidth: 1,
                  ),
                ),
                titlesData: FlTitlesData(
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (v, m) => Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          salesData[v.toInt() % salesData.length].day,
                          style: const TextStyle(
                            fontSize: 10,
                            color: Color(0xFF9B7B6B),
                          ),
                        ),
                      ),
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 45,
                      getTitlesWidget: (v, m) => Text(
                        '${(v / 1000000).toStringAsFixed(1)}jt',
                        style: const TextStyle(
                          fontSize: 9,
                          color: Color(0xFF9B7B6B),
                        ),
                      ),
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: salesData
                        .asMap()
                        .entries
                        .map((e) => FlSpot(e.key.toDouble(), e.value.sales))
                        .toList(),
                    isCurved: true,
                    color: const Color(0xFFFFB570),
                    barWidth: 3,
                    belowBarData: BarAreaData(
                      show: true,
                      color: const Color(0xFFFFB570).withValues(alpha: 0.15),
                    ),
                    dotData: const FlDotData(show: true),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBestSellersCard() {
    return Container(
      height: 300,
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Best Sellers',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF3D2314),
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'This month',
                    style: TextStyle(fontSize: 11, color: Color(0xFF9B7B6B)),
                  ),
                ],
              ),
              Icon(Icons.star, size: 18, color: Color(0xFFFFB570)),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              itemCount: bestSellers.length,
              itemBuilder: (context, index) {
                final p = bestSellers[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: index == 0
                              ? const Color(0xFFFFB570)
                              : index == 1
                              ? const Color(0xFFFFC7D1)
                              : const Color(0xFFF5E8D5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w900,
                            color: index == 0
                                ? Colors.white
                                : index == 1
                                ? const Color(0xFF8B2F47)
                                : const Color(0xFF9B7B6B),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(p.emoji, style: const TextStyle(fontSize: 20)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              p.name,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF3D2314),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              '${p.sales} sold · ${formatRp(p.revenue)}',
                              style: const TextStyle(
                                fontSize: 10,
                                color: Color(0xFF9B7B6B),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '${p.trend >= 0 ? '+' : ''}${p.trend}%',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                          color: p.trend >= 0
                              ? const Color(0xFF1B7A65)
                              : const Color(0xFFC0392B),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentTransactionsCard() {
    return Container(
      decoration: _cardDecoration(),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Recent Transactions',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF3D2314),
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Today\'s activity',
                      style: TextStyle(fontSize: 11, color: Color(0xFF9B7B6B)),
                    ),
                  ],
                ),
                TextButton.icon(
                  onPressed: () {},
                  label: const Text('View all'),
                  icon: const Icon(Icons.arrow_outward, size: 13),
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFFFFB570),
                    textStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0x1FFFB570)),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: recentTransactions.length,
            separatorBuilder: (context, i) =>
                const Divider(height: 1, color: Color(0x11FFB570)),
            itemBuilder: (context, index) {
              final tx = recentTransactions[index];
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF0E0),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.shopping_bag,
                        size: 16,
                        color: Color(0xFFFFB570),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tx.customer,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF3D2314),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            '${tx.id} · ${tx.items} items · ${tx.method}',
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF9B7B6B),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          formatRpFull(tx.total),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF3D2314),
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.access_time,
                              size: 9,
                              color: Color(0xFF9B7B6B),
                            ),
                            const SizedBox(width: 3),
                            Text(
                              tx.time,
                              style: const TextStyle(
                                fontSize: 10,
                                color: Color(0xFF9B7B6B),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xFFB8F2E6),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLowStockCard() {
    return Container(
      decoration: _cardDecoration(),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Low Stock Alert',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF3D2314),
                      ),
                    ),
                    Text(
                      '${lowStockItems.length} items need restocking',
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF9B7B6B),
                      ),
                    ),
                  ],
                ),
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF0E0),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.warning_amber_rounded,
                    size: 16,
                    color: Color(0xFFFFB570),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0x1FFFB570)),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: lowStockItems.length,
            separatorBuilder: (context, i) =>
                const Divider(height: 1, color: Color(0x11FFB570)),
            itemBuilder: (context, index) {
              final item = lowStockItems[index];
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    Text(item.emoji, style: const TextStyle(fontSize: 22)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF3D2314),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(999),
                                  child: LinearProgressIndicator(
                                    value: (item.stock / item.min).clamp(0, 1),
                                    backgroundColor: const Color(0xFFF5E8D5),
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      item.critical
                                          ? const Color(0xFFFF6B6B)
                                          : const Color(0xFFFFB570),
                                    ),
                                    minHeight: 6,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${item.stock} left',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w900,
                                  color: item.critical
                                      ? const Color(0xFFFF6B6B)
                                      : const Color(0xFFFFB570),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (item.critical) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFD4D4),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: const Text(
                          'CRITICAL',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFFC0392B),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
          const Divider(height: 1, color: Color(0x1FFFB570)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: SizedBox(
              width: double.infinity,
              child: _gradientButton(
                'Restock All',
                dense: true,
                onPressed: () {},
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlyBarChartCard() {
    return Container(
      height: 280,
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Monthly Revenue Overview',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF3D2314),
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'January – June 2024',
                    style: TextStyle(fontSize: 11, color: Color(0xFF9B7B6B)),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0x66B8F2E6),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.trending_up, size: 13, color: Color(0xFF1B7A65)),
                    SizedBox(width: 5),
                    Text(
                      '+18.5% YoY',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF1B7A65),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 50000000,
                barTouchData: BarTouchData(enabled: true),
                titlesData: FlTitlesData(
                  show: true,
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (v, m) => Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          monthlyData[v.toInt() % monthlyData.length].month,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF9B7B6B),
                          ),
                        ),
                      ),
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (v, m) => Text(
                        '${(v / 1000000).toStringAsFixed(0)}jt',
                        style: const TextStyle(
                          fontSize: 10,
                          color: Color(0xFF9B7B6B),
                        ),
                      ),
                    ),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (v) => FlLine(
                    color: const Color(0xFFFFB570).withValues(alpha: 0.12),
                    strokeWidth: 1,
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: monthlyData.asMap().entries.map((e) {
                  return BarChartGroupData(
                    x: e.key,
                    barRods: [
                      BarChartRodData(
                        toY: e.value.revenue,
                        color: e.key == monthlyData.length - 1
                            ? const Color(0xFFFF9A4D)
                            : const Color(0xFFFFD4A8),
                        width: 36,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _rangeButton(String label, {bool selected = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: selected ? const Color(0xFFFFB570) : const Color(0xFFFFF0E0),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w900,
          color: selected ? Colors.white : const Color(0xFF9B7B6B),
        ),
      ),
    );
  }

  Widget _gradientButton(
    String label, {
    required VoidCallback onPressed,
    bool dense = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Ink(
          padding: EdgeInsets.symmetric(
            horizontal: dense ? 12 : 16,
            vertical: dense ? 9 : 11,
          ),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFFB570), Color(0xFFFF9A4D)],
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFF9650).withValues(alpha: 0.3),
                blurRadius: 14,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: dense ? 12 : 13,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: const Color(0xFFFFB570).withValues(alpha: 0.12),
      ),
      boxShadow: [
        BoxShadow(
          color: const Color(0xFFFF9A4D).withValues(alpha: 0.08),
          blurRadius: 16,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }
}
