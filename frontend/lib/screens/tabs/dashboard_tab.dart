import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SalesData {
  final String day;
  final double sales;
  final int transactions;

  const SalesData({
    required this.day,
    required this.sales,
    required this.transactions,
  });
}

class MonthlyData {
  final String month;
  final double revenue;

  const MonthlyData({required this.month, required this.revenue});
}

class ProductRank {
  final int id;
  final String name;
  final String category;
  final int sales;
  final double revenue;
  final IconData icon;
  final int trend;

  const ProductRank({
    required this.id,
    required this.name,
    required this.category,
    required this.sales,
    required this.revenue,
    required this.icon,
    required this.trend,
  });
}

class RecentTransaction {
  final String id;
  final String customer;
  final int items;
  final double total;
  final String method;
  final String time;

  const RecentTransaction({
    required this.id,
    required this.customer,
    required this.items,
    required this.total,
    required this.method,
    required this.time,
  });
}

class LowStockItem {
  final int id;
  final String name;
  final int stock;
  final int min;
  final IconData icon;
  final bool critical;

  const LowStockItem({
    required this.id,
    required this.name,
    required this.stock,
    required this.min,
    required this.icon,
    required this.critical,
  });
}

class DashboardTab extends StatelessWidget {
  DashboardTab({super.key});

  static const _brown900 = Color(0xFF3D2314);
  static const _brown700 = Color(0xFF6B4F3E);
  static const _brown400 = Color(0xFF9B7B6B);
  static const _orange = Color(0xFFFFB570);
  static const _orangeDark = Color(0xFFFF9A4D);
  static const _pink = Color(0xFFE07B9E);
  static const _green = Color(0xFF1B9E85);
  static const _blue = Color(0xFF4A9FD4);
  static const _successBg = Color(0xFFB8F2E6);
  static const _dangerBg = Color(0xFFFFD4D4);
  static const _pageBg = Color(0xFFFDFBF7);

  static const List<SalesData> salesData = [
    SalesData(day: 'Mon', sales: 1250000, transactions: 18),
    SalesData(day: 'Tue', sales: 980000, transactions: 14),
    SalesData(day: 'Wed', sales: 1450000, transactions: 22),
    SalesData(day: 'Thu', sales: 1100000, transactions: 16),
    SalesData(day: 'Fri', sales: 1680000, transactions: 25),
    SalesData(day: 'Sat', sales: 2100000, transactions: 32),
    SalesData(day: 'Sun', sales: 1890000, transactions: 28),
  ];

  static const List<MonthlyData> monthlyData = [
    MonthlyData(month: 'Jan', revenue: 32000000),
    MonthlyData(month: 'Feb', revenue: 28500000),
    MonthlyData(month: 'Mar', revenue: 35200000),
    MonthlyData(month: 'Apr', revenue: 31800000),
    MonthlyData(month: 'May', revenue: 38500000),
    MonthlyData(month: 'Jun', revenue: 42000000),
  ];

  static const List<ProductRank> bestSellers = [
    ProductRank(
      id: 1,
      name: 'Royal Canin Dog Food 2kg',
      category: 'Food',
      sales: 124,
      revenue: 18045000,
      icon: Icons.pets,
      trend: 12,
    ),
    ProductRank(
      id: 2,
      name: 'Whiskas Cat Food 1.2kg',
      category: 'Food',
      sales: 98,
      revenue: 6370000,
      icon: Icons.pets,
      trend: 8,
    ),
    ProductRank(
      id: 3,
      name: 'Kong Classic Dog Toy',
      category: 'Toys',
      sales: 87,
      revenue: 7743000,
      icon: Icons.sports_baseball,
      trend: -3,
    ),
    ProductRank(
      id: 4,
      name: 'Frontline Plus Antiparasitic',
      category: 'Medicine',
      sales: 65,
      revenue: 9425000,
      icon: Icons.medication_outlined,
      trend: 15,
    ),
    ProductRank(
      id: 5,
      name: 'Dog Shampoo Premium',
      category: 'Grooming',
      sales: 54,
      revenue: 2970000,
      icon: Icons.spa_outlined,
      trend: 5,
    ),
  ];

