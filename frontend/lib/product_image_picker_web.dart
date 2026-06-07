import 'dart:async';
import 'dart:typed_data';
import 'dart:js_interop';
import 'package:web/web.dart' as web;

class ProductImageSelection {
  const ProductImageSelection({
    required this.bytes,
    required this.name,
    required this.mimeType,
  });

  final List<int> bytes;
  final String name;
  final String mimeType;

  int get sizeInBytes => bytes.length;
}

Future<ProductImageSelection?> pickProductImage() async {
  final input = web.HTMLInputElement()
    ..type = 'file'
    ..accept = 'image/jpeg,image/png';

  final completer = Completer<ProductImageSelection?>();

  input.onChange.listen((_) async {
    final files = input.files;
    final file = files != null && files.length > 0 ? files.item(0) : null;
    if (file == null) {
      completer.complete(null);
      return;
    }

    try {
      final buffer = await file.arrayBuffer().toDart;
      final bytes = Uint8List.view(buffer.toDart).toList();

      if (!completer.isCompleted) {
        completer.complete(
          ProductImageSelection(
            bytes: bytes,
            name: file.name,
            mimeType: file.type,
          ),
        );
      }
    } catch (_) {
      if (!completer.isCompleted) {
        completer.completeError(Exception('Gagal membaca file gambar.'));
      }
    }
  });

  input.click();
  return completer.future;
}
