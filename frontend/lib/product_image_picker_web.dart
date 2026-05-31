import 'dart:async';
import 'dart:html' as html;
import 'dart:typed_data';

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
  final input = html.FileUploadInputElement()
    ..accept = 'image/jpeg,image/png'
    ..multiple = false;

  final completer = Completer<ProductImageSelection?>();

  input.onChange.first.then((_) {
    final file = input.files?.isNotEmpty == true ? input.files!.first : null;
    if (file == null) {
      completer.complete(null);
      return;
    }

    final reader = html.FileReader();
    reader.onError.first.then((_) {
      if (!completer.isCompleted) {
        completer.completeError(Exception('Gagal membaca file gambar.'));
      }
    });
    reader.onLoad.first.then((_) {
      final result = reader.result;
      final bytes = result is ByteBuffer
          ? Uint8List.view(result).toList()
          : (result as Uint8List).toList();

      if (!completer.isCompleted) {
        completer.complete(
          ProductImageSelection(
            bytes: bytes,
            name: file.name,
            mimeType: file.type,
          ),
        );
      }
    });
    reader.readAsArrayBuffer(file);
  });

  input.click();
  return completer.future;
}
