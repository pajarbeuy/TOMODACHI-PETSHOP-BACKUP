import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../transaction_service.dart';
import '../../utils/currency_formatter.dart';
import '../../utils/error_message.dart';

class TransactionsHistoryTab extends StatefulWidget {
  final TransactionService transactionService;

  const TransactionsHistoryTab({super.key, required this.transactionService});

  @override
  State<TransactionsHistoryTab> createState() => _TransactionsHistoryTabState();
}

class _TransactionsHistoryTabState extends State<TransactionsHistoryTab> {
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

  List<dynamic> _transactions = [];
  bool _loading = false;
  String? _selectedChannel;
  int _currentPage = 1;
  int _lastPage = 1;
  int _totalTransactions = 0;
  static const int _perPage = 10;
  final _startDateCtrl = TextEditingController();
  final _endDateCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchTransactions();
  }

  @override
  void dispose() {
    _startDateCtrl.dispose();
    _endDateCtrl.dispose();
    super.dispose();
  }

  Future<void> _fetchTransactions() async {
    if (_loading) return;
    setState(() => _loading = true);

    try {
      final res = await widget.transactionService.getTransactions(
        channel: _selectedChannel,
        startDate: _startDateCtrl.text.trim(),
        endDate: _endDateCtrl.text.trim(),
        page: _currentPage,
        perPage: _perPage,
      );

      if (res['status'] == true) {
        final pagination = res['pagination'];
        setState(() {
          _transactions = res['data'];
          if (pagination is Map) {
            _currentPage =
                int.tryParse('${pagination['current_page'] ?? _currentPage}') ??
                    _currentPage;
            _lastPage =
                int.tryParse('${pagination['last_page'] ?? _lastPage}') ??
                    _lastPage;
            _totalTransactions =
                int.tryParse('${pagination['total'] ?? _totalTransactions}') ??
                    _totalTransactions;
          }
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              userFriendlyError(e, fallback: 'Gagal memuat riwayat transaksi'),
            ),
          ),
        );
      }
    } finally {
      setState(() => _loading = false);
    }
  }

  void _refreshFirstPage() {
    setState(() => _currentPage = 1);
    _fetchTransactions();
  }

  void _goToPage(int page) {
    if (page < 1 || page > _lastPage || page == _currentPage || _loading) {
      return;
    }

    setState(() => _currentPage = page);
    _fetchTransactions();
  }

  /// Format ISO 8601 timestamp ke waktu WIB yang dapat dibaca.
  String _formatWIB(String isoString) {
    try {
      final dt = DateTime.parse(isoString).toLocal();
      final pad = (int n) => n.toString().padLeft(2, '0');
      return '${dt.year}-${pad(dt.month)}-${pad(dt.day)} '
          '${pad(dt.hour)}:${pad(dt.minute)}:${pad(dt.second)} WIB';
    } catch (_) {
      return isoString;
    }
  }

  /// Format ke waktu WIB pendek (tanpa detik) untuk daftar transaksi.
  String _formatWIBShort(String isoString) {
    try {
      final dt = DateTime.parse(isoString).toLocal();
      final pad = (int n) => n.toString().padLeft(2, '0');
      return '${dt.year}-${pad(dt.month)}-${pad(dt.day)} '
          '${pad(dt.hour)}:${pad(dt.minute)} WIB';
    } catch (_) {
      return isoString;
    }
  }

  void _showReceiptDialog(String transactionId) async {
    showDialog(
      context: context,
      builder: (context) {
        return FutureBuilder<Map<String, dynamic>>(
          future: widget.transactionService.getReceipt(transactionId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError || snapshot.data?['status'] != true) {
              return AlertDialog(
                title: const Text('Error loading receipt'),
                content: const Text(
                  'Could not load the receipt details at this moment.',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('OK'),
                  ),
                ],
              );
            }

            final data = snapshot.data!['data'];
            final items = data['items'] as List<dynamic>;

            return AlertDialog(
              backgroundColor: const Color(0xFFFFFDF9),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Center(
                child: Text(
                  'STRUK DIGITAL',
                  style: _plusJakarta(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ),
              content: SingleChildScrollView(
                child: SizedBox(
                  width: 320,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Divider(thickness: 1.5, height: 20),
                      Text(
                        'No: ${data['transaction_id']}',
                        style: _plusJakarta(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Waktu: ${_formatWIB(data['transaction_date']?.toString() ?? '')}',
                        style: _plusJakarta(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      Text(
                        'Kasir: ${data['kasir_name']}',
                        style: _plusJakarta(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const Divider(thickness: 1.5, height: 20),
                      ...items.map((item) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['product_name'],
                                      style: _plusJakarta(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '${item['quantity']}x ${formatRupiah(item['unit_price'])}',
                                      style: _plusJakarta(
                                        fontSize: 11,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                formatRupiah(item['subtotal']),
                                style: _plusJakarta(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                      const Divider(thickness: 1.5, height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Subtotal', style: _plusJakarta(fontSize: 13)),
                          Text(
                            formatRupiah(data['subtotal']),
                            style: _plusJakarta(fontSize: 13),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Pajak (0%)', style: _plusJakarta(fontSize: 13)),
                          Text(
                            formatRupiah(data['tax']),
                            style: _plusJakarta(fontSize: 13),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total',
                            style: _plusJakarta(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            formatRupiah(data['total']),
                            style: _plusJakarta(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Metode Pembayaran',
                            style: _plusJakarta(fontSize: 12),
                          ),
                          Text(
                            data['payment_method'].toString().toUpperCase(),
                            style: _plusJakarta(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Bayar', style: _plusJakarta(fontSize: 13)),
                          Text(
                            formatRupiah(data['amount_paid']),
                            style: _plusJakarta(fontSize: 13),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Kembalian',
                            style: _plusJakarta(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            formatRupiah(data['change']),
                            style: _plusJakarta(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Tutup',
                    style: _plusJakarta(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFFFB570),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Riwayat Transaksi Kasir',
            style: _plusJakarta(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // Filters panel
          Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 50,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF9F2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedChannel,
                          isExpanded: true,
                          hint: Text(
                            'Filter Saluran',
                            style: _plusJakarta(
                              fontSize: 13,
                              color: Colors.grey,
                            ),
                          ),
                          items: [
                            DropdownMenuItem<String>(
                              value: null,
                              child: Text(
                                'Semua Saluran',
                                overflow: TextOverflow.ellipsis,
                                style: _plusJakarta(fontSize: 13),
                              ),
                            ),
                            DropdownMenuItem<String>(
                              value: 'offline',
                              child: Text(
                                'Offline (Toko)',
                                overflow: TextOverflow.ellipsis,
                                style: _plusJakarta(fontSize: 13),
                              ),
                            ),
                            DropdownMenuItem<String>(
                              value: 'online',
                              child: Text(
                                'Online (App)',
                                overflow: TextOverflow.ellipsis,
                                style: _plusJakarta(fontSize: 13),
                              ),
                            ),
                          ],
                          onChanged: (v) {
                            setState(() => _selectedChannel = v);
                            _refreshFirstPage();
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    width: 50,
                    height: 50,
                    child: IconButton(
                      icon: const Icon(Icons.refresh, color: Color(0xFFFFB570)),
                      onPressed: _fetchTransactions,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        final selected = await showDatePicker(
                          context: context,
                          initialDate: _startDateCtrl.text.isNotEmpty
                              ? DateTime.parse(_startDateCtrl.text)
                              : DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime.now().add(
                            const Duration(days: 365),
                          ),
                        );
                        if (selected != null) {
                          setState(() {
                            _startDateCtrl.text = selected.toString().split(
                              ' ',
                            )[0];
                          });
                          _refreshFirstPage();
                        }
                      },
                      child: Container(
                        height: 50,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF9F2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                _startDateCtrl.text.isNotEmpty
                                    ? _startDateCtrl.text
                                    : 'Mulai',
                                style: _plusJakarta(
                                  fontSize: 13,
                                  color: _startDateCtrl.text.isNotEmpty
                                      ? const Color(0xFF3D2314)
                                      : Colors.grey,
                                ),
                              ),
                            ),
                            const Icon(
                              Icons.calendar_today,
                              color: Color(0xFFFFB570),
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        final selected = await showDatePicker(
                          context: context,
                          initialDate: _endDateCtrl.text.isNotEmpty
                              ? DateTime.parse(_endDateCtrl.text)
                              : DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime.now().add(
                            const Duration(days: 365),
                          ),
                        );
                        if (selected != null) {
                          setState(() {
                            _endDateCtrl.text = selected.toString().split(
                              ' ',
                            )[0];
                          });
                          _refreshFirstPage();
                        }
                      },
                      child: Container(
                        height: 50,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF9F2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                _endDateCtrl.text.isNotEmpty
                                    ? _endDateCtrl.text
                                    : 'Selesai',
                                style: _plusJakarta(
                                  fontSize: 13,
                                  color: _endDateCtrl.text.isNotEmpty
                                      ? const Color(0xFF3D2314)
                                      : Colors.grey,
                                ),
                              ),
                            ),
                            const Icon(
                              Icons.calendar_today,
                              color: Color(0xFFFFB570),
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Transactions List
          Expanded(child: _buildTransactionsList()),
          const SizedBox(height: 10),
          _buildPaginationControls(),
        ],
      ),
    );
  }

  Widget _buildPaginationControls() {
    final start = _totalTransactions == 0
        ? 0
        : ((_currentPage - 1) * _perPage) + 1;
    final end = (_currentPage * _perPage).clamp(0, _totalTransactions);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9F2),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              _totalTransactions == 0
                  ? 'Tidak ada transaksi'
                  : '$start-$end dari $_totalTransactions transaksi',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: _plusJakarta(fontSize: 12, color: Colors.grey.shade700),
            ),
          ),
          IconButton(
            tooltip: 'Halaman sebelumnya',
            onPressed: _currentPage > 1 ? () => _goToPage(_currentPage - 1) : null,
            icon: const Icon(Icons.chevron_left),
          ),
          Text(
            '$_currentPage / $_lastPage',
            style: _plusJakarta(fontSize: 12, fontWeight: FontWeight.bold),
          ),
          IconButton(
            tooltip: 'Halaman berikutnya',
            onPressed:
                _currentPage < _lastPage ? () => _goToPage(_currentPage + 1) : null,
            icon: const Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionsList() {
    if (_loading && _transactions.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_transactions.isEmpty) {
      return Center(
        child: Text(
          'Tidak ada data transaksi ditemukan.',
          style: _plusJakarta(color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      itemCount: _transactions.length,
      itemBuilder: (context, index) {
        final trx = _transactions[index];
        final String code = trx['transaction_code'] ?? 'Unknown Code';
        final String channel = trx['channel'] ?? 'offline';
        final double total = parseCurrency(trx['total']);
        final String payment = trx['payment_method'] ?? 'cash';
        final String dateStr = _formatWIBShort(
          trx['created_at']?.toString() ?? '',
        );

        return Card(
          color: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Colors.grey.shade100),
          ),
          margin: const EdgeInsets.only(bottom: 10),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: channel == 'online'
                  ? const Color(0xFFE0F2FE)
                  : const Color(0xFFFEF3C7),
              foregroundColor: channel == 'online'
                  ? Colors.blue.shade700
                  : Colors.amber.shade700,
              child: Icon(
                channel == 'online' ? Icons.language : Icons.storefront,
              ),
            ),
            title: Text(
              code,
              style: _plusJakarta(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              '$dateStr - ${payment.toUpperCase()}',
              style: _plusJakarta(fontSize: 11, color: Colors.grey.shade500),
            ),
            trailing: SizedBox(
              width: 120,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Flexible(
                    child: Text(
                      formatRupiah(total),
                      overflow: TextOverflow.ellipsis,
                      style: _plusJakarta(
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFF3D2314),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward_ios, size: 12),
                ],
              ),
            ),
            onTap: () => _showReceiptDialog(code),
          ),
        );
      },
    );
  }
}
