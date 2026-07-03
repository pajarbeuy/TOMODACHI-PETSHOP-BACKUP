import 'dart:async';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../dashboard_service.dart';
import '../../report_exporter.dart';

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

enum _SalesTrendRange { sevenDays, thirtyDays, threeMonths }

class _SalesTrendPoint {
  final DateTime date;
  final double sales;
  final int transactions;

  const _SalesTrendPoint({
    required this.date,
    required this.sales,
    required this.transactions,
  });
}

class DashboardTab extends StatefulWidget {
  final DashboardService? dashboardService;

  const DashboardTab({super.key, this.dashboardService});

  @override
  State<DashboardTab> createState() => _DashboardTabState();
}

class _DashboardTabState extends State<DashboardTab> {
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

  final NumberFormat _currency = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  List<RecentTransaction> _liveRecentTransactions = [];
  bool _recentTransactionsLoading = false;
  Map<String, dynamic>? _analyticsData;
  bool _analyticsLoading = false;
  Timer? _recentTransactionsTimer;
  _SalesTrendRange _selectedSalesRange = _SalesTrendRange.sevenDays;

  @override
  void initState() {
    super.initState();
    _fetchAnalytics();
    _fetchRecentTransactions();
    _recentTransactionsTimer = Timer.periodic(const Duration(seconds: 15), (_) {
      _fetchAnalytics(silent: true, trendDays: _selectedSalesTrendDays);
      _fetchRecentTransactions(silent: true);
    });
  }

  @override
  void dispose() {
    _recentTransactionsTimer?.cancel();
    super.dispose();
  }

