import 'package:flutter/material.dart';
import 'dart:math' as math;

// ─── Data ─────────────────────────────────────────────────────────────────────

class _MonthlyData {
  final String month;
  final int revenue;
  final int transactions;
  const _MonthlyData(this.month, this.revenue, this.transactions);
}

class _WeeklyData {
  final String day;
  final int revenue;
  final int transactions;
  const _WeeklyData(this.day, this.revenue, this.transactions);
}

class _CategoryData {
  final String name;
  final int value;
  final Color color;
  final int amount;
  const _CategoryData(this.name, this.value, this.color, this.amount);
}

class _TopProduct {
  final int rank;
  final String name;
  final String category;
  final int unitsSold;
  final int revenue;
  final int trend;
  final String emoji;
  const _TopProduct(this.rank, this.name, this.category, this.unitsSold,
      this.revenue, this.trend, this.emoji);
}

class _Transaction {
  final String id;
  final String customer;
  final String date;
  final int total;
  final String method;
  final int items;
  const _Transaction(this.id, this.customer, this.date, this.total,
      this.method, this.items);
}

const _monthly = [
  _MonthlyData('Jan', 32500000, 312),
  _MonthlyData('Feb', 28800000, 278),
  _MonthlyData('Mar', 35200000, 340),
  _MonthlyData('Apr', 31800000, 305),
  _MonthlyData('May', 38500000, 372),
  _MonthlyData('Jun', 42000000, 415),
  _MonthlyData('Jul', 39800000, 385),
  _MonthlyData('Aug', 44200000, 430),
  _MonthlyData('Sep', 41500000, 400),
  _MonthlyData('Oct', 46800000, 452),
  _MonthlyData('Nov', 52300000, 505),
  _MonthlyData('Dec', 58900000, 568),
];

const _weekly = [
  _WeeklyData('Mon', 1250000, 18),
  _WeeklyData('Tue', 980000, 14),
  _WeeklyData('Wed', 1450000, 22),
  _WeeklyData('Thu', 1100000, 16),
  _WeeklyData('Fri', 1680000, 25),
  _WeeklyData('Sat', 2100000, 32),
  _WeeklyData('Sun', 1890000, 28),
];

const _categories = [
  _CategoryData('Food', 45, Color(0xFFFFB570), 23850000),
  _CategoryData('Accessories', 22, Color(0xFFA0E7E5), 11660000),
  _CategoryData('Medicine', 18, Color(0xFFFFC7D1), 9540000),
  _CategoryData('Toys', 8, Color(0xFFB8F2E6), 4240000),
  _CategoryData('Grooming', 7, Color(0xFFC5B5F0), 3710000),
];

const _topProducts = [
  _TopProduct(1, 'Royal Canin Adult Dog Food 2kg', 'Food', 124, 17980000, 12, '🐕'),
  _TopProduct(2, 'Whiskas Tuna Cat Food 1.2kg', 'Food', 98, 6370000, 8, '🐈'),
  _TopProduct(3, 'Frontline Plus Antiparasitic', 'Medicine', 65, 9425000, 15, '💊'),
  _TopProduct(4, 'Kong Classic Dog Toy', 'Toys', 87, 7569000, -3, '🦴'),
  _TopProduct(5, 'Aquarium Starter Kit 20L', 'Accessories', 22, 7700000, 20, '🐠'),
  _TopProduct(6, 'Dog Shampoo Premium 500ml', 'Grooming', 54, 2970000, 5, '🛁'),
  _TopProduct(7, 'Pedigree Puppy Food 1.5kg', 'Food', 68, 6460000, 3, '🐕'),
  _TopProduct(8, 'Bird Cage Medium Decorative', 'Accessories', 18, 4950000, 7, '🦜'),
];

const _transactions = [
  _Transaction('TRX-0241', 'Budi Santoso', '16 May 2024', 285000, 'Cash', 3),
  _Transaction('TRX-0240', 'Siti Rahayu', '16 May 2024', 155000, 'QRIS', 2),
  _Transaction('TRX-0239', 'Ahmad Fadli', '15 May 2024', 520000, 'Card', 5),
  _Transaction('TRX-0238', 'Dewi Kusuma', '15 May 2024', 89000, 'Cash', 1),
  _Transaction('TRX-0237', 'Rizki Pratama', '14 May 2024', 375000, 'Transfer', 4),
  _Transaction('TRX-0236', 'Maya Indah', '14 May 2024', 212000, 'QRIS', 3),
];

// ─── Formatters ───────────────────────────────────────────────────────────────

String formatRp(int n) {
  final s = n.toString();
  final rem = s.length % 3;
  final buf = StringBuffer('Rp ');
  for (int i = 0; i < s.length; i++) {
    if (i != 0 && (i - rem) % 3 == 0) buf.write('.');
    buf.write(s[i]);
  }
  return buf.toString();
}

String formatRpShort(int n) {
  if (n >= 1000000) return 'Rp ${(n / 1000000).toStringAsFixed(1)}jt';
  if (n >= 1000) return 'Rp ${(n / 1000).toStringAsFixed(0)}rb';
  return 'Rp $n';
}

// ─── Animated Hover Card ──────────────────────────────────────────────────────

class _HoverCard extends StatefulWidget {
  final Widget child;
  final BoxDecoration decoration;
  final EdgeInsets? padding;
  const _HoverCard({
    required this.child,
    required this.decoration,
    this.padding,
  });

  @override
  State<_HoverCard> createState() => _HoverCardState();
}