  static const List<RecentTransaction> recentTransactions = [
    RecentTransaction(
      id: 'TRX-0241',
      customer: 'Budi Santoso',
      items: 3,
      total: 285000,
      method: 'Cash',
      time: '10 min ago',
    ),
    RecentTransaction(
      id: 'TRX-0240',
      customer: 'Siti Rahayu',
      items: 2,
      total: 155000,
      method: 'QRIS',
      time: '28 min ago',
    ),
    RecentTransaction(
      id: 'TRX-0239',
      customer: 'Ahmad Fadli',
      items: 5,
      total: 520000,
      method: 'Card',
      time: '1h ago',
    ),
    RecentTransaction(
      id: 'TRX-0238',
      customer: 'Dewi Kusuma',
      items: 1,
      total: 89000,
      method: 'Cash',
      time: '2h ago',
    ),
    RecentTransaction(
      id: 'TRX-0237',
      customer: 'Rizki Pratama',
      items: 4,
      total: 375000,
      method: 'Transfer',
      time: '3h ago',
    ),
  ];

  static const List<LowStockItem> lowStockItems = [
    LowStockItem(
      id: 1,
      name: 'Cat Litter Silica Gel 5kg',
      stock: 3,
      min: 10,
      icon: Icons.pets,
      critical: true,
    ),
    LowStockItem(
      id: 2,
      name: 'Whiskas Tuna Cat Food',
      stock: 8,
      min: 15,
      icon: Icons.pets,
      critical: false,
    ),
    LowStockItem(
      id: 3,
      name: 'Aquarium Starter Kit 20L',
      stock: 5,
      min: 10,
      icon: Icons.water,
      critical: false,
    ),
    LowStockItem(
      id: 4,
      name: 'Bird Cage Medium',
      stock: 7,
      min: 10,
      icon: Icons.catching_pokemon,
      critical: false,
    ),
  ];

  final NumberFormat _currency = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  String formatRp(double n) => _currency.format(n);

  String formatRpFull(double n) => _currency.format(n);

  @override
  Widget build(BuildContext context) {
    final hour = DateTime.now().hour;
    final greeting = hour < 12
        ? 'Good Morning'
        : hour < 17
        ? 'Good Afternoon'
        : 'Good Evening';
    final today = DateFormat('EEEE, d MMMM yyyy').format(DateTime.now());

    return Container(
      color: _pageBg,
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(greeting, today),
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
              _buildMonthlyRevenueCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(String greeting, String today) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final actions = Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: _brown700,
                side: const BorderSide(color: Color(0x4DFFB570)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              child: const Text('Today'),
            ),
            _gradientButton(
              icon: Icons.add,
              label: 'New Transaction',
              onPressed: () {},
            ),
          ],
        );

