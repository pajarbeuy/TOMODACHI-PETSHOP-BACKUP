class ChatMessage {
  final String role;
  final String content;
  final DateTime timestamp;
  final String? sessionId;

  const ChatMessage({
    required this.role,
    required this.content,
    required this.timestamp,
    this.sessionId,
  });

  bool get isUser => role == 'user';
  bool get isAssistant => role == 'assistant';

  factory ChatMessage.fromHistoryJson(Map<String, dynamic> json) {
    return ChatMessage(
      role: json['role']?.toString() ?? 'assistant',
      content: json['content']?.toString() ?? '',
      sessionId: json['session_id']?.toString(),
      timestamp:
          DateTime.tryParse(json['created_at']?.toString() ?? '') ??
          DateTime.now(),
    );
  }
}

class RestockItem {
  final int productId;
  final String productName;
  final String sku;
  final String category;
  final int currentStock;
  final int totalSold30Days;
  final double avgDailySales;
  final double predictedNeed7Days;
  final String status;
  final int minThreshold;

  const RestockItem({
    required this.productId,
    required this.productName,
    required this.sku,
    required this.category,
    required this.currentStock,
    required this.totalSold30Days,
    required this.avgDailySales,
    required this.predictedNeed7Days,
    required this.status,
    required this.minThreshold,
  });

  bool get needsRestock => status == 'RESTOCK';

  factory RestockItem.fromJson(Map<String, dynamic> json) {
    return RestockItem(
      productId: _asInt(json['product_id']),
      productName: json['product_name']?.toString() ?? '',
      sku: json['sku']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      currentStock: _asInt(json['current_stock']),
      totalSold30Days: _asInt(json['total_sold_30_days']),
      avgDailySales: _asDouble(json['avg_daily_sales']),
      predictedNeed7Days: _asDouble(json['predicted_need_7days']),
      status: json['status']?.toString() ?? 'SAFE',
      minThreshold: _asInt(json['min_threshold']),
    );
  }
}

class RestockSummary {
  final int totalProducts;
  final int needRestock;
  final int safe;

  const RestockSummary({
    required this.totalProducts,
    required this.needRestock,
    required this.safe,
  });

  factory RestockSummary.fromJson(Map<String, dynamic> json) {
    return RestockSummary(
      totalProducts: _asInt(json['total_products']),
      needRestock: _asInt(json['need_restock']),
      safe: _asInt(json['safe']),
    );
  }
}

class RestockAnalysis {
  final RestockSummary summary;
  final List<RestockItem> needRestock;
  final List<RestockItem> safe;

  const RestockAnalysis({
    required this.summary,
    required this.needRestock,
    required this.safe,
  });

  factory RestockAnalysis.fromJson(Map<String, dynamic> json) {
    return RestockAnalysis(
      summary: RestockSummary.fromJson(
        (json['summary'] as Map?)?.cast<String, dynamic>() ?? {},
      ),
      needRestock: _itemsFromJson(json['need_restock']),
      safe: _itemsFromJson(json['safe']),
    );
  }

  static List<RestockItem> _itemsFromJson(Object? value) {
    if (value is! List) return const [];
    return value
        .whereType<Map>()
        .map((item) => RestockItem.fromJson(item.cast<String, dynamic>()))
        .toList();
  }
}

int _asInt(Object? value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}

double _asDouble(Object? value) {
  if (value is num) return value.toDouble();
  return double.tryParse(value?.toString() ?? '') ?? 0;
}
