import 'dart:convert';
import 'dart:io';

class ApiClient {
  ApiClient(String baseUrl) : _baseUri = Uri.parse(_normalizeBaseUrl(baseUrl));

  final Uri _baseUri;

  static String _normalizeBaseUrl(String value) {
    return value.endsWith('/') ? value : '$value/';
  }

  Future<Map<String, dynamic>> get(String path) async {
    final client = HttpClient();
    client.connectionTimeout = const Duration(seconds: 10);

    try {
      final cleanPath = path.startsWith('/') ? path.substring(1) : path;
      final request = await client.getUrl(_baseUri.resolve(cleanPath));
      request.headers.set(HttpHeaders.acceptHeader, 'application/json');

      final response = await request.close();
      final body = await response.transform(utf8.decoder).join();

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw ApiException('HTTP ${response.statusCode}: $body');
      }

      final decoded = jsonDecode(body);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }

      throw const FormatException('Response API bukan JSON object');
    } finally {
      client.close(force: true);
    }
  }
}

class ApiException implements Exception {
  const ApiException(this.message);

  final String message;

  @override
  String toString() => message;
}