class _HoverCardState extends State<_HoverCard>
    with SingleTickerProviderStateMixin {
  bool _hovered = false;
  late AnimationController _ctrl;
  late Animation<double> _scale;
  late Animation<double> _shadow;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    _scale = Tween<double>(begin: 1.0, end: 1.015).animate(
        CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    _shadow = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() => _hovered = true);
        _ctrl.forward();
      },
      onExit: (_) {
        setState(() => _hovered = false);
        _ctrl.reverse();
      },
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (_, child) => Transform.scale(
          scale: _scale.value,
          child: Container(
            padding: widget.padding,
            decoration: widget.decoration.copyWith(
              boxShadow: [
                BoxShadow(
                  color: Color.lerp(
                    const Color(0x08000000),
                    const Color(0x22FF9A4D),
                    _shadow.value,
                  )!,
                  blurRadius: 8 + _shadow.value * 16,
                  offset: Offset(0, 2 + _shadow.value * 4),
                ),
              ],
            ),
            child: child,
          ),
        ),
        child: widget.child,
      ),
    );
  }
}

// ─── Animated Summary Card ────────────────────────────────────────────────────

class _AnimatedSummaryCard extends StatefulWidget {
  final _SummaryCardData data;
  final int delay;
  const _AnimatedSummaryCard({required this.data, required this.delay});

  @override
  State<_AnimatedSummaryCard> createState() => _AnimatedSummaryCardState();
}

