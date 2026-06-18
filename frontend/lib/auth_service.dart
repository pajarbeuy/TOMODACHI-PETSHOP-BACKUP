import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'api_client.dart';

/// User model
class UserModel {
  final String id;
  final String name;
  final String email;
  final String role;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: (json['role'] is Map)
          ? json['role']['name'] ?? 'user'
          : json['role']?.toString() ?? 'user',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'role': role,
  };
}

class CaptchaChallenge {
  final String key;
  final String question;

  const CaptchaChallenge({required this.key, required this.question});

  factory CaptchaChallenge.fromJson(Map<String, dynamic> json) {
    return CaptchaChallenge(
      key: json['captcha_key']?.toString() ?? '',
      question: json['question']?.toString() ?? '',
    );
  }
}

/// Authentication Service
class AccountModel {
  final String id;
  final String name;
  final String email;
  final String roleName;

  const AccountModel({
    required this.id,
    required this.name,
    required this.email,
    required this.roleName,
  });

  factory AccountModel.fromJson(Map<String, dynamic> json) {
    final role = json['role'];
    return AccountModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      roleName: role is Map
          ? role['name']?.toString() ?? 'user'
          : role?.toString() ?? 'user',
    );
  }
}

class AuthService extends ChangeNotifier {
  late final ApiClient _apiClient;
  late final FlutterSecureStorage _secureStorage;
  UserModel? _currentUser;
  String? _token;
  bool _isLoading = false;
  String? _errorMessage;

  bool get isAuthenticated => _token != null && _currentUser != null;
  UserModel? get currentUser => _currentUser;
  String? get token => _token;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  ApiClient get apiClient => _apiClient;

  /// Initialize auth service with API base URL
  void initialize(String baseUrl) {
    _apiClient = ApiClient(baseUrl);
    _secureStorage = const FlutterSecureStorage();
  }

  /// Login with email and password
  Future<CaptchaChallenge> fetchCaptcha() async {
    final response = await _apiClient.get('/api/auth/captcha');
    final data = response['data'];

    if (response['status'] == true && data is Map<String, dynamic>) {
      return CaptchaChallenge.fromJson(data);
    }

    throw Exception(response['message'] ?? 'Failed to load captcha');
  }

  Future<bool> login(
    String email,
    String password, {
    required String captchaKey,
    required String captchaAnswer,
    bool rememberMe = false,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiClient.post(
        '/api/auth/login',
        body: {
          'email': email,
          'password': password,
          'captcha_key': captchaKey,
          'captcha_answer': captchaAnswer,
          'remember_me': rememberMe,
        },
      );

      if (response['status'] == true) {
        final data = response['data'];
        final token = data['token'] as String?;
        final userData = data['user'];

        if (token != null) {
          _token = token;
          _apiClient.setToken(token);
          _currentUser = UserModel.fromJson(userData);

          // On insecure Flutter Web origins, secure storage can be unavailable.
          // Keep the in-memory session usable even when persistence fails.
          try {
            await _secureStorage.write(key: 'auth_token', value: token);
          } catch (e) {
            if (!kIsWeb) {
              rethrow;
            }
            debugPrint('Token persistence skipped on web: $e');
          }

          _isLoading = false;
          notifyListeners();
          return true;
        }
      }

      _errorMessage = response['message'] ?? 'Login failed';
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'Error: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Logout and revoke token
  Future<bool> logout() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiClient.post('/api/auth/logout');

      if (response['status'] == true) {
        _token = null;
        _currentUser = null;
        _apiClient.clearToken();

        // Remove token from secure storage
        await _secureStorage.delete(key: 'auth_token');

        _isLoading = false;
        notifyListeners();
        return true;
      }

      _errorMessage = response['message'] ?? 'Logout failed';
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'Error: ${e.toString()}';
      // Still clear local token even if API call fails
      _token = null;
      _currentUser = null;
      _apiClient.clearToken();
      await _secureStorage.delete(key: 'auth_token');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<List<AccountModel>> getAccounts() async {
    final response = await _apiClient.get('/api/auth/accounts');

    if (response['status'] == true && response['data'] is List) {
      return (response['data'] as List)
          .whereType<Map<String, dynamic>>()
          .map(AccountModel.fromJson)
          .toList();
    }

    throw Exception(response['message'] ?? 'Failed to load accounts');
  }

  Future<bool> updateAccount({
    required String userId,
    String? name,
    String? email,
    String? password,
    String? passwordConfirmation,
    int? roleId,
  }) async {
    final body = <String, dynamic>{};
    if (name != null) body['name'] = name;
    if (email != null) body['email'] = email;
    if (password != null && password.isNotEmpty) {
      body['password'] = password;
      body['password_confirmation'] = passwordConfirmation;
    }
    if (roleId != null) body['role_id'] = roleId;

    final response = await _apiClient.put('/api/auth/accounts/$userId', body: body);
    return response['status'] == true;
  }

  Future<bool> deleteAccount(String userId) async {
    final response = await _apiClient.delete('/api/auth/accounts/$userId');
    return response['status'] == true;
  }

  /// Register a new user (only for owner role)
  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    required int roleId,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiClient.post(
        '/api/auth/register',
        body: {
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': passwordConfirmation,
          'role_id': roleId,
        },
      );

      if (response['status'] == true) {
        _isLoading = false;
        notifyListeners();
        return true;
      }

      _errorMessage = response['message'] ?? 'Registration failed';
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'Error: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Get current authenticated user
  Future<bool> getCurrentUser() async {
    if (_token == null) {
      return false;
    }

    try {
      final response = await _apiClient.get('/api/auth/me');

      if (response['status'] == true) {
        final userData = response['data']['user'];
        _currentUser = UserModel.fromJson(userData);
        notifyListeners();
        return true;
      }

      return false;
    } catch (e) {
      _errorMessage = 'Error: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  /// Restore token from secure storage (call on app startup)
  Future<bool> restoreTokenFromStorage() async {
    try {
      final token = await _secureStorage.read(key: 'auth_token');

      if (token != null && token.isNotEmpty) {
        _token = token;
        _apiClient.setToken(token);

        // Fetch current user data
        final success = await getCurrentUser();
        if (success) {
          notifyListeners();
          return true;
        }
      }
      return false;
    } catch (e) {
      _errorMessage = 'Error restoring token: ${e.toString()}';
      return false;
    }
  }

  /// Restore token from memory (for testing)
  void restoreToken(String token) {
    _token = token;
    _apiClient.setToken(token);
    notifyListeners();
  }

  /// Clear all auth data
  void clearAuth() {
    _token = null;
    _currentUser = null;
    _errorMessage = null;
    _apiClient.clearToken();
    notifyListeners();
  }
}
