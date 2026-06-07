import 'dart:convert';
import 'dart:io';

class ApiClient {
  ApiClient(String baseUrl, {String? token})
    : _baseUri = Uri.parse(_normalizeBaseUrl(baseUrl)),
      _token = token;

  final Uri _baseUri;
  String? _token;

  static String _normalizeBaseUrl(String value) {
    return value.endsWith('/') ? value : '$value/';
  }

  String resolveUrl(String value) {
    final uri = Uri.tryParse(value);
    if (uri == null || uri.hasScheme) {
      return value;
    }

    final cleanPath = value.startsWith('/') ? value.substring(1) : value;
    return _baseUri.resolve(cleanPath).toString();
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
    final client = HttpClient();
    client.connectionTimeout = const Duration(seconds: 10);

    try {
      final cleanPath = path.startsWith('/') ? path.substring(1) : path;
      final request = await client.getUrl(_baseUri.resolve(cleanPath));
      request.headers.set(HttpHeaders.acceptHeader, 'application/json');

      _addAuthHeader(request);

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
    } catch (e) {
      if (e is ApiException || e is FormatException) {
        rethrow;
      }
      throw ApiException('Network error: ${e.toString()}');
    } finally {
      client.close(force: true);
    }
  }

  /// Make a POST request
  Future<Map<String, dynamic>> post(
    String path, {
    Map<String, dynamic>? body,
  }) async {
    final client = HttpClient();
    client.connectionTimeout = const Duration(seconds: 10);

    try {
      final cleanPath = path.startsWith('/') ? path.substring(1) : path;
      final request = await client.postUrl(_baseUri.resolve(cleanPath));
      request.headers.set(HttpHeaders.acceptHeader, 'application/json');
      request.headers.set(HttpHeaders.contentTypeHeader, 'application/json');

      _addAuthHeader(request);

      if (body != null) {
        request.write(jsonEncode(body));
      }

      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw ApiException('HTTP ${response.statusCode}: $responseBody');
      }

      final decoded = jsonDecode(responseBody);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }

      throw const FormatException('Response API bukan JSON object');
    } catch (e) {
      if (e is ApiException || e is FormatException) {
        rethrow;
      }
      throw ApiException('Network error: ${e.toString()}');
    } finally {
      client.close(force: true);
    }
  }

  /// Make a PUT request
  Future<Map<String, dynamic>> put(
    String path, {
    Map<String, dynamic>? body,
  }) async {
    final client = HttpClient();
    client.connectionTimeout = const Duration(seconds: 10);

    try {
      final cleanPath = path.startsWith('/') ? path.substring(1) : path;
      final request = await client.putUrl(_baseUri.resolve(cleanPath));
      request.headers.set(HttpHeaders.acceptHeader, 'application/json');
      request.headers.set(HttpHeaders.contentTypeHeader, 'application/json');

      _addAuthHeader(request);

      if (body != null) {
        request.write(jsonEncode(body));
      }

      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw ApiException('HTTP ${response.statusCode}: $responseBody');
      }

      final decoded = jsonDecode(responseBody);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }

      throw const FormatException('Response API bukan JSON object');
    } catch (e) {
      if (e is ApiException || e is FormatException) {
        rethrow;
      }
      throw ApiException('Network error: ${e.toString()}');
    } finally {
      client.close(force: true);
    }
  }

  /// Make a DELETE request
  Future<Map<String, dynamic>> delete(String path) async {
    final client = HttpClient();
    client.connectionTimeout = const Duration(seconds: 10);

    try {
      final cleanPath = path.startsWith('/') ? path.substring(1) : path;
      final request = await client.deleteUrl(_baseUri.resolve(cleanPath));
      request.headers.set(HttpHeaders.acceptHeader, 'application/json');

      _addAuthHeader(request);

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
    } catch (e) {
      if (e is ApiException || e is FormatException) {
        rethrow;
      }
      throw ApiException('Network error: ${e.toString()}');
    } finally {
      client.close(force: true);
    }
  }

  /// Make a multipart POST request
  Future<Map<String, dynamic>> postMultipart(
    String path, {
    required Map<String, String> fields,
    List<int>? fileBytes,
    String? filePath,
    String? fileName,
    String fileContentType = 'image/jpeg',
    String fileFieldName = 'image',
  }) async {
    final client = HttpClient();
    client.connectionTimeout = const Duration(seconds: 10);

    try {
      final cleanPath = path.startsWith('/') ? path.substring(1) : path;
      final request = await client.postUrl(_baseUri.resolve(cleanPath));
      request.headers.set(HttpHeaders.acceptHeader, 'application/json');

      _addAuthHeader(request);

      final boundary =
          '------TomodachiBoundary${DateTime.now().millisecondsSinceEpoch}';
      final List<int> bodyBytes = [];

      // Add fields
      fields.forEach((key, value) {
        bodyBytes.addAll(utf8.encode('--$boundary\r\n'));
        bodyBytes.addAll(
          utf8.encode('Content-Disposition: form-data; name="$key"\r\n\r\n'),
        );
        bodyBytes.addAll(utf8.encode('$value\r\n'));
      });

      // Add file
      if (fileBytes != null && fileBytes.isNotEmpty) {
        bodyBytes.addAll(utf8.encode('--$boundary\r\n'));
        bodyBytes.addAll(
          utf8.encode(
            'Content-Disposition: form-data; name="$fileFieldName"; filename="${fileName ?? "upload.jpg"}"\r\n',
          ),
        );
        bodyBytes.addAll(utf8.encode('Content-Type: $fileContentType\r\n\r\n'));
        bodyBytes.addAll(fileBytes);
        bodyBytes.addAll(utf8.encode('\r\n'));
      } else if (filePath != null && filePath.isNotEmpty) {
        final file = File(filePath);
        if (await file.exists()) {
          final bytes = await file.readAsBytes();
          bodyBytes.addAll(utf8.encode('--$boundary\r\n'));
          bodyBytes.addAll(
            utf8.encode(
              'Content-Disposition: form-data; name="$fileFieldName"; filename="${fileName ?? file.uri.pathSegments.last}"\r\n',
            ),
          );
          bodyBytes.addAll(
            utf8.encode('Content-Type: $fileContentType\r\n\r\n'),
          );
          bodyBytes.addAll(bytes);
          bodyBytes.addAll(utf8.encode('\r\n'));
        }
      }

      bodyBytes.addAll(utf8.encode('--$boundary--\r\n'));

      request.headers.set(
        HttpHeaders.contentTypeHeader,
        'multipart/form-data; boundary=$boundary',
      );
      request.headers.set(
        HttpHeaders.contentLengthHeader,
        bodyBytes.length.toString(),
      );
      request.add(bodyBytes);

      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw ApiException('HTTP ${response.statusCode}: $responseBody');
      }

      final decoded = jsonDecode(responseBody);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }

      throw const FormatException('Response API bukan JSON object');
    } catch (e) {
      if (e is ApiException || e is FormatException) {
        rethrow;
      }
      throw ApiException('Network error: ${e.toString()}');
    } finally {
      client.close(force: true);
    }
  }

  /// Add Bearer token to request headers
  void _addAuthHeader(HttpClientRequest request) {
    if (_token != null && _token!.isNotEmpty) {
      request.headers.set(HttpHeaders.authorizationHeader, 'Bearer $_token');
    }
  }
}

class ApiException implements Exception {
  const ApiException(this.message);

  final String message;

  @override
  String toString() => message;
}