class _AnimatedSummaryCardState extends State<_AnimatedSummaryCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;
  late Animation<Offset> _slide;
  bool _hovered = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));

    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: MouseRegion(
          onEnter: (_) => setState(() => _hovered = true),
          onExit: (_) => setState(() => _hovered = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            transform: Matrix4.identity()
              ..translate(0.0, _hovered ? -4.0 : 0.0),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: widget.data.gradColors,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _hovered
                    ? widget.data.iconColor.withOpacity(0.3)
                    : Colors.white.withOpacity(0.6),
                width: _hovered ? 1.5 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: _hovered
                      ? widget.data.iconColor.withOpacity(0.18)
                      : const Color(0x08000000),
                  blurRadius: _hovered ? 20 : 8,
                  offset: Offset(0, _hovered ? 8 : 2),
                ),
              ],
            ),
            child: Stack(
              children: [
                Positioned(
                  right: -12,
                  bottom: -12,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: _hovered ? 96 : 80,
                    height: _hovered ? 96 : 80,
                    decoration: BoxDecoration(
                      color: Colors.white
                          .withOpacity(_hovered ? 0.30 : 0.20),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: _hovered
                                ? widget.data.iconColor.withOpacity(0.2)
                                : widget.data.iconBg,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(widget.data.icon,
                              size: 20, color: widget.data.iconColor),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: widget.data.trend >= 0
                                ? const Color(0xFFB8F2E6)
                                : const Color(0xFFFFD4D4),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                widget.data.trend >= 0
                                    ? Icons.arrow_upward_rounded
                                    : Icons.arrow_downward_rounded,
                                size: 10,
                                color: widget.data.trend >= 0
                                    ? const Color(0xFF1B7A65)
                                    : const Color(0xFFC0392B),
                              ),
                              const SizedBox(width: 2),
                              Text(
                                '${widget.data.trend.abs()}%',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: widget.data.trend >= 0
                                      ? const Color(0xFF1B7A65)
                                      : const Color(0xFFC0392B),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(widget.data.label,
                        style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF9B7B6B))),
                    const SizedBox(height: 3),
                    Text(widget.data.value,
                        style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF3D2314))),
                    const SizedBox(height: 2),
                    Text(widget.data.sub,
                        style: const TextStyle(
                            fontSize: 11, color: Color(0xFF9B7B6B))),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Screen ───────────────────────────────────────────────────────────────────

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  String _period = 'This Month';
  bool _chartWeekly = false;

  static const _periods = [
    'This Week', 'This Month', 'Last 3 Months', 'This Year'
  ];

  int get _totalRevenue =>
      _monthly.fold(0, (s, m) => s + m.revenue);
  int get _totalTx =>
      _monthly.fold(0, (s, m) => s + m.transactions);
  int get _avgTx => (_totalRevenue / _totalTx).round();
  _MonthlyData get _bestMonth =>
      _monthly.reduce((a, b) => b.revenue > a.revenue ? b : a);

  @override
  Widget build(BuildContext context) {
    // ✅ Wrap with Material to fix DropdownButton errors
    return Material(
      color: const Color(0xFFFFF6E9),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 20),
            _buildSummaryCards(),
            const SizedBox(height: 16),
            _buildChartsRow(),
            const SizedBox(height: 16),
            _buildTrendLine(),
            const SizedBox(height: 16),
            _buildBottomRow(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // ── Header ──────────────────────────────────────────────────────────────────
  Widget _buildHeader() {
    return Row(
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Reports & Analytics',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF3D2314))),
              SizedBox(height: 2),
              Text('Business performance overview',
                  style:
                      TextStyle(fontSize: 13, color: Color(0xFF9B7B6B))),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0x33FFB570)),
            boxShadow: const [
              BoxShadow(
                  color: Color(0x08000000),
                  blurRadius: 6,
                  offset: Offset(0, 2))
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: _periods.map((p) {
              final active = p == _period;
              return GestureDetector(
                onTap: () => setState(() => _period = p),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: active
                        ? const Color(0xFFFFB570)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: active
                        ? const [
                            BoxShadow(
                                color: Color(0x30FF9650),
                                blurRadius: 6)
                          ]
                        : null,
                  ),
                  child: Text(
                    p,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: active
                          ? Colors.white
                          : const Color(0xFF9B7B6B),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(width: 10),
        _HoverButton(
          onPressed: () {},
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.download_outlined, size: 16, color: Colors.white),
              SizedBox(width: 6),
              Text('Export',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
            ],
          ),
        ),
      ],
    );
  }

  // ── Summary 2×2 grid ────────────────────────────────────────────────────────
  Widget _buildSummaryCards() {
    final cards = [
      _SummaryCardData(
        label: 'Total Revenue',
        value: formatRpShort(_totalRevenue),
        sub: 'Annual 2024',
        icon: Icons.attach_money_rounded,
        iconColor: const Color(0xFFFF9A4D),
        iconBg: const Color(0x33FFB570),
        trend: 18.5,
        gradColors: const [Color(0xFFFFF6E9), Color(0xFFFFE8CC)],
      ),
      _SummaryCardData(
        label: 'Total Transactions',
        value: _totalTx.toString().replaceAllMapped(
            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},'),
        sub: 'All time',
        icon: Icons.shopping_bag_outlined,
        iconColor: const Color(0xFFE07B9E),
        iconBg: const Color(0x4DFFC7D1),
        trend: 12.3,
        gradColors: const [Color(0xFFFFF0F5), Color(0xFFFFE0EC)],
      ),
      _SummaryCardData(
        label: 'Avg. Transaction',
        value: formatRpShort(_avgTx),
        sub: 'Per order',
        icon: Icons.trending_up_rounded,
        iconColor: const Color(0xFF1B9E85),
        iconBg: const Color(0x80B8F2E6),
        trend: 4.2,
        gradColors: const [Color(0xFFF0FDF9), Color(0xFFD4F5EE)],
      ),
      _SummaryCardData(
        label: 'Best Month',
        value: _bestMonth.month,
        sub: formatRpShort(_bestMonth.revenue),
        icon: Icons.calendar_month_outlined,
        iconColor: const Color(0xFF4A9FD4),
        iconBg: const Color(0x66A0E7E5),
        trend: 32.1,
        gradColors: const [Color(0xFFF0FAFE), Color(0xFFD4EFFD)],
      ),
    ];

    return Column(
      children: [
        Row(children: [
          Expanded(
              child: _AnimatedSummaryCard(data: cards[0], delay: 0)),
          const SizedBox(width: 12),
          Expanded(
              child: _AnimatedSummaryCard(data: cards[1], delay: 80)),
        ]),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(
              child: _AnimatedSummaryCard(data: cards[2], delay: 160)),
          const SizedBox(width: 12),
          Expanded(
              child: _AnimatedSummaryCard(data: cards[3], delay: 240)),
        ]),
      ],
    );
  }

  // ── Charts row ───────────────────────────────────────────────────────────────
  Widget _buildChartsRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 2, child: _buildBarChart()),
        const SizedBox(width: 14),
        Expanded(child: _buildPieChart()),
      ],
    );
  }

  Widget _buildBarChart() {
    final monthData = _monthly;
    return _HoverCard(
      decoration: _cardDeco(),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Revenue Overview',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF3D2314))),
                    const SizedBox(height: 2),
                    Text(
                      _chartWeekly
                          ? 'Last 7 days'
                          : 'January – December 2024',
                      style: const TextStyle(
                          fontSize: 11, color: Color(0xFF9B7B6B)),
                    ),
                  ]),
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF0E0),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _chartTab('Weekly', _chartWeekly,
                        () => setState(() => _chartWeekly = true)),
                    _chartTab('Monthly', !_chartWeekly,
                        () => setState(() => _chartWeekly = false)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: _chartWeekly
                ? _AnimatedBarChart(
                    key: const ValueKey('weekly'),
                    labels: _weekly.map((d) => d.day).toList(),
                    values: _weekly.map((d) => d.revenue).toList(),
                    highlightIndex: 5,
                    barWidth: 28,
                  )
                : _AnimatedBarChart(
                    key: const ValueKey('monthly'),
                    labels: monthData.map((d) => d.month).toList(),
                    values: monthData.map((d) => d.revenue).toList(),
                    highlightIndex: monthData.length - 1,
                    barWidth: 18,
                  ),
          ),
        ],
      ),
    );
  }

  Widget _chartTab(String label, bool active, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: active ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          boxShadow: active
              ? const [
                  BoxShadow(
                      color: Color(0x15000000), blurRadius: 4)
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: active
                ? const Color(0xFFFF9A4D)
                : const Color(0xFF9B7B6B),
          ),
        ),
      ),
    );
  }

  Widget _buildPieChart() {
    return _HoverCard(
      decoration: _cardDeco(),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Sales by Category',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF3D2314))),
          const SizedBox(height: 2),
          const Text('Revenue distribution',
              style:
                  TextStyle(fontSize: 11, color: Color(0xFF9B7B6B))),
          const SizedBox(height: 16),
          SizedBox(
            height: 160,
            child: _AnimatedPieChart(data: _categories),
          ),
          const SizedBox(height: 12),
          ..._categories.map((c) => _PieLegendItem(cat: c)),
        ],
      ),
    );
  }

  // ── Transaction trend line ───────────────────────────────────────────────────
  Widget _buildTrendLine() {
    return _HoverCard(
      decoration: _cardDeco(),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Transaction Volume Trend',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF3D2314))),
                    SizedBox(height: 2),
                    Text('Monthly transaction count',
                        style: TextStyle(
                            fontSize: 11, color: Color(0xFF9B7B6B))),
                  ]),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0x66B8F2E6),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.trending_up_rounded,
                        size: 12, color: Color(0xFF1B7A65)),
                    SizedBox(width: 4),
                    Text('+23.8% vs last year',
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1B7A65))),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 140,
            child: _AnimatedLineChart(
              labels: _monthly.map((d) => d.month).toList(),
              values: _monthly.map((d) => d.transactions).toList(),
            ),
          ),
        ],
      ),
    );
  }

  // ── Bottom row ───────────────────────────────────────────────────────────────
  Widget _buildBottomRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 2, child: _buildTopProducts()),
        const SizedBox(width: 14),
        Expanded(child: _buildRecentTransactions()),
      ],
    );
  }

  Widget _buildTopProducts() {
    return _HoverCard(
      decoration: _cardDeco(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 16, 20, 12),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Top Products',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF3D2314))),
                  SizedBox(height: 2),
                  Text('Best performing products this period',
                      style: TextStyle(
                          fontSize: 11, color: Color(0xFF9B7B6B))),
                ]),
          ),
          const Divider(height: 1, color: Color(0x1FFFB570)),
          Container(
            color: const Color(0xFFFFF8F2),
            padding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 10),
            child: Row(
              children: [
                _th('#', flex: 1),
                _th('PRODUCT', flex: 5),
                _th('CATEGORY', flex: 2),
                _th('UNITS', flex: 2),
                _th('REVENUE', flex: 3),
                _th('TREND', flex: 2),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0x1FFFB570)),
          ..._topProducts.map((p) => _HoverProductRow(product: p)),
        ],
      ),
    );
  }

  Widget _th(String label, {required int flex}) => Expanded(
        flex: flex,
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w900,
            color: Color(0xFF9B7B6B),
            letterSpacing: 0.6,
          ),
        ),
      );

  Widget _buildRecentTransactions() {
    return _HoverCard(
      decoration: _cardDeco(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 16, 20, 12),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Recent Transactions',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF3D2314))),
                  SizedBox(height: 2),
                  Text('Latest activity',
                      style: TextStyle(
                          fontSize: 11, color: Color(0xFF9B7B6B))),
                ]),
          ),
          const Divider(height: 1, color: Color(0x1FFFB570)),
          ..._transactions.map((tx) => _HoverTransactionRow(tx: tx)),
          Padding(
            padding: const EdgeInsets.all(16),
            child: _HoverTextButton(
              label: 'View All Transactions',
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration _cardDeco() => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0x1FFFB570)),
        boxShadow: const [
          BoxShadow(
              color: Color(0x08000000),
              blurRadius: 8,
              offset: Offset(0, 2))
        ],
      );
}

