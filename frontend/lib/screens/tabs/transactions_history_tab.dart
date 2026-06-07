import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../transaction_service.dart';
import '../../utils/currency_formatter.dart';

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
      );

      if (res['status'] == true) {
        setState(() {
          _transactions = res['data'];
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to load transaction history: ${e.toString()}',
            ),
          ),
        );
      }
    } finally {
      setState(() => _loading = false);
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
                        'Waktu: ${data['transaction_date'].substring(0, 19).replaceFirst('T', ' ')}',
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
          Row(
            children: [
              // Channel filter
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF9F2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedChannel,
                    hint: Text(
                      'Filter Saluran',
                      style: _plusJakarta(fontSize: 13, color: Colors.grey),
                    ),
                    items: [
                      DropdownMenuItem<String>(
                        value: null,
                        child: Text(
                          'Semua Saluran',
                          style: _plusJakarta(fontSize: 13),
                        ),
                      ),
                      DropdownMenuItem<String>(
                        value: 'offline',
                        child: Text(
                          'Offline (Toko)',
                          style: _plusJakarta(fontSize: 13),
                        ),
                      ),
                      DropdownMenuItem<String>(
                        value: 'online',
                        child: Text(
                          'Online (App)',
                          style: _plusJakarta(fontSize: 13),
                        ),
                      ),
                    ],
                    onChanged: (v) {
                      setState(() => _selectedChannel = v);
                      _fetchTransactions();
                    },
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Start Date
              Expanded(
                child: TextField(
                  controller: _startDateCtrl,
                  style: _plusJakarta(fontSize: 13),
                  decoration: InputDecoration(
                    hintText: 'Mulai (YYYY-MM-DD)',
                    filled: true,
                    fillColor: const Color(0xFFFFF9F2),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onSubmitted: (_) => _fetchTransactions(),
                ),
              ),
              const SizedBox(width: 12),
              // End Date
              Expanded(
                child: TextField(
                  controller: _endDateCtrl,
                  style: _plusJakarta(fontSize: 13),
                  decoration: InputDecoration(
                    hintText: 'Selesai (YYYY-MM-DD)',
                    filled: true,
                    fillColor: const Color(0xFFFFF9F2),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onSubmitted: (_) => _fetchTransactions(),
                ),
              ),
              const SizedBox(width: 12),
              IconButton(
                icon: const Icon(Icons.refresh, color: Color(0xFFFFB570)),
                onPressed: _fetchTransactions,
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Transactions List
          Expanded(child: _buildTransactionsList()),
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
        final String dateStr = trx['created_at']
            .substring(0, 19)
            .replaceFirst('T', ' ');

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
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  formatRupiah(total),
                  style: _plusJakarta(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF3D2314),
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward_ios, size: 12),
              ],
            ),
            onTap: () => _showReceiptDialog(code),
          ),
        );
      },
    );
  }
}
