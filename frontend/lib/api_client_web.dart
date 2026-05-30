import 'dart:async';
import 'dart:convert';
import 'dart:js_interop';
import 'dart:typed_data';
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

    try {
      final response = await _makeRequest(url, 'GET', headers, null);
      return response;
    } catch (e) {
      throw ApiException('GET $path failed: $e');
    }
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

    try {
      final bodyStr = body != null ? jsonEncode(body) : null;
      final response = await _makeRequest(url, 'POST', headers, bodyStr);
      return response;
    } catch (e) {
      throw ApiException('POST $path failed: $e');
    }
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

    try {
      final bodyStr = body != null ? jsonEncode(body) : null;
      final response = await _makeRequest(url, 'PUT', headers, bodyStr);
      return response;
    } catch (e) {
      throw ApiException('PUT $path failed: $e');
    }
  }

  /// Make a DELETE request
  Future<Map<String, dynamic>> delete(String path) async {
    final cleanPath = path.startsWith('/') ? path.substring(1) : path;
    final url = _baseUri.resolve(cleanPath).toString();

    final headers = {'Accept': 'application/json'};
    _addAuthHeader(headers);

    try {
      final response = await _makeRequest(url, 'DELETE', headers, null);
      return response;
    } catch (e) {
      throw ApiException('DELETE $path failed: $e');
    }
  }

  /// Internal method to make HTTP request with proper error handling
  Future<Map<String, dynamic>> _makeRequest(
    String url,
    String method,
    Map<String, String> headers,
    String? body,
  ) async {
    final completer = Completer<Map<String, dynamic>>();

    try {
      final request = web.XMLHttpRequest();

      // Handle load event
      request.onLoad.listen((_) {
        try {
          final status = request.status;
          if (status < 200 || status >= 300) {
            final responseText = request.responseText ?? '';
            completer.completeError(
              ApiException('HTTP $status: $responseText'),
            );
            return;
          }

          final responseText = request.responseText ?? '';
          if (responseText.isEmpty) {
            completer.completeError(const FormatException('Empty response'));
            return;
          }

          final decoded = jsonDecode(responseText);
          if (decoded is Map<String, dynamic>) {
            completer.complete(decoded);
          } else {
            completer.completeError(
              const FormatException('Response is not a JSON object'),
            );
          }
        } catch (e) {
          completer.completeError(e);
        }
      });

      // Handle error event
      request.onError.listen((_) {
        completer.completeError(
          ApiException('Network error: CORS or connection failed'),
        );
      });

      request.open(method, url, true);

      // Set headers
      headers.forEach((key, value) {
        request.setRequestHeader(key, value);
      });

      // Send request
      if (body != null) {
        request.send(body.toJS);
      } else {
        request.send();
      }

      return completer.future;
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException('Network request failed: $e');
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
    final cleanPath = path.startsWith('/') ? path.substring(1) : path;
    final url = _baseUri.resolve(cleanPath).toString();

    final completer = Completer<Map<String, dynamic>>();

    try {
      final formData = web.FormData();

      fields.forEach((key, value) {
        formData.append(key, value.toJS);
      });

      if (fileBytes != null && fileBytes.isNotEmpty) {
        final blob = web.Blob(
          <JSAny>[Uint8List.fromList(fileBytes).toJS].toJS,
          web.BlobPropertyBag(type: fileContentType),
        );
        formData.append(fileFieldName, blob, fileName ?? 'upload.jpg');
      }

      final request = web.XMLHttpRequest();

      request.onLoad.listen((_) {
        try {
          final status = request.status;
          if (status < 200 || status >= 300) {
            final responseText = request.responseText ?? '';
            completer.completeError(
              ApiException('HTTP $status: $responseText'),
            );
            return;
          }

          final responseText = request.responseText ?? '';
          if (responseText.isEmpty) {
            completer.completeError(const FormatException('Empty response'));
            return;
          }

          final decoded = jsonDecode(responseText);
          if (decoded is Map<String, dynamic>) {
            completer.complete(decoded);
          } else {
            completer.completeError(
              const FormatException('Response is not a JSON object'),
            );
          }
        } catch (e) {
          completer.completeError(e);
        }
      });

      request.onError.listen((_) {
        completer.completeError(
          ApiException('Multipart upload failed: Network error'),
        );
      });

      request.open('POST', url, true);

      if (_token != null && _token!.isNotEmpty) {
        request.setRequestHeader('Authorization', 'Bearer $_token');
      }
      request.setRequestHeader('Accept', 'application/json');

      request.send(formData);

      return completer.future;
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException('Multipart request failed: $e');
    }
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