// ─── Hover Button ─────────────────────────────────────────────────────────────

class _HoverButton extends StatefulWidget {
  final VoidCallback onPressed;
  final Widget child;
  const _HoverButton({required this.onPressed, required this.child});

  @override
  State<_HoverButton> createState() => _HoverButtonState();
}

class _HoverButtonState extends State<_HoverButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(
              horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: _hovered
                ? const Color(0xFF5A3824)
                : const Color(0xFF3D2314),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: _hovered
                    ? const Color(0x55000000)
                    : const Color(0x33000000),
                blurRadius: _hovered ? 16 : 8,
                offset: Offset(0, _hovered ? 6 : 3),
              )
            ],
          ),
          child: widget.child,
        ),
      ),
    );
  }
}

// ─── Hover Product Row ────────────────────────────────────────────────────────

class _HoverProductRow extends StatefulWidget {
  final _TopProduct product;
  const _HoverProductRow({required this.product});

  @override
  State<_HoverProductRow> createState() => _HoverProductRowState();
}

class _HoverProductRowState extends State<_HoverProductRow> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          color: _hovered
              ? const Color(0xFFFFF8F2)
              : Colors.transparent,
          border: const Border(
              bottom: BorderSide(color: Color(0x0DFFB570))),
        ),
        padding: const EdgeInsets.symmetric(
            horizontal: 16, vertical: 10),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: p.rank <= 3
                      ? (_hovered
                          ? const Color(0xFFFF9A4D)
                          : const Color(0xFFFFB570))
                      : (_hovered
                          ? const Color(0xFFFFE4C4)
                          : const Color(0xFFF5E8D5)),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Center(
                  child: Text(
                    '${p.rank}',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      color: p.rank <= 3
                          ? Colors.white
                          : const Color(0xFF9B7B6B),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Row(
                children: [
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 150),
                    style: TextStyle(
                        fontSize: _hovered ? 22 : 18),
                    child: Text(p.emoji),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      p.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: _hovered
                              ? const Color(0xFFFF9A4D)
                              : const Color(0xFF3D2314)),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: _hovered
                      ? const Color(0xFFFFE4C4)
                      : const Color(0xFFFFF0E0),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  p.category,
                  style: const TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFFF9A4D)),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                '${p.unitsSold}',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    color: _hovered
                        ? const Color(0xFFFF9A4D)
                        : const Color(0xFF3D2314)),
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                formatRpShort(p.revenue),
                style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3D2314)),
              ),
            ),
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  Icon(
                    p.trend >= 0
                        ? Icons.arrow_upward_rounded
                        : Icons.arrow_downward_rounded,
                    size: 10,
                    color: p.trend >= 0
                        ? const Color(0xFF1B7A65)
                        : const Color(0xFFC0392B),
                  ),
                  const SizedBox(width: 2),
                  Text(
                    '${p.trend.abs()}%',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: p.trend >= 0
                          ? const Color(0xFF1B7A65)
                          : const Color(0xFFC0392B),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Hover Transaction Row ────────────────────────────────────────────────────

class _HoverTransactionRow extends StatefulWidget {
  final _Transaction tx;
  const _HoverTransactionRow({required this.tx});

  @override
  State<_HoverTransactionRow> createState() => _HoverTransactionRowState();
}

class _HoverTransactionRowState extends State<_HoverTransactionRow> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final tx = widget.tx;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          color: _hovered
              ? const Color(0xFFFFF8F2)
              : Colors.transparent,
          border: const Border(
              bottom: BorderSide(color: Color(0x0DFFB570))),
        ),
        padding: const EdgeInsets.symmetric(
            horizontal: 20, vertical: 12),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(tx.customer,
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: _hovered
                            ? const Color(0xFFFF9A4D)
                            : const Color(0xFF3D2314))),
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 150),
                  style: TextStyle(
                    fontSize: _hovered ? 13 : 12,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFFFF9A4D),
                  ),
                  child: Text(formatRpShort(tx.total)),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: _hovered
                          ? const Color(0xFFFFE4C4)
                          : const Color(0xFFF5E8D5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(tx.method,
                        style: const TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF9B7B6B))),
                  ),
                  const SizedBox(width: 6),
                  Text('${tx.items} items',
                      style: const TextStyle(
                          fontSize: 10, color: Color(0xFF9B7B6B))),
                ]),
                Text(tx.date,
                    style: const TextStyle(
                        fontSize: 10, color: Color(0xFF9B7B6B))),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Hover Text Button ────────────────────────────────────────────────────────

