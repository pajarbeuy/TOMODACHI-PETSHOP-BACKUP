import 'dart:convert';
import 'dart:html' as html;

class ApiClient {
  ApiClient(String baseUrl) : _baseUri = Uri.parse(_normalizeBaseUrl(baseUrl));

  final Uri _baseUri;

  static String _normalizeBaseUrl(String value) {
    return value.endsWith('/') ? value : '$value/';
  }

  Future<Map<String, dynamic>> get(String path) async {
    final cleanPath = path.startsWith('/') ? path.substring(1) : path;
    final url = _baseUri.resolve(cleanPath).toString();

    final response = await html.HttpRequest.request(
      url,
      method: 'GET',
      requestHeaders: {'Accept': 'application/json'},
    );

    final status = response.status ?? 0;
    final body = response.responseText ?? '';

    if (status < 200 || status >= 300) {
      throw ApiException('HTTP $status: $body');
    }

    final decoded = jsonDecode(body);
    if (decoded is Map<String, dynamic>) {
      return decoded;
    }

    throw const FormatException('Response API bukan JSON object');
  }
}

class ApiException implements Exception {
  const ApiException(this.message);

  final String message;

  @override
  String toString() => message;
}