        final title = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('$greeting!', style: _text(size: 24, weight: FontWeight.w900)),
            const SizedBox(height: 4),
            Text(
              "$today - Here's what's happening at Tomodachi Petshop",
              style: _text(size: 13, color: _brown400),
            ),
          ],
        );

        if (constraints.maxWidth < 640) {
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final columns = width >= 1100
            ? 4
            : width >= 680
            ? 2
            : 1;
        final cardWidth = (width - (16 * (columns - 1))) / columns;

        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            _buildStatCard(
              width: cardWidth,
              label: "Today's Sales",
              value: formatRp(1890000),
              sub: 'From 28 transactions',
              icon: Icons.attach_money,
              iconColor: _orangeDark,
              trend: 12,
              gradient: const [Color(0xFFFFF6E9), Color(0xFFFFE8CC)],
              iconBg: const Color(0x33FFB570),
            ),
            _buildStatCard(
              width: cardWidth,
              label: 'Total Transactions',
              value: '28',
              sub: '8 more than yesterday',
              icon: Icons.shopping_bag_outlined,
              iconColor: _pink,
              trend: 8,
              gradient: const [Color(0xFFFFF0F5), Color(0xFFFFE0EC)],
              iconBg: const Color(0x4DFFC7D1),
            ),
            _buildStatCard(
              width: cardWidth,
              label: 'Monthly Revenue',
              value: formatRp(42000000),
              sub: 'June 2024',
              icon: Icons.trending_up,
              iconColor: _green,
              trend: 15,
              gradient: const [Color(0xFFF0FDF9), Color(0xFFD4F5EE)],
              iconBg: const Color(0x80B8F2E6),
            ),
            _buildStatCard(
              width: cardWidth,
              label: 'Active Products',
              value: '48',
              sub: '4 need restocking',
              icon: Icons.inventory_2_outlined,
              iconColor: _blue,
              trend: -2,
              gradient: const [Color(0xFFF0FAFE), Color(0xFFD4EFFD)],
              iconBg: const Color(0x66A0E7E5),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatCard({
    required double width,
    required String label,
    required String value,
    required String sub,
    required IconData icon,
    required Color iconColor,
    required int trend,
    required List<Color> gradient,
    required Color iconBg,
  }) {
    final positive = trend >= 0;

    return Container(
      width: width,
      constraints: const BoxConstraints(minHeight: 150),
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
            right: -32,
            bottom: -32,
            child: Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.22),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          label,
                          style: _text(
                            size: 13,
                            weight: FontWeight.w700,
                            color: _brown700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          value,
                          style: _text(size: 24, weight: FontWeight.w900),
                        ),
                        const SizedBox(height: 4),
                        Text(sub, style: _text(size: 11, color: _brown400)),
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
                    child: Icon(icon, color: iconColor, size: 22),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: positive ? _successBg : _dangerBg,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Transform.rotate(
                          angle: positive ? 0 : 3.14159,
                          child: Icon(
                            Icons.arrow_outward,
                            size: 11,
                            color: positive
                                ? const Color(0xFF1B7A65)
                                : const Color(0xFFC0392B),
                          ),
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '${trend.abs()}%',
                          style: _text(
                            size: 11,
                            weight: FontWeight.w900,
                            color: positive
                                ? const Color(0xFF1B7A65)
                                : const Color(0xFFC0392B),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'vs last week',
                    style: _text(size: 11, color: _brown400),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
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
        if (constraints.maxWidth < 900) {
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

  Widget _buildSalesTrendCard() {
    final spots = salesData.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.sales);
    }).toList();

    return Container(
      height: 300,
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _cardHeader(
            title: 'Sales Trend',
            subtitle: 'Last 7 days',
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _rangeButton('7D', selected: true),
                const SizedBox(width: 6),
                _rangeButton('30D'),
                const SizedBox(width: 6),
                _rangeButton('3M'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: LineChart(
              LineChartData(
                minX: 0,
                maxX: (salesData.length - 1).toDouble(),
                minY: 0,
                maxY: 2400000,
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (_) => FlLine(
                    color: _orange.withValues(alpha: 0.15),
                    strokeWidth: 1,
                  ),
                ),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 28,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index < 0 || index >= salesData.length) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            salesData[index].day,
                            style: _text(size: 10, color: _brown400),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 46,
                      interval: 600000,
                      getTitlesWidget: (value, meta) => Text(
                        '${(value / 1000000).toStringAsFixed(1)}jt',
                        style: _text(size: 10, color: _brown400),
                      ),
                    ),
                  ),
                ),
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    tooltipBgColor: Colors.white,
                    tooltipRoundedRadius: 12,
                    getTooltipItems: (items) => items.map((item) {
                      final data = salesData[item.x.toInt()];
                      return LineTooltipItem(
                        '${data.day}\n${formatRpFull(data.sales)}\n${data.transactions} transactions',
                        _text(size: 11, weight: FontWeight.w800),
                      );
                    }).toList(),
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    barWidth: 2.5,
                    color: _orange,
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          _orange.withValues(alpha: 0.30),
                          _orange.withValues(alpha: 0.02),
                        ],
                      ),
                    ),
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, bar, index) {
                        return FlDotCirclePainter(
                          radius: 4,
                          color: _orange,
                          strokeWidth: 2,
                          strokeColor: Colors.white,
                        );
                      },
                    ),
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
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _cardHeader(
            title: 'Best Sellers',
            subtitle: 'This month',
            trailing: const Icon(Icons.star, size: 18, color: _orange),
          ),
          const SizedBox(height: 16),
          ...bestSellers.asMap().entries.map((entry) {
            final index = entry.key;
            final product = entry.value;
            final rankColor = index == 0
                ? _orange
                : index == 1
                ? const Color(0xFFFFC7D1)
                : const Color(0xFFF5E8D5);
            final rankTextColor = index == 0
                ? Colors.white
                : index == 1
                ? const Color(0xFF8B2F47)
                : _brown400;

            return Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Row(
                children: [
                  Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      color: rankColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${index + 1}',
                      style: _text(
                        size: 12,
                        weight: FontWeight.w900,
                        color: rankTextColor,
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
                  const SizedBox(width: 10),
                  Icon(product.icon, color: _orangeDark, size: 22),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: _text(size: 12, weight: FontWeight.w800),
                        ),
                        Text(
                          '${product.sales} sold - ${formatRp(product.revenue)}',
                          style: _text(size: 10, color: _brown400),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${product.trend >= 0 ? '+' : ''}${product.trend}%',
                    style: _text(
                      size: 11,
                      weight: FontWeight.w900,
                      color: product.trend >= 0
                          ? const Color(0xFF1B7A65)
                          : const Color(0xFFC0392B),
                    ),
                  ),
                ],
              ),
            );
          }),
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
            child: _cardHeader(
              title: 'Recent Transactions',
              subtitle: "Today's activity",
              trailing: TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.arrow_outward, size: 13),
                label: const Text('View all'),
                style: TextButton.styleFrom(
                  foregroundColor: _orange,
                  textStyle: _text(size: 12, weight: FontWeight.w900),
                ),
              ),
            ),
          ),
          const Divider(height: 1, color: Color(0x1FFFB570)),
          ...recentTransactions.map((transaction) {
            return Column(
              children: [
                Padding(
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
                          color: _orange,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              transaction.customer,
                              overflow: TextOverflow.ellipsis,
                              style: _text(size: 14, weight: FontWeight.w800),
                            ),
                            Text(
                              '${transaction.id} - ${transaction.items} items - ${transaction.method}',
                              overflow: TextOverflow.ellipsis,
                              style: _text(size: 11, color: _brown400),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            formatRpFull(transaction.total),
                            style: _text(size: 13, weight: FontWeight.w900),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.access_time,
                                size: 9,
                                color: _brown400,
                              ),
                              const SizedBox(width: 3),
                              Text(
                                transaction.time,
                                style: _text(size: 10, color: _brown400),
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
                          color: _successBg,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                ),
                if (transaction != recentTransactions.last)
                  const Divider(height: 1, color: Color(0x11FFB570)),
              ],
            );
          }),
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
            child: _cardHeader(
              title: 'Low Stock Alert',
              subtitle: '${lowStockItems.length} items need restocking',
              trailing: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF0E0),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.warning_amber_rounded,
                  size: 16,
                  color: _orange,
                ),
              ),
            ),
          ),
          const Divider(height: 1, color: Color(0x1FFFB570)),
          ...lowStockItems.map((item) {
            final progress = (item.stock / item.min).clamp(0.0, 1.0);
            final alertColor = item.critical
                ? const Color(0xFFFF6B6B)
                : _orange;

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      Icon(item.icon, color: _orangeDark, size: 24),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: _text(size: 12, weight: FontWeight.w800),
                            ),
                            const SizedBox(height: 7),
                            Row(
                              children: [
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(999),
                                    child: LinearProgressIndicator(
                                      value: progress,
                                      minHeight: 6,
                                      backgroundColor: const Color(0xFFF5E8D5),
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        alertColor,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '${item.stock} left',
                                  style: _text(
                                    size: 10,
                                    weight: FontWeight.w900,
                                    color: alertColor,
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
                            color: _dangerBg,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            'CRITICAL',
                            style: _text(
                              size: 9,
                              weight: FontWeight.w900,
                              color: const Color(0xFFC0392B),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (item != lowStockItems.last)
                  const Divider(height: 1, color: Color(0x11FFB570)),
              ],
            );
          }),
          const Divider(height: 1, color: Color(0x1FFFB570)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: SizedBox(
              width: double.infinity,
              child: _gradientButton(
                label: 'Restock All',
                dense: true,
                onPressed: () {},
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlyRevenueCard() {
    return Container(
      height: 280,
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _cardHeader(
            title: 'Monthly Revenue Overview',
            subtitle: 'January - June 2024',
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _successBg.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.trending_up,
                    size: 13,
                    color: Color(0xFF1B7A65),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    '+18.5% YoY',
                    style: _text(
                      size: 11,
                      weight: FontWeight.w900,
                      color: const Color(0xFF1B7A65),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 22),
          Expanded(
            child: BarChart(
              BarChartData(
                maxY: 50000000,
                alignment: BarChartAlignment.spaceAround,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    tooltipBgColor: Colors.white,
                    tooltipRoundedRadius: 12,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final item = monthlyData[group.x.toInt()];
                      return BarTooltipItem(
                        '${item.month}\n${formatRpFull(item.revenue)}',
                        _text(size: 11, weight: FontWeight.w800),
                      );
                    },
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (_) => FlLine(
                    color: _orange.withValues(alpha: 0.12),
                    strokeWidth: 1,
                  ),
                ),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 26,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index < 0 || index >= monthlyData.length) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            monthlyData[index].month,
                            style: _text(size: 11, color: _brown400),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      interval: 10000000,
                      getTitlesWidget: (value, meta) => Text(
                        '${(value / 1000000).toStringAsFixed(0)}jt',
                        style: _text(size: 10, color: _brown400),
                      ),
                    ),
                  ),
                ),
                barGroups: monthlyData.asMap().entries.map((entry) {
                  final isCurrent = entry.key == monthlyData.length - 1;
                  return BarChartGroupData(
                    x: entry.key,
                    barRods: [
                      BarChartRodData(
                        toY: entry.value.revenue,
                        width: 36,
                        color: isCurrent
                            ? _orangeDark
                            : const Color(0xFFFFD4A8),
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

  Widget _cardHeader({
    required String title,
    required String subtitle,
    Widget? trailing,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: _text(size: 16, weight: FontWeight.w900)),
              const SizedBox(height: 2),
              Text(subtitle, style: _text(size: 11, color: _brown400)),
            ],
          ),
        ),
        if (trailing != null) ...[const SizedBox(width: 12), trailing],
      ],
    );
  }

  Widget _rangeButton(String label, {bool selected = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: selected ? _orange : const Color(0xFFFFF0E0),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: _text(
          size: 11,
          weight: FontWeight.w900,
          color: selected ? Colors.white : _brown400,
        ),
      ),
    );
  }

  Widget _gradientButton({
    required String label,
    required VoidCallback onPressed,
    IconData? icon,
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
            gradient: const LinearGradient(colors: [_orange, _orangeDark]),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFF9650).withValues(alpha: 0.3),
                blurRadius: 14,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 16, color: Colors.white),
                const SizedBox(width: 6),
              ],
              Text(
                label,
                style: _text(
                  size: dense ? 12 : 13,
                  weight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: _orange.withValues(alpha: 0.12)),
      boxShadow: [
        BoxShadow(
          color: _orangeDark.withValues(alpha: 0.08),
          blurRadius: 16,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  static TextStyle _text({
    required double size,
    FontWeight weight = FontWeight.w500,
    Color color = _brown900,
  }) {
    return TextStyle(
      fontSize: size,
      fontWeight: weight,
      color: color,
      letterSpacing: 0,
    );
  }
}
