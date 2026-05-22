import 'dart:convert';
import 'package:web/web.dart' as web;

class ApiClient {
  ApiClient(String baseUrl, {String? token})
    : _baseUri = Uri.parse(_normalizeBaseUrl(baseUrl)),
      _token = token;

  final Uri _baseUri;
  String? _token;

  static String _normalizeBaseUrl(String value) {
    return value.endsWith('/') ? value : '$value/';
  }

  /// Set the authentication token
  void setToken(String token) {
    _token = token;
  }

  /// Clear the authentication token
  void clearToken() {
    _token = null;
  }

  /// Make a GET request
  Future<Map<String, dynamic>> get(String path) async {
    final cleanPath = path.startsWith('/') ? path.substring(1) : path;
    final url = _baseUri.resolve(cleanPath).toString();

    final headers = {'Accept': 'application/json'};
    _addAuthHeader(headers);

    final response = await web.HttpRequest.request(
      url,
      method: 'GET',
      requestHeaders: headers,
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

  /// Make a POST request
  Future<Map<String, dynamic>> post(
    String path, {
    Map<String, dynamic>? body,
  }) async {
    final cleanPath = path.startsWith('/') ? path.substring(1) : path;
    final url = _baseUri.resolve(cleanPath).toString();

    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    _addAuthHeader(headers);

    final response = await web.HttpRequest.request(
      url,
      method: 'POST',
      requestHeaders: headers,
      sendData: body != null ? jsonEncode(body) : null,
    );

    final status = response.status ?? 0;
    final responseBody = response.responseText ?? '';

    if (status < 200 || status >= 300) {
      throw ApiException('HTTP $status: $responseBody');
    }

    final decoded = jsonDecode(responseBody);
    if (decoded is Map<String, dynamic>) {
      return decoded;
    }

    throw const FormatException('Response API bukan JSON object');
  }

  /// Make a PUT request
  Future<Map<String, dynamic>> put(
    String path, {
    Map<String, dynamic>? body,
  }) async {
    final cleanPath = path.startsWith('/') ? path.substring(1) : path;
    final url = _baseUri.resolve(cleanPath).toString();

    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    _addAuthHeader(headers);

    final response = await web.HttpRequest.request(
      url,
      method: 'PUT',
      requestHeaders: headers,
      sendData: body != null ? jsonEncode(body) : null,
    );

    final status = response.status ?? 0;
    final responseBody = response.responseText ?? '';

    if (status < 200 || status >= 300) {
      throw ApiException('HTTP $status: $responseBody');
    }

    final decoded = jsonDecode(responseBody);
    if (decoded is Map<String, dynamic>) {
      return decoded;
    }

    throw const FormatException('Response API bukan JSON object');
  }

  /// Make a DELETE request
  Future<Map<String, dynamic>> delete(String path) async {
    final cleanPath = path.startsWith('/') ? path.substring(1) : path;
    final url = _baseUri.resolve(cleanPath).toString();

    final headers = {'Accept': 'application/json'};
    _addAuthHeader(headers);

    final response = await web.HttpRequest.request(
      url,
      method: 'DELETE',
      requestHeaders: headers,
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

  /// Add Bearer token to request headers
  void _addAuthHeader(Map<String, String> headers) {
    if (_token != null && _token!.isNotEmpty) {
      headers['Authorization'] = 'Bearer $_token';
    }
  }
}

class ApiException implements Exception {
  const ApiException(this.message);

  final String message;

  @override
  String toString() => message;
}