class _HoverTextButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  const _HoverTextButton({required this.label, required this.onTap});

  @override
  State<_HoverTextButton> createState() => _HoverTextButtonState();
}

class _HoverTextButtonState extends State<_HoverTextButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: _hovered
                ? const Color(0xFFFFE4C4)
                : const Color(0xFFFFF0E0),
            borderRadius: BorderRadius.circular(12),
            boxShadow: _hovered
                ? const [
                    BoxShadow(
                        color: Color(0x20FF9A4D),
                        blurRadius: 8,
                        offset: Offset(0, 3))
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('View All Transactions',
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: _hovered
                          ? const Color(0xFFE07B00)
                          : const Color(0xFFFF9A4D))),
              const SizedBox(width: 4),
              AnimatedSlide(
                duration: const Duration(milliseconds: 180),
                offset: _hovered
                    ? const Offset(0.2, 0)
                    : Offset.zero,
                child: const Icon(Icons.arrow_outward_rounded,
                    size: 12, color: Color(0xFFFF9A4D)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Pie Legend Item with hover ───────────────────────────────────────────────

class _PieLegendItem extends StatefulWidget {
  final _CategoryData cat;
  const _PieLegendItem({required this.cat});

  @override
  State<_PieLegendItem> createState() => _PieLegendItemState();
}

class _PieLegendItemState extends State<_PieLegendItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final c = widget.cat;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.only(bottom: 8),
        padding: _hovered
            ? const EdgeInsets.symmetric(horizontal: 6, vertical: 3)
            : EdgeInsets.zero,
        decoration: BoxDecoration(
          color: _hovered ? c.color.withOpacity(0.08) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: _hovered ? 12 : 10,
              height: _hovered ? 12 : 10,
              decoration: BoxDecoration(
                  color: c.color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(c.name,
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: _hovered
                          ? FontWeight.w800
                          : FontWeight.w600,
                      color: _hovered
                          ? const Color(0xFF3D2314)
                          : const Color(0xFF6B4F3E))),
            ),
            Text('${c.value}%',
                style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3D2314))),
            const SizedBox(width: 6),
            Text(formatRpShort(c.amount),
                style: const TextStyle(
                    fontSize: 10, color: Color(0xFF9B7B6B))),
          ],
        ),
      ),
    );
  }
}

// ─── Data model ───────────────────────────────────────────────────────────────
class _SummaryCardData {
  final String label;
  final String value;
  final String sub;
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final double trend;
  final List<Color> gradColors;
  const _SummaryCardData({
    required this.label,
    required this.value,
    required this.sub,
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.trend,
    required this.gradColors,
  });
}

// ─── Animated Bar Chart ───────────────────────────────────────────────────────

class _AnimatedBarChart extends StatefulWidget {
  final List<String> labels;
  final List<int> values;
  final int highlightIndex;
  final double barWidth;

  const _AnimatedBarChart({
    super.key,
    required this.labels,
    required this.values,
    required this.highlightIndex,
    required this.barWidth,
  });

  @override
  State<_AnimatedBarChart> createState() => _AnimatedBarChartState();
}

