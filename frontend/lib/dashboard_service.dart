import 'api_client.dart';

class DashboardService {
  final ApiClient _client;

  DashboardService(this._client);

  /// Fetch sales report for owner dashboard
  Future<Map<String, dynamic>> getSalesReport({
    required String startDate,
    required String endDate,
    String channel = 'all',
  }) async {
    final queryParams = {
      'start_date': startDate,
      'end_date': endDate,
      'channel': channel,
    };
    final queryString = Uri(queryParameters: queryParams).query;
    return await _client.get('/api/reports/sales?$queryString');
  }

  /// Fetch chronological summary aggregates
  Future<Map<String, dynamic>> getSalesSummary({
    required String period,
    required int year,
    int? month,
  }) async {
    final queryParams = {
      'period': period,
      'year': year.toString(),
    };
    if (month != null) {
      queryParams['month'] = month.toString();
    }
    final queryString = Uri(queryParameters: queryParams).query;
    return await _client.get('/api/reports/sales/summary?$queryString');
  }

  /// Fetch top-selling products rank list
  Future<Map<String, dynamic>> getTopProducts({
    String sortBy = 'quantity',
    int limit = 10,
    String? startDate,
    String? endDate,
  }) async {
    final queryParams = {
      'sort_by': sortBy,
      'limit': limit.toString(),
    };
    if (startDate != null && startDate.isNotEmpty) queryParams['start_date'] = startDate;
    if (endDate != null && endDate.isNotEmpty) queryParams['end_date'] = endDate;
    
    final queryString = Uri(queryParameters: queryParams).query;
    return await _client.get('/api/reports/top-products?$queryString');
  }

  /// Fetch general dashboard KPIs, sales trends and category distributions
  Future<Map<String, dynamic>> getAnalytics() async {
    return await _client.get('/api/dashboard/analytics');
  }
}
