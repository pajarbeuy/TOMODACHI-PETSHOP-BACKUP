import 'api_client.dart';

class TransactionService {
  final ApiClient _client;

  TransactionService(this._client);

  /// Checkout a POS transaction
  Future<Map<String, dynamic>> checkout({
    required String channel,
    required String paymentMethod,
    required double amountPaid,
    required List<Map<String, dynamic>> items,
  }) async {
    final body = {
      'channel': channel,
      'payment_method': paymentMethod,
      'amount_paid': amountPaid,
      'items': items,
    };

    if (paymentMethod == 'qris') {
      body['enabled_payments'] = ['qris'];
    }

    return await _client.post('/api/transactions', body: body);
  }

  /// Get transaction list history
  Future<Map<String, dynamic>> getTransactions({
    String? channel,
    String? startDate,
    String? endDate,
    int page = 1,
    int perPage = 15,
  }) async {
    final Map<String, String> queryParams = {};
    if (channel != null && channel.isNotEmpty) queryParams['channel'] = channel;
    if (startDate != null && startDate.isNotEmpty) {
      queryParams['start_date'] = startDate;
    }
    if (endDate != null && endDate.isNotEmpty) {
      queryParams['end_date'] = endDate;
    }
    queryParams['page'] = page.toString();
    queryParams['per_page'] = perPage.toString();

    final queryString = Uri(queryParameters: queryParams).query;
    return await _client.get('/api/transactions?$queryString');
  }

  /// Get transaction detail
  Future<Map<String, dynamic>> getTransactionDetail(String id) async {
    return await _client.get('/api/transactions/$id');
  }

  /// Get dynamic receipt printable data
  Future<Map<String, dynamic>> getReceipt(String id) async {
    return await _client.get('/api/transactions/$id/receipt');
  }
}
