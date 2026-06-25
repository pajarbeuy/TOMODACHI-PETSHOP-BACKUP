import 'api_client.dart';

class CategoryService {
  final ApiClient _client;

  CategoryService(this._client);

  Future<List<Map<String, dynamic>>> getCategories() async {
    final response = await _client.get('/api/categories');
    final data = response['data'];
    if (response['status'] == true && data is List) {
      return data.whereType<Map>().map(Map<String, dynamic>.from).toList();
    }
    throw ApiException(response['message'] ?? 'Gagal memuat kategori');
  }

  Future<void> createCategory({
    required String name,
    required String animalType,
    required String subCategory,
    String? description,
  }) async {
    final response = await _client.post('/api/categories', body: {
      'name': name,
      'animal_type': animalType,
      'sub_category': subCategory,
      'description': description ?? '',
    });
    if (response['status'] != true) {
      throw ApiException(response['message'] ?? 'Gagal membuat kategori');
    }
  }

  Future<void> updateCategory({
    required String id,
    required String name,
    required String animalType,
    required String subCategory,
    String? description,
  }) async {
    final response = await _client.put('/api/categories/$id', body: {
      'name': name,
      'animal_type': animalType,
      'sub_category': subCategory,
      'description': description ?? '',
    });
    if (response['status'] != true) {
      throw ApiException(response['message'] ?? 'Gagal mengubah kategori');
    }
  }

  Future<void> deleteCategory(String id) async {
    final response = await _client.delete('/api/categories/$id');
    if (response['status'] != true) {
      throw ApiException(response['message'] ?? 'Gagal menghapus kategori');
    }
  }
}
