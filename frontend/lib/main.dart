import 'package:flutter/material.dart';

import 'api_client.dart';

void main() {
  runApp(const TomodachiApp());
}

class TomodachiApp extends StatelessWidget {
  const TomodachiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tomodachi Pet Shop',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0F766E),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const ApiConnectionPage(),
    );
  }
}

class ApiConnectionPage extends StatefulWidget {
  const ApiConnectionPage({super.key});

  @override
  State<ApiConnectionPage> createState() => _ApiConnectionPageState();
}

class _ApiConnectionPageState extends State<ApiConnectionPage> {
  final TextEditingController _baseUrlController = TextEditingController(
    text: _defaultBaseUrl(),
  );

  bool _isLoading = false;
  String? _error;
  Map<String, dynamic>? _health;
  List<dynamic> _products = [];
  List<dynamic> _categories = [];

  static String _defaultBaseUrl() {
    return 'http://127.0.0.1:8000/api';
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _baseUrlController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final api = ApiClient(_baseUrlController.text.trim());
      final results = await Future.wait([
        api.get('/health'),
        api.get('/products'),
        api.get('/categories'),
      ]);

      setState(() {
        _health = results[0];
        _products = _extractDataList(results[1]);
        _categories = _extractDataList(results[2]);
      });
    } catch (error) {
      setState(() {
        _error = error.toString();
        _health = null;
        _products = [];
        _categories = [];
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  List<dynamic> _extractDataList(Map<String, dynamic> response) {
    final data = response['data'];
    return data is List ? data : [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tomodachi Pet Shop'),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed: _isLoading ? null : _loadData,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadData,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _ApiUrlPanel(
                controller: _baseUrlController,
                isLoading: _isLoading,
                onConnect: _loadData,
              ),
              const SizedBox(height: 16),
              _ConnectionStatus(
                isLoading: _isLoading,
                error: _error,
                health: _health,
              ),
              const SizedBox(height: 16),
              _SummaryRow(
                productCount: _products.length,
                categoryCount: _categories.length,
              ),
              const SizedBox(height: 16),
              Text(
                'Produk',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              if (_products.isEmpty)
                const _EmptyState()
              else
                ..._products.map((product) => _ProductTile(product: product)),
            ],
          ),
        ),
      ),
    );
  }
}

class _ApiUrlPanel extends StatelessWidget {
  const _ApiUrlPanel({
    required this.controller,
    required this.isLoading,
    required this.onConnect,
  });

  final TextEditingController controller;
  final bool isLoading;
  final VoidCallback onConnect;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                decoration: const InputDecoration(
                  labelText: 'Base URL API',
                  hintText: 'http://10.0.2.2:8000/api',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.url,
              ),
            ),
            const SizedBox(width: 8),
            FilledButton.icon(
              onPressed: isLoading ? null : onConnect,
              icon: const Icon(Icons.cable),
              label: const Text('Connect'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ConnectionStatus extends StatelessWidget {
  const _ConnectionStatus({
    required this.isLoading,
    required this.error,
    required this.health,
  });

  final bool isLoading;
  final String? error;
  final Map<String, dynamic>? health;

  @override
  Widget build(BuildContext context) {
    final Color color;
    final IconData icon;
    final String title;
    final String subtitle;

    if (isLoading) {
      color = Colors.blueGrey;
      icon = Icons.sync;
      title = 'Menghubungkan...';
      subtitle = 'Frontend sedang memanggil Laravel API.';
    } else if (error != null) {
      color = Colors.red;
      icon = Icons.error_outline;
      title = 'Belum tersambung';
      subtitle = error!;
    } else {
      color = Colors.green;
      icon = Icons.check_circle_outline;
      title = 'Backend tersambung';
      subtitle = health?['message']?.toString() ?? 'API aktif.';
    }

    return ListTile(
      contentPadding: const EdgeInsets.all(12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      tileColor: color.withOpacity(0.10),
      leading: Icon(icon, color: color),
      title: Text(title),
      subtitle: Text(subtitle),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.productCount,
    required this.categoryCount,
  });

  final int productCount;
  final int categoryCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _MetricBox(label: 'Produk', value: productCount.toString()),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _MetricBox(label: 'Kategori', value: categoryCount.toString()),
        ),
      ],
    );
  }
}

class _MetricBox extends StatelessWidget {
  const _MetricBox({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 6),
            Text(value, style: Theme.of(context).textTheme.headlineMedium),
          ],
        ),
      ),
    );
  }
}

class _ProductTile extends StatelessWidget {
  const _ProductTile({required this.product});

  final dynamic product;

  @override
  Widget build(BuildContext context) {
    final item = product is Map<String, dynamic> ? product as Map<String, dynamic> : <String, dynamic>{};
    final category = item['category'] is Map<String, dynamic>
        ? item['category'] as Map<String, dynamic>
        : null;
    final stock = item['stock'] is Map<String, dynamic> ? item['stock'] as Map<String, dynamic> : null;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(item['name']?.toString() ?? 'Produk tanpa nama'),
        subtitle: Text([
          item['sku']?.toString(),
          category?['name']?.toString(),
          'Stok offline: ${stock?['offline_qty'] ?? 0}',
        ].whereType<String>().where((value) => value.isNotEmpty).join(' | ')),
        trailing: Text(_formatRupiah(item['sell_price'])),
      ),
    );
  }

  String _formatRupiah(dynamic value) {
    final parsed = num.tryParse(value?.toString() ?? '0') ?? 0;
    return 'Rp ${parsed.toStringAsFixed(0)}';
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Text(
        'Belum ada produk dari API. Jalankan migration dan isi data produk dulu.',
      ),
    );
  }
}
