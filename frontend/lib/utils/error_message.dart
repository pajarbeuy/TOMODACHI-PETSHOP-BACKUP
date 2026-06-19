import '../api_client.dart';

String userFriendlyError(Object? error, {String fallback = 'Terjadi kesalahan'}) {
  if (error == null) {
    return fallback;
  }

  var message = error is ApiException ? error.message : error.toString();
  message = message.trim();

  if (message.isEmpty) {
    return fallback;
  }

  message = _stripKnownPrefixes(message);
  message = _stripHttpPrefix(message);
  message = message.trim();

  if (message.isEmpty) {
    return fallback;
  }

  final lower = message.toLowerCase();
  if (lower.contains('cors') || lower.contains('connection failed')) {
    return 'Tidak bisa terhubung ke server. Periksa koneksi atau konfigurasi API.';
  }
  if (lower.contains('connection refused') ||
      lower.contains('failed host lookup') ||
      lower.contains('network is unreachable') ||
      lower.contains('network error')) {
    return 'Koneksi ke server gagal. Pastikan server API sedang berjalan.';
  }
  if (lower.contains('timed out') || lower.contains('timeout')) {
    return 'Permintaan terlalu lama. Coba lagi beberapa saat lagi.';
  }
  if (lower.contains('unauthenticated') || lower.contains('unauthorized')) {
    return 'Sesi login sudah habis. Silakan login kembali.';
  }
  if (lower.contains('forbidden')) {
    return 'Anda tidak memiliki izin untuk melakukan aksi ini.';
  }
  if (lower.contains('not found')) {
    return 'Data yang diminta tidak ditemukan.';
  }
  if (lower.contains('response api bukan json object') ||
      lower.contains('response is not a json object') ||
      lower.contains('format exception')) {
    return 'Format respons server tidak sesuai.';
  }

  return message;
}

String _stripKnownPrefixes(String message) {
  var result = message;
  final prefixes = [
    'Exception: ',
    'ApiException: ',
    'FormatException: ',
    'Error: ',
  ];

  var changed = true;
  while (changed) {
    changed = false;
    for (final prefix in prefixes) {
      if (result.startsWith(prefix)) {
        result = result.substring(prefix.length).trim();
        changed = true;
      }
    }
  }

  final failedPrefix = RegExp(r'^(GET|POST|PUT|PATCH|DELETE)\s+\S+\s+failed:\s+', caseSensitive: false);
  while (failedPrefix.hasMatch(result)) {
    result = result.replaceFirst(failedPrefix, '').trim();
  }

  return result;
}

String _stripHttpPrefix(String message) {
  return message.replaceFirst(RegExp(r'^HTTP\s+\d{3}:\s*'), '');
}