class _AnimatedBarChartState extends State<_AnimatedBarChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _progress;
  int? _hoveredIndex;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900));
    _progress = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic);
    _ctrl.forward();
  }

  @override
  void didUpdateWidget(_AnimatedBarChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.key != widget.key) {
      _ctrl.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final maxVal = widget.values.reduce(math.max).toDouble();
    final yLabels = [0, 15, 30, 45, 60];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: yLabels.reversed
              .map((v) => Text('${v}jt',
                  style: const TextStyle(
                      fontSize: 9, color: Color(0xFF9B7B6B))))
              .toList(),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: AnimatedBuilder(
            animation: _progress,
            builder: (_, __) => _InteractiveBarChart(
              values: widget.values,
              labels: widget.labels,
              maxVal: maxVal,
              highlightIndex: widget.highlightIndex,
              barWidth: widget.barWidth,
              progress: _progress.value,
              hoveredIndex: _hoveredIndex,
              onHover: (i) => setState(() => _hoveredIndex = i),
            ),
          ),
        ),
      ],
    );
  }
}

class _InteractiveBarChart extends StatelessWidget {
  final List<int> values;
  final List<String> labels;
  final double maxVal;
  final int highlightIndex;
  final double barWidth;
  final double progress;
  final int? hoveredIndex;
  final ValueChanged<int?> onHover;

  const _InteractiveBarChart({
    required this.values,
    required this.labels,
    required this.maxVal,
    required this.highlightIndex,
    required this.barWidth,
    required this.progress,
    required this.hoveredIndex,
    required this.onHover,
  });

  @override
  Widget build(BuildContext context) {
    final n = values.length;
    return LayoutBuilder(builder: (_, constraints) {
      final w = constraints.maxWidth;
      final h = constraints.maxHeight;
      final chartH = h - 20;
      final spacing = w / n;

      return Stack(
        children: [
          // Grid + bars via CustomPaint
          CustomPaint(
            size: Size(w, h),
            painter: _BarChartGridPainter(chartH: chartH),
          ),
          // Bars and tooltip triggers
          ...List.generate(n, (i) {
            final barH =
                (values[i] / maxVal) * chartH * progress;
            final x =
                spacing * i + (spacing - barWidth) / 2;
            final y = chartH - barH;
            final isHovered = hoveredIndex == i;
            final isHighlight = i == highlightIndex;

            return Positioned(
              left: x,
              top: y,
              width: barWidth,
              height: barH,
              child: MouseRegion(
                onEnter: (_) => onHover(i),
                onExit: (_) => onHover(null),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      decoration: BoxDecoration(
                        color: isHovered
                            ? const Color(0xFFFF7A1A)
                            : isHighlight
                                ? const Color(0xFFFF9A4D)
                                : const Color(0xFFFFD4A8),
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(5)),
                        boxShadow: isHovered
                            ? [
                                BoxShadow(
                                  color: const Color(0xFFFF9A4D)
                                      .withOpacity(0.4),
                                  blurRadius: 10,
                                  offset: const Offset(0, -2),
                                )
                              ]
                            : null,
                      ),
                    ),
                    // Tooltip
                    if (isHovered)
                      Positioned(
                        bottom: barH + 6,
                        left: barWidth / 2 - 45,
                        child: _Tooltip(
                          label: labels[i],
                          value: formatRpShort(values[i]),
                        ),
                      ),
                  ],
                ),
              ),
            );
          }),
          // X labels
          ...List.generate(n, (i) {
            final x = spacing * i + spacing / 2;
            return Positioned(
              bottom: 0,
              left: x - 16,
              width: 32,
              child: Text(
                labels[i],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 9,
                  color: hoveredIndex == i
                      ? const Color(0xFFFF9A4D)
                      : const Color(0xFF9B7B6B),
                  fontWeight: hoveredIndex == i
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
            );
          }),
        ],
      );
    });
  }
}

class _BarChartGridPainter extends CustomPainter {
  final double chartH;
  _BarChartGridPainter({required this.chartH});

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = const Color(0x1FFFB570)
      ..strokeWidth = 1;
    for (int i = 0; i <= 4; i++) {
      final y = chartH - (chartH * i / 4);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter _) => false;
}

// ─── Tooltip Widget ───────────────────────────────────────────────────────────

class _Tooltip extends StatelessWidget {
  final String label;
  final String value;
  const _Tooltip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF3D2314),
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
              color: Color(0x33000000),
              blurRadius: 12,
              offset: Offset(0, 4))
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 9,
                  color: Color(0xFFFFD4A8),
                  fontWeight: FontWeight.w600)),
          Text(value,
              style: const TextStyle(
                  fontSize: 11,
                  color: Colors.white,
                  fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }
}

// ─── Animated Pie Chart ───────────────────────────────────────────────────────

class _AnimatedPieChart extends StatefulWidget {
  final List<_CategoryData> data;
  const _AnimatedPieChart({required this.data});

  @override
  State<_AnimatedPieChart> createState() => _AnimatedPieChartState();
}