  Future<void> _fetchRecentTransactions({bool silent = false}) async {
    final service = widget.dashboardService;
    if (service == null) return;

    if (!silent && mounted) {
      setState(() => _recentTransactionsLoading = true);
    }

    try {
      final res = await service.getRecentTransactions(limit: 5);
      final data = res['data'];
      final rows = data is List
          ? data
          : data is Map && data['data'] is List
          ? data['data'] as List
          : const [];

      final transactions = rows
          .whereType<Map>()
          .map((row) => _recentTransactionFromJson(row))
          .toList();

      if (!mounted) return;
      setState(() {
        if (transactions.isNotEmpty) {
          _liveRecentTransactions = transactions;
        }
        _recentTransactionsLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _recentTransactionsLoading = false);
      if (!silent) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal memuat transaksi terbaru')),
        );
      }
    }
  }

  Future<void> _fetchAnalytics({bool silent = false, int? trendDays}) async {
    final service = widget.dashboardService;
    if (service == null) return;

    final days = trendDays ?? _selectedSalesTrendDays;

    if (!silent && mounted) {
      setState(() => _analyticsLoading = true);
    }

    try {
      final res = await service.getAnalytics(trendDays: days);
      final data = res['data'];

      if (!mounted) return;
      setState(() {
        if (data is Map<String, dynamic>) {
          _analyticsData = data;
        } else if (data is Map) {
          _analyticsData = Map<String, dynamic>.from(data);
        }
        _analyticsLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _analyticsLoading = false);
      if (!silent) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal memuat data dashboard')),
        );
      }
    }
  }

  Map<String, dynamic> _mapValue(Object? value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    return const {};
  }

  double _doubleValue(Object? value, [double fallback = 0]) {
    if (value is num) return value.toDouble();
    return double.tryParse('$value') ?? fallback;
  }

  int _intValue(Object? value, [int fallback = 0]) {
    if (value is int) return value;
    if (value is num) return value.round();
    return int.tryParse('$value') ?? fallback;
  }

  String _formatSignedPercent(double value) {
    final prefix = value > 0 ? '+' : '';
    return '$prefix${value.toStringAsFixed(value.truncateToDouble() == value ? 0 : 1)}%';
  }

  RecentTransaction _recentTransactionFromJson(Map<dynamic, dynamic> row) {
    final code = (row['transaction_code'] ?? row['transaction_id'] ?? '-')
        .toString();
    final cashier = row['cashier'];
    final cashierName = cashier is Map
        ? (cashier['name'] ?? '').toString()
        : (row['kasir_name'] ?? row['cashier_name'] ?? '').toString();
    final customer = cashierName.isNotEmpty ? cashierName : 'Transaksi Kasir';
    final items = row['items'];
    final itemCount = items is List
        ? items.fold<int>(0, (sum, item) {
            if (item is! Map) return sum;
            return sum + (int.tryParse('${item['quantity'] ?? 0}') ?? 0);
          })
        : int.tryParse('${row['items_count'] ?? row['total_items'] ?? 0}') ?? 0;
    final total =
        double.tryParse('${row['total'] ?? row['grand_total'] ?? 0}') ?? 0;
    final method = (row['payment_method'] ?? row['channel'] ?? '-')
        .toString()
        .toUpperCase();
    final createdAt = DateTime.tryParse('${row['created_at'] ?? ''}');

    return RecentTransaction(
      id: code,
      customer: customer,
      items: itemCount,
      total: total,
      method: method,
      time: _formatRelativeTime(createdAt),
    );
  }

  String _formatRelativeTime(DateTime? value) {
    if (value == null) return '-';
    final now = DateTime.now();
    final local = value.toLocal();
    final diff = now.difference(local);

    if (diff.inMinutes < 1) return 'baru saja';
    if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return DateFormat('d MMM').format(local);
  }

  String formatRp(double n) => _currency.format(n);

  String formatRpFull(double n) => _currency.format(n);

  String get _exportDateStamp {
    final now = DateTime.now();
    String two(int value) => value.toString().padLeft(2, '0');
    return '${now.year}${two(now.month)}${two(now.day)}-${two(now.hour)}${two(now.minute)}';
  }

  String _escapeHtml(Object? value) {
    return value
        .toString()
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;')
        .replaceAll("'", '&#39;');
  }

  void _showExportOptions() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Export Laporan Penjualan',
                  style: _text(size: 18, weight: FontWeight.w900),
                ),
                const SizedBox(height: 6),
                Text(
                  'Data diambil dari dashboard analitik terbaru.',
                  style: _text(size: 13, color: _brown400),
                ),
                const SizedBox(height: 16),
                _exportOptionTile(
                  icon: Icons.picture_as_pdf_rounded,
                  title: 'Export PDF',
                  subtitle: 'Buka laporan siap print / Save as PDF',
                  color: const Color(0xFFE85D5D),
                  onTap: () {
                    Navigator.pop(context);
                    unawaited(_exportSalesReportPdf());
                  },
                ),
                const SizedBox(height: 10),
                _exportOptionTile(
                  icon: Icons.table_chart_rounded,
                  title: 'Export Excel',
                  subtitle: 'Download file .xls untuk Excel atau Sheets',
                  color: _green,
                  onTap: () {
                    Navigator.pop(context);
                    unawaited(_exportSalesReportExcel());
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _exportOptionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.25)),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.16),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: _text(size: 14, weight: FontWeight.w800)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: _text(size: 12, color: _brown400)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: _brown400),
          ],
        ),
      ),
    );
  }

  Future<void> _refreshReportDataForExport() async {
    await _fetchAnalytics(silent: true, trendDays: _selectedSalesTrendDays);
    await _fetchRecentTransactions(silent: true);
  }

  Future<void> _exportSalesReportPdf() async {
    await _refreshReportDataForExport();
    if (!mounted) return;

    final opened = openPrintableReport(
      title: 'Laporan Penjualan Tomodachi',
      htmlContent: _buildPrintableReportHtml(),
    );

    _showExportSnack(
      opened
          ? 'Laporan PDF dibuka. Pilih "Save as PDF" di dialog print.'
          : 'Export PDF hanya tersedia di Flutter Web untuk saat ini.',
    );
  }

  Future<void> _exportSalesReportExcel() async {
    await _refreshReportDataForExport();
    if (!mounted) return;

    final downloaded = downloadReportFile(
      fileName: 'laporan-penjualan-tomodachi-$_exportDateStamp.xls',
      mimeType: 'application/vnd.ms-excel;charset=utf-8',
      content: _buildExcelReportHtml(),
    );

    _showExportSnack(
      downloaded
          ? 'File Excel laporan penjualan berhasil dibuat.'
          : 'Export Excel hanya tersedia di Flutter Web untuk saat ini.',
    );
  }

  void _showExportSnack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: _brown900,
      ),
    );
  }

  String _buildPrintableReportHtml() {
    final body = _buildReportTablesHtml();
    return '''
<!doctype html>
<html>
<head>
  <meta charset="utf-8">
  <title>Laporan Penjualan Tomodachi</title>
  <style>
    @page { size: A4; margin: 18mm; }
    body { font-family: Arial, sans-serif; color: #3D2314; margin: 0; }
    h1 { margin: 0 0 4px; font-size: 24px; }
    h2 { margin: 22px 0 8px; font-size: 15px; color: #5A3D2B; }
    .meta { color: #9B7B6B; font-size: 12px; margin-bottom: 18px; }
    .summary { display: grid; grid-template-columns: repeat(4, 1fr); gap: 10px; margin: 18px 0; }
    .card { border: 1px solid #FFD4A8; border-radius: 10px; padding: 12px; background: #FFF8F2; }
    .label { color: #9B7B6B; font-size: 11px; }
    .value { font-weight: 800; font-size: 16px; margin-top: 4px; }
    table { width: 100%; border-collapse: collapse; font-size: 11px; }
    th { background: #3D2314; color: white; text-align: left; padding: 8px; }
    td { border-bottom: 1px solid #F3DEC8; padding: 7px 8px; }
    tr:nth-child(even) td { background: #FFF8F2; }
  </style>
</head>
<body>
  <h1>Laporan Penjualan Tomodachi Pet Shop</h1>
  <div class="meta">Sumber: Dashboard Analitik real-time - Dibuat: ${_escapeHtml(DateFormat('d MMM yyyy HH:mm').format(DateTime.now()))}</div>
  $body
  <script>window.onload = function(){ setTimeout(function(){ window.print(); }, 300); };</script>
</body>
</html>
''';
  }

  String _buildExcelReportHtml() {
    return '''
<html>
<head>
  <meta charset="utf-8">
  <style>
    table { border-collapse: collapse; }
    th, td { border: 1px solid #c9b49d; padding: 6px; }
    th { background: #3D2314; color: #ffffff; }
    .title { font-size: 20px; font-weight: bold; }
  </style>
</head>
<body>
  <div class="title">Laporan Penjualan Tomodachi Pet Shop</div>
  <div>Sumber: Dashboard Analitik real-time</div>
  <div>Dibuat: ${_escapeHtml(DateFormat('d MMM yyyy HH:mm').format(DateTime.now()))}</div>
  ${_buildReportTablesHtml()}
</body>
</html>
''';
  }

  String _buildReportTablesHtml() {
    final kpi = _mapValue(_analyticsData?['kpi']);
    final todaySales = _doubleValue(kpi['today_sales'], 0);
    final todayTransactions = _intValue(kpi['total_transactions_today'], 0);
    final monthlyRevenue = _doubleValue(kpi['monthly_revenue'], 0);
    final avgTransaction = _doubleValue(kpi['average_transaction_value'], 0);
    final trendRows = _buildSalesTrendPoints().map((item) {
      return '<tr><td>${_escapeHtml(DateFormat('yyyy-MM-dd').format(item.date))}</td><td>${item.transactions}</td><td>${item.sales}</td><td>${_escapeHtml(formatRpFull(item.sales))}</td></tr>';
    }).join();
    final monthlyRows = _monthlyRevenueItems().map((item) {
      return '<tr><td>${_escapeHtml(item.month)}</td><td>${item.revenue}</td><td>${_escapeHtml(formatRpFull(item.revenue))}</td></tr>';
    }).join();
    final productRows = _bestSellerItems().asMap().entries.map((entry) {
      final item = entry.value;
      return '<tr><td>${entry.key + 1}</td><td>${_escapeHtml(item.name)}</td><td>${_escapeHtml(item.category)}</td><td>${item.sales}</td><td>${item.revenue}</td><td>${_escapeHtml(formatRpFull(item.revenue))}</td></tr>';
    }).join();
    final transactionRows = _liveRecentTransactions.map((item) {
      return '<tr><td>${_escapeHtml(item.id)}</td><td>${_escapeHtml(item.customer)}</td><td>${item.items}</td><td>${_escapeHtml(item.method)}</td><td>${item.total}</td><td>${_escapeHtml(formatRpFull(item.total))}</td><td>${_escapeHtml(item.time)}</td></tr>';
    }).join();

    return '''
  <div class="summary">
    <div class="card"><div class="label">Penjualan Hari Ini</div><div class="value">${_escapeHtml(formatRpFull(todaySales))}</div></div>
    <div class="card"><div class="label">Transaksi Hari Ini</div><div class="value">${_escapeHtml(todayTransactions)}</div></div>
    <div class="card"><div class="label">Pendapatan Bulan Ini</div><div class="value">${_escapeHtml(formatRpFull(monthlyRevenue))}</div></div>
    <div class="card"><div class="label">Rata-rata Transaksi</div><div class="value">${_escapeHtml(formatRpFull(avgTransaction))}</div></div>
  </div>

  <h2>Tren Penjualan</h2>
  <table>
    <thead><tr><th>Tanggal</th><th>Transaksi</th><th>Revenue Raw</th><th>Revenue</th></tr></thead>
    <tbody>$trendRows</tbody>
  </table>

  <h2>Pendapatan Bulanan</h2>
  <table>
    <thead><tr><th>Bulan</th><th>Revenue Raw</th><th>Revenue</th></tr></thead>
    <tbody>$monthlyRows</tbody>
  </table>

  <h2>Produk Terlaris</h2>
  <table>
    <thead><tr><th>Rank</th><th>Produk</th><th>Kategori</th><th>Unit Terjual</th><th>Revenue Raw</th><th>Revenue</th></tr></thead>
    <tbody>$productRows</tbody>
  </table>

  <h2>Transaksi Terbaru</h2>
  <table>
    <thead><tr><th>ID</th><th>Kasir</th><th>Item</th><th>Metode</th><th>Total Raw</th><th>Total</th><th>Waktu</th></tr></thead>
    <tbody>$transactionRows</tbody>
  </table>
''';
  }

  int get _selectedSalesTrendDays {
    final today = DateTime.now();
    final startOfToday = DateTime(today.year, today.month, today.day);

    return switch (_selectedSalesRange) {
      _SalesTrendRange.sevenDays => 7,
      _SalesTrendRange.thirtyDays => 30,
      _SalesTrendRange.threeMonths =>
        startOfToday
                .difference(DateTime(today.year, today.month - 3, today.day))
                .inDays +
            1,
    };
  }

  String get _selectedSalesTrendSubtitle {
    return switch (_selectedSalesRange) {
      _SalesTrendRange.sevenDays => 'Last 7 days',
      _SalesTrendRange.thirtyDays => 'Last 30 days',
      _SalesTrendRange.threeMonths => 'Last 3 months',
    };
  }

  List<_SalesTrendPoint> _buildSalesTrendPoints() {
    // Prioritaskan data real dari API
    final trend = _analyticsData?['sales_trend'];
    if (trend is List && trend.isNotEmpty) {
      return trend.whereType<Map>().map((row) {
        final date =
            DateTime.tryParse('${row['date'] ?? ''}') ?? DateTime.now();
        return _SalesTrendPoint(
          date: date,
          sales: _doubleValue(row['revenue'], 0),
          transactions: _intValue(row['transactions'], 0),
        );
      }).toList();
    }

    return [];
  }

  /// Best Sellers — dari API (top_products), fallback ke dummy saat loading
  List<ProductRank> _bestSellerItems() {
    final rows = _analyticsData?['top_products'];
    if (rows is! List || rows.isEmpty) {
      return [];
    }
    return rows.whereType<Map>().toList().asMap().entries.map((entry) {
      final row = entry.value;
      return ProductRank(
        id: _intValue(row['product_id'], entry.key + 1),
        name: (row['product_name'] ?? '-').toString(),
        category: (row['category'] ?? '-').toString(),
        sales: _intValue(row['quantity_sold'], 0),
        revenue: _doubleValue(row['total_revenue'], 0),
        icon: Icons.pets,
        trend: 0,
      );
    }).toList();
  }

  /// Low Stock Alert — dari API (low_stock_alerts), fallback ke dummy saat loading
  List<LowStockItem> _lowStockItems() {
    final rows = _analyticsData?['low_stock_alerts'];
    if (rows is! List || rows.isEmpty) {
      return [];
    }
    return rows.whereType<Map>().map((row) {
      final stock = _intValue(row['stock'], 0);
      final threshold = _intValue(row['threshold'], 10);
      return LowStockItem(
        id: _intValue(row['product_id'], 0),
        name: (row['product_name'] ?? '-').toString(),
        stock: stock,
        min: threshold <= 0 ? 1 : threshold,
        icon: Icons.inventory_2_outlined,
        critical: row['critical'] == true,
      );
    }).toList();
  }

  /// Monthly Revenue — dari API (monthly_revenue), fallback ke dummy saat loading
  List<MonthlyData> _monthlyRevenueItems() {
    final rows = _analyticsData?['monthly_revenue'];
    if (rows is! List || rows.isEmpty) {
      return [];
    }
    return rows.whereType<Map>().map((row) {
      return MonthlyData(
        month: (row['month'] ?? '-').toString(),
        revenue: _doubleValue(row['total_revenue'], 0),
      );
    }).toList();
  }

  String _formatTrendDate(DateTime date) {
    return DateFormat('d MMM').format(date);
  }

  bool _showTrendDateLabel(int index, int total) {
    if (total <= 7) return true;

    final labelIndexes = total <= 30
        ? <int>{0, total ~/ 3, (total * 2) ~/ 3, total - 1}
        : <int>{0, total ~/ 4, total ~/ 2, (total * 3) ~/ 4, total - 1};

    return labelIndexes.contains(index);
  }

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
              const SizedBox(height: 16),
              _buildSalesReportCard(),
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
              onPressed: _analyticsLoading
                  ? null
                  : () {
                      _fetchAnalytics(trendDays: _selectedSalesTrendDays);
                      _fetchRecentTransactions();
                    },
              style: OutlinedButton.styleFrom(
                backgroundColor: _orange,
                foregroundColor: Colors.white,
                side: const BorderSide(color: _orange),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              child: Text(
                _analyticsLoading ? 'Syncing...' : 'Today',
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
            OutlinedButton.icon(
              onPressed: _showExportOptions,
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: _brown900,
                side: BorderSide(color: _orange.withValues(alpha: 0.35)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
              ),
              icon: const Icon(Icons.download_rounded, size: 18),
              label: const Text(
                'Export',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
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

  Widget _buildSalesReportCard() {
    final kpi = _mapValue(_analyticsData?['kpi']);
    final todaySales = _doubleValue(kpi['today_sales'], 0);
    final todayTransactions = _intValue(kpi['total_transactions_today'], 0);
    final todayItemsSold = _intValue(kpi['items_sold_today'], 0);
    final avgTransaction = _doubleValue(kpi['average_transaction_value'], 0);
    final lastSynced = DateFormat('HH:mm:ss').format(DateTime.now());

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _cardHeader(
            title: 'Laporan Penjualan',
            subtitle: _analyticsLoading
                ? 'Memuat data real-time...'
                : 'Real-time - diperbarui otomatis tiap 15 detik',
            trailing: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _smallActionButton(
                  icon: Icons.refresh_rounded,
                  label: 'Refresh',
                  onPressed: _analyticsLoading
                      ? null
                      : () {
                          _fetchAnalytics(trendDays: _selectedSalesTrendDays);
                          _fetchRecentTransactions();
                        },
                ),
                _smallActionButton(
                  icon: Icons.picture_as_pdf_rounded,
                  label: 'PDF',
                  onPressed: () => unawaited(_exportSalesReportPdf()),
                ),
                _smallActionButton(
                  icon: Icons.table_chart_rounded,
                  label: 'Excel',
                  onPressed: () => unawaited(_exportSalesReportExcel()),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              final columns = constraints.maxWidth >= 900
                  ? 4
                  : constraints.maxWidth >= 560
                  ? 2
                  : 1;
              final itemWidth =
                  (constraints.maxWidth - (12 * (columns - 1))) / columns;
              final items = [
                ('Penjualan Hari Ini', formatRpFull(todaySales)),
                ('Transaksi Hari Ini', '$todayTransactions transaksi'),
                ('Item Terjual Hari Ini', '$todayItemsSold item'),
                ('Rata-rata Transaksi', formatRpFull(avgTransaction)),
              ];

              return Wrap(
                spacing: 12,
                runSpacing: 12,
                children: items.map((item) {
                  return Container(
                    width: itemWidth,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF8F2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0x1FFFB570)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.$1, style: _text(size: 11, color: _brown400)),
                        const SizedBox(height: 6),
                        Text(
                          _analyticsLoading ? 'Memuat...' : item.$2,
                          style: _text(size: 15, weight: FontWeight.w900),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              );
            },
          ),
          const SizedBox(height: 12),
          Text(
            'Sinkron terakhir: $lastSynced - export memakai data dashboard yang sedang tampil.',
            style: _text(size: 11, color: _brown400),
          ),
        ],
      ),
    );
  }

  Widget _buildStats(BuildContext context) {
    final kpi = _mapValue(_analyticsData?['kpi']);
    final todaySales = _doubleValue(kpi['today_sales'], 0);
    final todayTransactions = _intValue(kpi['total_transactions_today'], 0);
    final transactionsChange = _intValue(kpi['transactions_change'], 0);
    final monthlyRevenue = _doubleValue(kpi['monthly_revenue'], 0);
    final activeProducts = _intValue(kpi['active_products'], 0);
    final lowStockProducts = _intValue(kpi['low_stock_products'], 0);
    final todaySalesTrend = _doubleValue(kpi['today_sales_change_percent'], 0);
    final monthlyRevenueTrend = _doubleValue(
      kpi['monthly_revenue_change_percent'],
      0,
    );
    final monthLabel = DateFormat('MMMM yyyy').format(DateTime.now());

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
              value: _analyticsLoading ? 'Memuat...' : formatRp(todaySales),
              sub: 'From $todayTransactions transactions',
              icon: Icons.attach_money,
              iconColor: _orangeDark,
              trend: todaySalesTrend.round(),
              gradient: const [Color(0xFFFFF6E9), Color(0xFFFFE8CC)],
              iconBg: const Color(0x33FFB570),
            ),
            _buildStatCard(
              width: cardWidth,
              label: 'Total Transactions',
              value: _analyticsLoading ? '...' : '$todayTransactions',
              sub: transactionsChange == 0
                  ? 'Same as yesterday'
                  : '${transactionsChange.abs()} ${transactionsChange > 0 ? 'more' : 'less'} than yesterday',
              icon: Icons.shopping_bag_outlined,
              iconColor: _pink,
              trend: transactionsChange,
              gradient: const [Color(0xFFFFF0F5), Color(0xFFFFE0EC)],
              iconBg: const Color(0x4DFFC7D1),
            ),
            _buildStatCard(
              width: cardWidth,
              label: 'Monthly Revenue',
              value: _analyticsLoading ? 'Memuat...' : formatRp(monthlyRevenue),
              sub: '$monthLabel (${_formatSignedPercent(monthlyRevenueTrend)})',
              icon: Icons.trending_up,
              iconColor: _green,
              trend: monthlyRevenueTrend.round(),
              gradient: const [Color(0xFFF0FDF9), Color(0xFFD4F5EE)],
              iconBg: const Color(0x80B8F2E6),
            ),
            _buildStatCard(
              width: cardWidth,
              label: 'Active Products',
              value: _analyticsLoading ? '...' : '$activeProducts',
              sub: '$lowStockProducts need restocking',
              icon: Icons.inventory_2_outlined,
              iconColor: _blue,
              trend: -lowStockProducts,
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
    final trendPoints = _buildSalesTrendPoints();
    final maxSales = trendPoints
        .map((item) => item.sales)
        .reduce((value, item) => value > item ? value : item);
    final maxY = (maxSales * 1.2).clamp(1000000.0, double.infinity);
    final leftInterval = maxY / 4;
    final spots = trendPoints.asMap().entries.map((entry) {
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
            subtitle: _selectedSalesTrendSubtitle,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _rangeButton(
                  '7D',
                  selected: _selectedSalesRange == _SalesTrendRange.sevenDays,
                  onPressed: () {
                    if (_selectedSalesRange == _SalesTrendRange.sevenDays) {
                      return;
                    }
                    setState(
                      () => _selectedSalesRange = _SalesTrendRange.sevenDays,
                    );
                    _fetchAnalytics(trendDays: 7);
                  },
                ),
                const SizedBox(width: 6),
                _rangeButton(
                  '30D',
                  selected: _selectedSalesRange == _SalesTrendRange.thirtyDays,
                  onPressed: () {
                    if (_selectedSalesRange == _SalesTrendRange.thirtyDays) {
                      return;
                    }
                    setState(
                      () => _selectedSalesRange = _SalesTrendRange.thirtyDays,
                    );
                    _fetchAnalytics(trendDays: 30);
                  },
                ),
                const SizedBox(width: 6),
                _rangeButton(
                  '3M',
                  selected: _selectedSalesRange == _SalesTrendRange.threeMonths,
                  onPressed: () {
                    if (_selectedSalesRange == _SalesTrendRange.threeMonths) {
                      return;
                    }
                    setState(
                      () => _selectedSalesRange = _SalesTrendRange.threeMonths,
                    );
                    _fetchAnalytics(trendDays: 90);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: LineChart(
              LineChartData(
                minX: 0,
                maxX: (trendPoints.length - 1).toDouble(),
                minY: 0,
                maxY: maxY,
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
                        if (index < 0 ||
                            index >= trendPoints.length ||
                            !_showTrendDateLabel(index, trendPoints.length)) {
                          return const SizedBox.shrink();
                        }
                        return SideTitleWidget(
                          axisSide: meta.axisSide,
                          space: 8,
                          child: SizedBox(
                            width: 44,
                            child: Text(
                              _formatTrendDate(trendPoints[index].date),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.visible,
                              style: _text(size: 10, color: _brown400),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 46,
                      interval: leftInterval,
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
                      final data = trendPoints[item.x.toInt()];
                      return LineTooltipItem(
                        '${_formatTrendDate(data.date)}\n${formatRpFull(data.sales)}\n${data.transactions} transactions',
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
                      checkToShowDot: (spot, barData) {
                        final index = spot.x.toInt();
                        return trendPoints.length <= 30 ||
                            _showTrendDateLabel(index, trendPoints.length);
                      },
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
    final products = _bestSellerItems();
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _cardHeader(
            title: 'Best Sellers',
            subtitle: _analyticsLoading
                ? 'Memuat data...'
                : 'Berdasarkan transaksi',
            trailing: const Icon(Icons.star, size: 18, color: _orange),
          ),
          const SizedBox(height: 16),
          if (products.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                _analyticsLoading ? 'Memuat...' : 'Belum ada produk terjual.',
                style: _text(size: 12, color: _brown400),
              ),
            ),
          ...products.asMap().entries.map((entry) {
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
    final transactions = _liveRecentTransactions;

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
              subtitle: _recentTransactionsLoading
                  ? 'Memuat aktivitas terbaru...'
                  : "Today's activity",
              trailing: IconButton(
                tooltip: 'Refresh',
                onPressed: _recentTransactionsLoading
                    ? null
                    : () => _fetchRecentTransactions(),
                icon: const Icon(Icons.refresh_rounded, size: 18),
                color: _orange,
              ),
            ),
          ),
          const Divider(height: 1, color: Color(0x1FFFB570)),
          ...transactions.map((transaction) {
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
                if (transaction != transactions.last)
                  const Divider(height: 1, color: Color(0x11FFB570)),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildLowStockCard() {
    final items = _lowStockItems();
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
              subtitle: _analyticsLoading
                  ? 'Memuat stok...'
                  : '${items.length} produk stok <= min stok',
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
          if (items.isEmpty)
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                _analyticsLoading
                    ? 'Memuat...'
                    : 'Tidak ada produk stok rendah.',
                style: _text(size: 12, color: _brown400),
              ),
            ),
          ...items.map((item) {
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
                if (item != items.last)
                  const Divider(height: 1, color: Color(0x11FFB570)),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildMonthlyRevenueCard() {
    final chartData = _monthlyRevenueItems();
    final maxRevenue = chartData.isEmpty
        ? 50000000.0
        : chartData.map((d) => d.revenue).reduce((a, b) => a > b ? a : b);
    final maxY = (maxRevenue * 1.25).clamp(1000000.0, double.infinity);
    final interval = (maxY / 5).ceilToDouble();
    final currentYear = DateTime.now().year;

    return Container(
      height: 300,
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _cardHeader(
            title: 'Monthly Revenue Overview',
            subtitle: _analyticsLoading
                ? 'Memuat data...'
                : '12 bulan terakhir',
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
                    Icons.calendar_month,
                    size: 13,
                    color: Color(0xFF1B7A65),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    '$currentYear',
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
          const SizedBox(height: 16),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final availableWidth = constraints.maxWidth - 40;
                final count = chartData.isEmpty ? 12 : chartData.length;
                final barW = ((availableWidth / count) * 0.55).clamp(6.0, 22.0);
                final showEvery = availableWidth < 300
                    ? 3
                    : availableWidth < 450
                    ? 2
                    : 1;

                return BarChart(
                  BarChartData(
                    maxY: maxY,
                    alignment: BarChartAlignment.spaceAround,
                    barTouchData: BarTouchData(
                      enabled: true,
                      touchTooltipData: BarTouchTooltipData(
                        tooltipBgColor: Colors.white,
                        tooltipRoundedRadius: 12,
                        getTooltipItem: (group, groupIndex, rod, rodIndex) {
                          if (group.x.toInt() >= chartData.length) return null;
                          final item = chartData[group.x.toInt()];
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
                          reservedSize: 24,
                          getTitlesWidget: (value, meta) {
                            final index = value.toInt();
                            if (index < 0 || index >= chartData.length) {
                              return const SizedBox.shrink();
                            }
                            if (showEvery > 1 && index % showEvery != 0) {
                              return const SizedBox.shrink();
                            }
                            return Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(
                                chartData[index].month,
                                style: _text(size: 9, color: _brown400),
                              ),
                            );
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 36,
                          interval: interval,
                          getTitlesWidget: (value, meta) => Text(
                            '${(value / 1000000).toStringAsFixed(0)}jt',
                            style: _text(size: 9, color: _brown400),
                          ),
                        ),
                      ),
                    ),
                    barGroups: chartData.asMap().entries.map((entry) {
                      final isCurrent = entry.key == chartData.length - 1;
                      final toY = entry.value.revenue <= 0
                          ? 0.0
                          : entry.value.revenue;
                      return BarChartGroupData(
                        x: entry.key,
                        barRods: [
                          BarChartRodData(
                            toY: toY,
                            width: barW,
                            color: isCurrent
                                ? _orangeDark
                                : entry.value.revenue > 0
                                ? const Color(0xFFFFD4A8)
                                : const Color(0xFFEEE8E0),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(6),
                              topRight: Radius.circular(6),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                );
              },
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

  Widget _rangeButton(
    String label, {
    bool selected = false,
    required VoidCallback onPressed,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Ink(
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
        ),
      ),
    );
  }

  Widget _smallActionButton({
    required IconData icon,
    required String label,
    required VoidCallback? onPressed,
  }) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: _brown900,
        side: BorderSide(color: _orange.withValues(alpha: 0.28)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      ),
      icon: Icon(icon, size: 16),
      label: Text(label, style: _text(size: 11, weight: FontWeight.w900)),
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
