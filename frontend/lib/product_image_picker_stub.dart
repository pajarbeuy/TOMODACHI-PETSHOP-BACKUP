import 'package:image_picker/image_picker.dart';

const int maxFileSizeBytes = 2 * 1024 * 1024; // 2 MB

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

class ImageTooLargeException implements Exception {
  final int sizeInBytes;
  ImageTooLargeException(this.sizeInBytes);

  @override
  String toString() =>
      'Image size ${(sizeInBytes / 1024 / 1024).toStringAsFixed(2)} MB exceeds the 2 MB limit';
}

Future<ProductImageSelection?> pickProductImage() async {
  final picker = ImagePicker();

  final XFile? file = await picker.pickImage(
    source: ImageSource.gallery,
    imageQuality: 80,
    maxWidth: 1024,
  );

  if (file == null) return null;

  final bytes = await file.readAsBytes();

  if (bytes.length > maxFileSizeBytes) {
    throw ImageTooLargeException(bytes.length);
  }

  return ProductImageSelection(
    bytes: bytes,
    name: file.name,
    mimeType: file.mimeType ?? 'image/jpeg',
  );
}