class _AnimatedPieChartState extends State<_AnimatedPieChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _progress;
  int? _hoveredSlice;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 1000));
    _progress = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic);
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _progress,
      builder: (_, __) => GestureDetector(
        onTapDown: (details) {
          // detect which slice tapped
          final box = context.findRenderObject() as RenderBox;
          final local = box.globalToLocal(details.globalPosition);
          final w = box.size.width;
          final h = box.size.height;
          final cx = w / 2;
          final cy = h / 2;
          final r = math.min(cx, cy) - 4;

          final dx = local.dx - cx;
          final dy = local.dy - cy;
          final dist = math.sqrt(dx * dx + dy * dy);
          if (dist > r) return;

          double angle = math.atan2(dy, dx) + math.pi / 2;
          if (angle < 0) angle += math.pi * 2;

          final total =
              widget.data.fold(0, (s, d) => s + d.value);
          double startA = 0;
          for (int i = 0; i < widget.data.length; i++) {
            final sweep =
                (widget.data[i].value / total) * math.pi * 2;
            if (angle >= startA && angle < startA + sweep) {
              setState(() => _hoveredSlice =
                  _hoveredSlice == i ? null : i);
              break;
            }
            startA += sweep;
          }
        },
        child: MouseRegion(
          onHover: (event) {
            final box =
                context.findRenderObject() as RenderBox;
            final local =
                box.globalToLocal(event.position);
            final w = box.size.width;
            final h = box.size.height;
            final cx = w / 2;
            final cy = h / 2;
            final r = math.min(cx, cy) - 4;

            final dx = local.dx - cx;
            final dy = local.dy - cy;
            final dist = math.sqrt(dx * dx + dy * dy);
            if (dist > r) {
              if (_hoveredSlice != null) {
                setState(() => _hoveredSlice = null);
              }
              return;
            }

            double angle =
                math.atan2(dy, dx) + math.pi / 2;
            if (angle < 0) angle += math.pi * 2;

            final total =
                widget.data.fold(0, (s, d) => s + d.value);
            double startA = 0;
            for (int i = 0; i < widget.data.length; i++) {
              final sweep =
                  (widget.data[i].value / total) * math.pi * 2;
              if (angle >= startA && angle < startA + sweep) {
                if (_hoveredSlice != i) {
                  setState(() => _hoveredSlice = i);
                }
                break;
              }
              startA += sweep;
            }
          },
          onExit: (_) =>
              setState(() => _hoveredSlice = null),
          child: CustomPaint(
            painter: _PieChartPainter(
              data: widget.data,
              progress: _progress.value,
              hoveredSlice: _hoveredSlice,
            ),
          ),
        ),
      ),
    );
  }
}

class _PieChartPainter extends CustomPainter {
  final List<_CategoryData> data;
  final double progress;
  final int? hoveredSlice;

  _PieChartPainter({
    required this.data,
    required this.progress,
    this.hoveredSlice,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = math.min(cx, cy) - 4;

    double startAngle = -math.pi / 2;
    final total = data.fold(0, (s, d) => s + d.value);
    final totalSweep = math.pi * 2 * progress;

    for (int i = 0; i < data.length; i++) {
      final cat = data[i];
      final sweep =
          ((cat.value / total) * math.pi * 2).clamp(0.0, totalSweep);
      final isHovered = hoveredSlice == i;

      // Explode hovered slice outward
      double offsetX = 0;
      double offsetY = 0;
      if (isHovered) {
        final midAngle = startAngle + sweep / 2;
        offsetX = math.cos(midAngle) * 8;
        offsetY = math.sin(midAngle) * 8;
      }

      final center = Offset(cx + offsetX, cy + offsetY);
      final drawR = isHovered ? r + 4 : r;

      final paint = Paint()
        ..color = cat.color
        ..style = PaintingStyle.fill;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: drawR),
        startAngle,
        sweep,
        true,
        paint,
      );

      // Glow on hover
      if (isHovered) {
        canvas.drawArc(
          Rect.fromCircle(center: center, radius: drawR + 2),
          startAngle,
          sweep,
          true,
          Paint()
            ..color = cat.color.withOpacity(0.25)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 4,
        );
      }

      // percentage label
      if (cat.value >= 8) {
        final midAngle = startAngle + sweep / 2;
        final labelR = isHovered ? drawR * 0.6 : r * 0.65;
        final lx = cx + offsetX + labelR * math.cos(midAngle);
        final ly = cy + offsetY + labelR * math.sin(midAngle);
        final tp = TextPainter(
          text: TextSpan(
            text: '${cat.value}%',
            style: TextStyle(
                fontSize: isHovered ? 12 : 10,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        tp.paint(
            canvas, Offset(lx - tp.width / 2, ly - tp.height / 2));
      }

      startAngle += sweep;
      if (startAngle - (-math.pi / 2) >= totalSweep) break;
    }
  }

  @override
  bool shouldRepaint(covariant _PieChartPainter old) =>
      old.progress != progress || old.hoveredSlice != hoveredSlice;
}

// ─── Animated Line Chart ──────────────────────────────────────────────────────

class _AnimatedLineChart extends StatefulWidget {
  final List<String> labels;
  final List<int> values;
  const _AnimatedLineChart(
      {required this.labels, required this.values});

  @override
  State<_AnimatedLineChart> createState() => _AnimatedLineChartState();
}

class _AnimatedLineChartState extends State<_AnimatedLineChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _progress;
  int? _hoveredPoint;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 1200));
    _progress = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _progress,
      builder: (_, __) => MouseRegion(
        onHover: (event) {
          final box = context.findRenderObject() as RenderBox;
          final local = box.globalToLocal(event.position);
          final w = box.size.width;
          final n = widget.values.length;
          final stepX = w / (n - 1);

          int? nearest;
          double minDist = 30;
          for (int i = 0; i < n; i++) {
            final px = i * stepX;
            final dist = (local.dx - px).abs();
            if (dist < minDist) {
              minDist = dist;
              nearest = i;
            }
          }
          if (nearest != _hoveredPoint) {
            setState(() => _hoveredPoint = nearest);
          }
        },
        onExit: (_) => setState(() => _hoveredPoint = null),
        child: CustomPaint(
          painter: _LineChartPainter(
            labels: widget.labels,
            values: widget.values,
            progress: _progress.value,
            hoveredPoint: _hoveredPoint,
          ),
        ),
      ),
    );
  }
}

