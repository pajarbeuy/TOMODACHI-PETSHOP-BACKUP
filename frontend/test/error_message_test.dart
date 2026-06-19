import 'package:flutter_test/flutter_test.dart';
import 'package:frontendd/api_client.dart';
import 'package:frontendd/utils/error_message.dart';

void main() {
  group('userFriendlyError', () {
    test('strips technical prefixes from validation errors', () {
      final message = userFriendlyError(
        const ApiException('HTTP 422: The email field is required.'),
      );

      expect(message, 'The email field is required.');
    });

    test('normalizes wrapped exception prefixes', () {
      final message = userFriendlyError(
        Exception('Error: HTTP 404: Product not found'),
      );

      expect(message, 'Data yang diminta tidak ditemukan.');
    });

    test('maps web connection errors to Indonesian message', () {
      final message = userFriendlyError(
        const ApiException('Network error: CORS or connection failed'),
      );

      expect(
        message,
        'Tidak bisa terhubung ke server. Periksa koneksi atau konfigurasi API.',
      );
    });
  });
}
