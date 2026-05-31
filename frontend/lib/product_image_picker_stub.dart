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
  return null;
}