class _LineChartPainter extends CustomPainter {
  final List<String> labels;
  final List<int> values;
  final double progress;
  final int? hoveredPoint;

  _LineChartPainter({
    required this.labels,
    required this.values,
    required this.progress,
    this.hoveredPoint,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final maxVal = values.reduce(math.max).toDouble();
    final minVal = values.reduce(math.min).toDouble();
    final range = maxVal - minVal == 0 ? 1.0 : (maxVal - minVal);
    final chartH = size.height - 20;
    final n = values.length;
    final stepX = size.width / (n - 1);

    // Grid
    final gridPaint = Paint()
      ..color = const Color(0x1FFFB570)
      ..strokeWidth = 1;
    for (int i = 0; i <= 3; i++) {
      final y = chartH * i / 3;
      canvas.drawLine(
          Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Build all points
    final allPts = List.generate(n, (i) {
      final x = i * stepX;
      final y = chartH - ((values[i] - minVal) / range) * chartH;
      return Offset(x, y);
    });

    // How many points to draw based on progress
    final drawCount = (progress * (n - 1)).floor() + 1;
    final fracPt = progress * (n - 1) - (drawCount - 1);
    List<Offset> pts = allPts.sublist(0, drawCount);
    if (drawCount < n) {
      final last = pts.last;
      final next = allPts[drawCount];
      pts = [...pts, Offset.lerp(last, next, fracPt)!];
    }

    // Fill
    final fillPath = Path()..moveTo(pts[0].dx, chartH);
    for (final pt in pts) fillPath.lineTo(pt.dx, pt.dy);
    fillPath.lineTo(pts.last.dx, chartH);
    fillPath.close();
    canvas.drawPath(
      fillPath,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFFA0E7E5).withOpacity(0.35),
            const Color(0xFFA0E7E5).withOpacity(0.0),
          ],
        ).createShader(
            Rect.fromLTWH(0, 0, size.width, size.height)),
    );

    // Line
    final linePath = Path()..moveTo(pts[0].dx, pts[0].dy);
    for (int i = 1; i < pts.length; i++) {
      linePath.lineTo(pts[i].dx, pts[i].dy);
    }
    canvas.drawPath(
        linePath,
        Paint()
          ..color = const Color(0xFFA0E7E5)
          ..strokeWidth = 2.5
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round);

    // Dots and hover
    for (int i = 0; i < drawCount; i++) {
      final isHovered = hoveredPoint == i;
      final dotR = isHovered ? 6.0 : 4.0;

      // Glow on hover
      if (isHovered) {
        canvas.drawCircle(
            allPts[i],
            12,
            Paint()
              ..color = const Color(0xFFA0E7E5).withOpacity(0.2)
              ..style = PaintingStyle.fill);
      }

      canvas.drawCircle(
          allPts[i],
          dotR,
          Paint()
            ..color = const Color(0xFFA0E7E5)
            ..style = PaintingStyle.fill);
      canvas.drawCircle(
          allPts[i],
          dotR,
          Paint()
            ..color = Colors.white
            ..style = PaintingStyle.stroke
            ..strokeWidth = isHovered ? 3 : 2);

      // Tooltip
      if (isHovered) {
        final tp = TextPainter(
          text: TextSpan(
            children: [
              TextSpan(
                text: '${labels[i]}\n',
                style: const TextStyle(
                    fontSize: 9,
                    color: Color(0xFFB8F2E6),
                    fontWeight: FontWeight.w600),
              ),
              TextSpan(
                text: '${values[i]} trx',
                style: const TextStyle(
                    fontSize: 11,
                    color: Colors.white,
                    fontWeight: FontWeight.w900),
              ),
            ],
          ),
          textDirection: TextDirection.ltr,
        )..layout();

        const padH = 8.0;
        const padV = 6.0;
        final boxW = tp.width + padH * 2;
        final boxH = tp.height + padV * 2;
        double bx =
            allPts[i].dx - boxW / 2;
        double by = allPts[i].dy - boxH - 14;

        bx = bx.clamp(0, size.width - boxW);
        if (by < 0) by = allPts[i].dy + 14;

        final rrect = RRect.fromRectAndRadius(
          Rect.fromLTWH(bx, by, boxW, boxH),
          const Radius.circular(8),
        );
        canvas.drawRRect(
            rrect,
            Paint()
              ..color = const Color(0xFF3D2314)
              ..style = PaintingStyle.fill);
        tp.paint(canvas, Offset(bx + padH, by + padV));

        // Vertical line to dot
        canvas.drawLine(
            Offset(allPts[i].dx, by + boxH),
            Offset(allPts[i].dx, allPts[i].dy - dotR),
            Paint()
              ..color = const Color(0xFFA0E7E5).withOpacity(0.5)
              ..strokeWidth = 1
              ..style = PaintingStyle.stroke);
      }
    }

    // X labels
    for (int i = 0; i < n; i++) {
      final isHovered = hoveredPoint == i;
      final tp = TextPainter(
        text: TextSpan(
            text: labels[i],
            style: TextStyle(
                fontSize: 9,
                color: isHovered
                    ? const Color(0xFFA0E7E5)
                    : const Color(0xFF9B7B6B),
                fontWeight: isHovered
                    ? FontWeight.bold
                    : FontWeight.normal)),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas,
          Offset(i * stepX - tp.width / 2, chartH + 4));
    }
  }

  @override
  bool shouldRepaint(covariant _LineChartPainter old) =>
      old.progress != progress || old.hoveredPoint != hoveredPoint;
}