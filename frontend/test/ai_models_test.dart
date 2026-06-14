import 'package:flutter_test/flutter_test.dart';
import 'package:frontendd/models/ai_models.dart';

void main() {
  group('ChatMessage', () {
    test('detects user role', () {
      final message = ChatMessage(
        role: 'user',
        content: 'Halo',
        timestamp: DateTime(2026),
      );

      expect(message.isUser, isTrue);
      expect(message.isAssistant, isFalse);
    });

    test('detects assistant role', () {
      final message = ChatMessage(
        role: 'assistant',
        content: 'Halo juga',
        timestamp: DateTime(2026),
      );

      expect(message.isAssistant, isTrue);
      expect(message.isUser, isFalse);
    });

    test('parses history json', () {
      final message = ChatMessage.fromHistoryJson({
        'role': 'user',
        'content': 'Butuh restock?',
        'session_id': 'session-1',
        'created_at': '2026-06-13T10:00:00Z',
      });

      expect(message.role, 'user');
      expect(message.content, 'Butuh restock?');
      expect(message.sessionId, 'session-1');
      expect(message.timestamp.toUtc().year, 2026);
    });

    test('uses safe defaults for malformed history json', () {
      final message = ChatMessage.fromHistoryJson({});

      expect(message.role, 'assistant');
      expect(message.content, '');
      expect(message.sessionId, isNull);
    });
  });

  group('RestockItem', () {
    test('parses numeric values from strings', () {
      final item = RestockItem.fromJson({
        'product_id': '10',
        'product_name': 'Cat Food',
        'sku': 'CAT-1',
        'category': 'cat / food',
        'current_stock': '2',
        'total_sold_30_days': '30',
        'avg_daily_sales': '1.5',
        'predicted_need_7days': '10.5',
        'status': 'RESTOCK',
        'min_threshold': '5',
      });

      expect(item.productId, 10);
      expect(item.currentStock, 2);
      expect(item.avgDailySales, 1.5);
      expect(item.needsRestock, isTrue);
    });

    test('safe status does not need restock', () {
      final item = RestockItem.fromJson({'status': 'SAFE'});

      expect(item.needsRestock, isFalse);
    });

    test('uses safe defaults for missing fields', () {
      final item = RestockItem.fromJson({});

      expect(item.productId, 0);
      expect(item.productName, '');
      expect(item.status, 'SAFE');
    });
  });

  group('RestockSummary', () {
    test('parses summary json', () {
      final summary = RestockSummary.fromJson({
        'total_products': '7',
        'need_restock': 2,
        'safe': '5',
      });

      expect(summary.totalProducts, 7);
      expect(summary.needRestock, 2);
      expect(summary.safe, 5);
    });

    test('defaults missing summary counts to zero', () {
      final summary = RestockSummary.fromJson({});

      expect(summary.totalProducts, 0);
      expect(summary.needRestock, 0);
      expect(summary.safe, 0);
    });
  });

  group('RestockAnalysis', () {
    test('parses need restock and safe lists', () {
      final analysis = RestockAnalysis.fromJson({
        'summary': {'total_products': 2, 'need_restock': 1, 'safe': 1},
        'need_restock': [
          {'product_name': 'Low Stock', 'status': 'RESTOCK'},
        ],
        'safe': [
          {'product_name': 'Enough Stock', 'status': 'SAFE'},
        ],
      });

      expect(analysis.summary.totalProducts, 2);
      expect(analysis.needRestock.single.productName, 'Low Stock');
      expect(analysis.safe.single.productName, 'Enough Stock');
    });

    test('ignores non-map list items', () {
      final analysis = RestockAnalysis.fromJson({
        'need_restock': ['bad', {'product_name': 'Valid'}],
      });

      expect(analysis.needRestock, hasLength(1));
      expect(analysis.needRestock.single.productName, 'Valid');
    });

    test('uses empty lists when list fields are malformed', () {
      final analysis = RestockAnalysis.fromJson({
        'need_restock': 'bad',
        'safe': null,
      });

      expect(analysis.needRestock, isEmpty);
      expect(analysis.safe, isEmpty);
    });
  });
}
