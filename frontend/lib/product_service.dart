import 'api_client.dart';

class ProductService {
  final ApiClient _client;

  ProductService(this._client);

  String resolveImageUrl(String value) {
    // The /storage/ path is served as a static file by PHP's built-in dev
    // server (and by Apache/Nginx in production) without passing through
    // Laravel middleware, so CORS headers are never added.
    //
    // The backend exposes a dedicated proxy route:
    //   GET /api/product-images/{path}
    // which streams the file from Storage::disk('public') and explicitly sets
    // the required Access-Control-Allow-Origin header.
    //
    // We rewrite /storage/... URLs to go through that proxy so that
    // Flutter Web can load images cross-origin without a CORS error.
    final uri = Uri.tryParse(value);
    if (uri != null && uri.hasScheme) {
      // Absolute URL — extract just the path portion and rewrite if needed
      final path = uri.path;
      if (path.startsWith('/storage/')) {
        final storagePath = path.substring('/storage/'.length);
        return _client.resolveUrl('/api/product-images/$storagePath');
      }
      return value;
    }

    // Relative path
    final normalised = value.startsWith('/') ? value : '/$value';
    if (normalised.startsWith('/storage/')) {
      final storagePath = normalised.substring('/storage/'.length);
      return _client.resolveUrl('/api/product-images/$storagePath');
    }

    return _client.resolveUrl(value);
  }

  /// Fetch products with optional search and filters
  Future<Map<String, dynamic>> getProducts({
    String? search,
    String? categoryId,
    String? animalType,
    String? subCategory,
    String? channel,
    bool? inStock,
    int page = 1,
    int perPage = 15,
  }) async {
    final Map<String, String> queryParams = {};
    if (search != null && search.isNotEmpty) queryParams['search'] = search;
    if (categoryId != null && categoryId.isNotEmpty) queryParams['category_id'] = categoryId;
    if (animalType != null && animalType.isNotEmpty) queryParams['animal_type'] = animalType;
    if (subCategory != null && subCategory.isNotEmpty) queryParams['sub_category'] = subCategory;
    if (channel != null && channel.isNotEmpty) queryParams['channel'] = channel;
    if (inStock != null) queryParams['in_stock'] = inStock ? 'true' : 'false';
    queryParams['page'] = page.toString();
    queryParams['per_page'] = perPage.toString();

    final queryString = Uri(queryParameters: queryParams).query;
    return await _client.get('/api/products?$queryString');
  }

  /// Get product detail
  Future<Map<String, dynamic>> getProductDetail(String id) async {
    return await _client.get('/api/products/$id');
  }

  /// Find product by barcode
  Future<Map<String, dynamic>> findByBarcode(String barcode) async {
    return await _client.get('/api/products/barcode/$barcode');
  }

  /// Get grouped animal and sub-categories
  Future<Map<String, dynamic>> getCategories() async {
    return await _client.get('/api/products/categories');
  }

  /// Create a new product with optional image upload
  Future<Map<String, dynamic>> createProduct({
    required String name,
    String? sku,
    String? barcode,
    required String categoryId,
    required double buyPrice,
    required double sellPrice,
    required int offlineQty,
    required int onlineQty,
    required int minThreshold,
    String? description,
    String? imageUrl,
    List<int>? imageBytes,
    String? imageName,
    String? imageMimeType,
    bool confirmPriceBelowCost = false,
  }) async {
    final fields = {
      'name': name,
      'category_id': categoryId,
      'buy_price': buyPrice.toString(),
      'sell_price': sellPrice.toString(),
      'offline_qty': offlineQty.toString(),
      'online_qty': onlineQty.toString(),
      'min_threshold': minThreshold.toString(),
      'description': description ?? '',
      'confirm_price_below_cost': confirmPriceBelowCost ? 'true' : 'false',
    };
    if (sku != null && sku.trim().isNotEmpty) {
      fields['sku'] = sku.trim();
    }
    if (barcode != null && barcode.trim().isNotEmpty) {
      fields['barcode'] = barcode.trim();
    }
    if (imageUrl != null) fields['image_url'] = imageUrl;

    return await _client.postMultipart(
      '/api/products',
      fields: fields,
      fileBytes: imageBytes,
      fileName: imageName,
      fileContentType: imageMimeType ?? 'image/jpeg',
    );
  }

  /// Update an existing product with optional image upload
  Future<Map<String, dynamic>> updateProduct({
    required String id,
    required String name,
    required String sku,
    String? barcode,
    required String categoryId,
    required double buyPrice,
    required double sellPrice,
    required int offlineQty,
    required int onlineQty,
    required int minThreshold,
    String? description,
    String? imageUrl,
    List<int>? imageBytes,
    String? imageName,
    String? imageMimeType,
    bool confirmPriceBelowCost = false,
  }) async {
    final fields = {
      'name': name,
      'sku': sku,
      'category_id': categoryId,
      'buy_price': buyPrice.toString(),
      'sell_price': sellPrice.toString(),
      'offline_qty': offlineQty.toString(),
      'online_qty': onlineQty.toString(),
      'min_threshold': minThreshold.toString(),
      'description': description ?? '',
      'confirm_price_below_cost': confirmPriceBelowCost ? 'true' : 'false',
    };
    if (barcode != null && barcode.trim().isNotEmpty) {
      fields['barcode'] = barcode.trim();
    }
    if (imageUrl != null) fields['image_url'] = imageUrl;

    // Dedicated POST update route keeps multipart uploads compatible with Laravel.
    return await _client.postMultipart(
      '/api/products/$id/update',
      fields: fields,
      fileBytes: imageBytes,
      fileName: imageName,
      fileContentType: imageMimeType ?? 'image/jpeg',
    );
  }

  /// Soft delete product
  Future<Map<String, dynamic>> deleteProduct(String id) async {
    return await _client.delete('/api/products/$id');
  }
}

