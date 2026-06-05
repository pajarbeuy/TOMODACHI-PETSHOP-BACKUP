# 📱 Frontend Documentation - Flutter App

## Table of Contents
1. [Project Setup](#project-setup)
2. [Architecture](#architecture)
3. [File Structure](#file-structure)
4. [Screens & Components](#screens--components)
5. [Services](#services)
6. [State Management](#state-management)
7. [HTTP Client Configuration](#http-client-configuration)
8. [Development Guide](#development-guide)

---

## Project Setup

### Prerequisites

```bash
# Check Flutter version
flutter --version

# Should be 3.x or higher
# Required: Dart SDK 3.0+, Flutter 3.x+
```

### Installation

```bash
# Navigate to frontend folder
cd frontend

# Get dependencies
flutter pub get

# Check for issues
flutter doctor
flutter analyze

# Run the app
flutter run

# Build APK (Android)
flutter build apk

# Build iOS app
flutter build ios

# Build Web
flutter build web
```

### Supported Platforms

- ✅ Android (5.0+)
- ✅ iOS (11.0+)
- ✅ Web (Chrome, Firefox, Safari)
- ✅ Linux (desktop)
- ✅ Windows (desktop)
- ✅ macOS (desktop)

---

## Architecture

### Clean Architecture + MVC Pattern

```
┌─────────────────────────────────────┐
│      Presentation Layer             │
│   (Screens, Widgets, UI)            │
└──────────────────┬──────────────────┘
                   │
┌──────────────────▼──────────────────┐
│      Business Logic Layer           │
│   (Services, State Management)      │
└──────────────────┬──────────────────┘
                   │
┌──────────────────▼──────────────────┐
│      Data Layer                     │
│   (API Client, Local Storage)       │
└──────────────────┬──────────────────┘
                   │
┌──────────────────▼──────────────────┐
│      External Services              │
│   (REST API, Payment Gateway)       │
└─────────────────────────────────────┘
```

### Design Patterns

- **MVC**: Model-View-Controller
- **Provider Pattern**: State management
- **Singleton**: API client instances
- **Repository**: Data access abstraction
- **Service**: Business logic encapsulation

---

## File Structure

```
frontend/lib/
├── main.dart                           # App entry point
│
├── api_client_io.dart                 # HTTP client (iOS/Android)
├── api_client_web.dart                # HTTP client (Web)
├── api_client.dart                    # Conditional export
│
├── screens/                           # UI Screens
│   ├── login_screen.dart
│   ├── home_screen.dart
│   └── tabs/
│       ├── dashboard_tab.dart         # Analytics & KPI
│       ├── pos_tab.dart               # Point of Sale
│       ├── products_tab.dart          # Product Management
│       ├── categories_tab.dart
│       └── reports_tab.dart
│
├── services/                          # Business Logic
│   ├── auth_service.dart              # Authentication
│   ├── product_service.dart           # Product operations
│   ├── transaction_service.dart       # Sales & transactions
│   ├── dashboard_service.dart         # Analytics
│   ├── category_service.dart          # Category operations
│   └── payment_service.dart           # Payment processing
│
├── widgets/                           # Reusable UI Components
│   ├── common_widgets.dart
│   ├── custom_buttons.dart
│   ├── form_fields.dart
│   └── dialogs.dart
│
├── models/                            # Data Models
│   ├── user.dart
│   ├── product.dart
│   ├── transaction.dart
│   ├── category.dart
│   └── api_response.dart
│
├── utils/                             # Helper Functions
│   ├── constants.dart                 # App constants
│   ├── extensions.dart                # Extension methods
│   └── validators.dart                # Form validators
│
├── payment_url_launcher.dart          # Payment integration
├── product_image_picker.dart          # Image selection
│
└── test/                              # Unit & Widget Tests
    ├── services_test.dart
    └── widget_test.dart
```

---

## Screens & Components

### 1. Login Screen
**File**: `screens/login_screen.dart`

**Features**:
- Email & password input
- Validation
- Error handling
- Token storage (flutter_secure_storage)
- Biometric support (optional)

**Flow**:
```
1. User enters credentials
2. Call AuthService.login()
3. Receive token from backend
4. Store token securely
5. Navigate to HomeScreen
```

### 2. Home Screen
**File**: `screens/home_screen.dart`

**Features**:
- Bottom navigation with 4 tabs
- User profile display
- Role-based UI
- Logout functionality

**Tabs**:
1. Dashboard Tab - Analytics & KPI
2. POS Tab - Point of Sale
3. Products Tab - Inventory management
4. Reports Tab - Sales reports (optional)

### 3. Dashboard Tab
**File**: `screens/tabs/dashboard_tab.dart`

**Displays**:
- Today's sales
- Transaction count
- Top products
- Category breakdown
- Sales trend chart

**Services Used**:
- `DashboardService.getAnalytics()`

### 4. POS Tab (Point of Sale)
**File**: `screens/tabs/pos_tab.dart`

**Features**:
- Product search
- Add to cart
- Cart management
- Payment method selection
- Checkout with receipt

**Flow**:
```
1. Search/Browse products
2. Add items to cart
3. Review cart
4. Select payment method
5. Process payment
6. Print/Share receipt
```

### 5. Products Tab
**File**: `screens/tabs/products_tab.dart`

**Features**:
- View all products
- Create product
- Edit product
- Delete product
- Image upload
- Category filter

**Permissions**:
- Owner/Manager: CRUD operations
- Cashier: View only

### 6. Categories Tab
**File**: `screens/tabs/categories_tab.dart`

**Features**:
- View categories by animal type
- View sub-categories
- Create category (Owner)
- Delete category (Owner)

---

## Services

### 1. AuthService
**File**: `services/auth_service.dart`

```dart
class AuthService {
  // Login with email & password
  Future<ApiResponse> login(String email, String password)
  
  // Logout current user
  Future<void> logout()
  
  // Get current user info
  Future<User> getCurrentUser()
  
  // Check if user is logged in
  bool isLoggedIn()
  
  // Get stored token
  String? getToken()
  
  // Clear all auth data
  Future<void> clearAuthData()
}
```

### 2. ProductService
**File**: `services/product_service.dart`

```dart
class ProductService {
  // Get all products (with pagination & filters)
  Future<ApiResponse> getProducts({
    int page = 1,
    int perPage = 15,
    String? search,
    int? categoryId,
    String? animalType,
    String? subCategory,
  })
  
  // Get single product
  Future<ApiResponse> getProduct(int productId)
  
  // Create new product
  Future<ApiResponse> createProduct(Map<String, dynamic> data)
  
  // Update product
  Future<ApiResponse> updateProduct(int productId, Map<String, dynamic> data)
  
  // Delete product
  Future<ApiResponse> deleteProduct(int productId)
  
  // Upload product image
  Future<ApiResponse> uploadProductImage(File imageFile, int productId)
}
```

### 3. TransactionService
**File**: `services/transaction_service.dart`

```dart
class TransactionService {
  // Create transaction (checkout)
  Future<ApiResponse> createTransaction({
    required List<CartItem> items,
    required String paymentMethod,
    required double totalAmount,
    required double amountPaid,
  })
  
  // Get transaction history
  Future<ApiResponse> getTransactions({
    int page = 1,
    DateTime? dateFrom,
    DateTime? dateTo,
  })
  
  // Get single transaction
  Future<ApiResponse> getTransaction(int transactionId)
  
  // Payment methods
  Future<void> processPayment(String method, double amount)
}
```

### 4. DashboardService
**File**: `services/dashboard_service.dart`

```dart
class DashboardService {
  // Get all analytics data
  Future<ApiResponse> getAnalytics()
  
  // Returns:
  // - KPI (today sales, transactions, monthly sales)
  // - Top products
  // - Category breakdown
  // - Sales trend
}
```

### 5. CategoryService
**File**: `services/category_service.dart`

```dart
class CategoryService {
  // Get all categories
  Future<ApiResponse> getCategories()
  
  // Create category (Owner only)
  Future<ApiResponse> createCategory({
    required String animalType,
    required String subCategory,
  })
  
  // Delete category (Owner only)
  Future<ApiResponse> deleteCategory(int categoryId)
}
```

---

## State Management

### Provider Pattern

The app uses **Provider** package for state management.

#### Key Concepts

1. **ChangeNotifier**: Base class for observable objects
2. **Provider**: Provides instances to widgets
3. **Consumer**: Listens to changes
4. **MultiProvider**: Multiple providers at once

#### Example Usage

```dart
// Define provider
final authServiceProvider = Provider((ref) => AuthService());

// Use in widget
Consumer<AuthService>(
  builder: (context, authService, child) {
    return Text(authService.getCurrentUser().name);
  },
)
```

#### Best Practices

1. Use `Provider` for single instances
2. Use `ChangeNotifierProvider` for observable state
3. Use `Consumer` or `Watch` in build methods
4. Separate business logic from UI

---

## HTTP Client Configuration

### Platform-Specific Clients

#### For iOS/Android (api_client_io.dart)
```dart
class ApiClient {
  final String baseUrl;
  late final Dio _dio;
  
  ApiClient(this.baseUrl) {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: Duration(seconds: 30),
      receiveTimeout: Duration(seconds: 30),
    ));
    
    // Add interceptors
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) => _addAuthHeader(options),
      onError: (error, handler) => _handleError(error),
    ));
  }
}
```

#### For Web (api_client_web.dart)
```dart
class ApiClient {
  // Uses XMLHttpRequest for web platform
  // Handles CORS requests
  // Returns Completer-based futures
}
```

#### Conditional Export (api_client.dart)
```dart
export 'api_client_io.dart'
    if (dart.library.html) 'api_client_web.dart';
```

### Base URLs Configuration

```dart
// Android Emulator
const baseUrlAndroid = 'http://10.0.2.2:8000';

// iOS Simulator
const baseUrlIOS = 'http://localhost:8000';

// Web
const baseUrlWeb = 'http://localhost:8000';

// Production
const baseUrlProd = 'https://api.tomodachi-petshop.com';
```

### Request Headers

```dart
{
  'Accept': 'application/json',
  'Content-Type': 'application/json',
  'Authorization': 'Bearer $token',  // If authenticated
}
```

---

## Dependencies

### pubspec.yaml

```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # HTTP & API
  dio: ^5.3.0              # HTTP client
  
  # State Management
  provider: ^6.0.0
  
  # Local Storage
  flutter_secure_storage: ^9.2.2
  shared_preferences: ^2.2.0
  
  # UI & Design
  google_fonts: ^6.2.1
  cupertino_icons: ^1.0.8
  
  # Payment Gateway
  midtrans_sdk: ^2.0.0
  
  # Utilities
  intl: ^0.19.0
  uuid: ^4.0.0
  
  # Image Handling
  image_picker: ^1.0.0
  
  # URL Launcher
  url_launcher: ^6.3.1

dev_dependencies:
  flutter_test:
    sdk: flutter
  
  flutter_lints: ^3.0.0
```

---

## Development Guide

### Running the App

```bash
# Run on default device
flutter run

# Run on specific device
flutter run -d <device_id>

# Run with verbose logs
flutter run -v

# Run in debug mode
flutter run --debug

# Run in release mode
flutter run --release
```

### Building

```bash
# Clean build
flutter clean
flutter pub get

# Build APK
flutter build apk --release

# Build App Bundle (Google Play)
flutter build appbundle

# Build iOS
flutter build ios --release

# Build Web
flutter build web --release

# Build Linux
flutter build linux --release

# Build Windows
flutter build windows --release
```

### Testing

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/services_test.dart

# Run tests with coverage
flutter test --coverage

# Run tests in watch mode
flutter test --watch
```

### Debugging

```bash
# Debug mode with DevTools
flutter run -d chrome --web-port=7357

# Analyze code
flutter analyze

# Check code format
flutter format lib/

# Format code
dart format lib/ -i

# Generate splash screen
flutter pub get
flutter pub run flutter_native_splash:create
```

### Common Issues & Solutions

1. **Cannot Connect to API**
   - Verify base URL: `http://10.0.2.2:8000` for Android emulator
   - Check API server is running
   - Verify CORS settings on backend

2. **Build Errors**
   ```bash
   flutter clean
   flutter pub get
   flutter pub upgrade
   ```

3. **Hot Reload Not Working**
   ```bash
   flutter run -v
   # Check for compilation errors
   ```

4. **State Not Updating**
   - Ensure using `Consumer` or `Watch` in build method
   - Verify `notifyListeners()` is called
   - Check Provider scope

5. **Image Not Loading**
   - Verify image URL is accessible
   - Check image permissions
   - Verify image format (JPG, PNG)

---

## Best Practices

### Code Style

1. **Naming Conventions**
   - Classes: `PascalCase`
   - Methods: `camelCase`
   - Constants: `camelCase` with `const` keyword
   - Private members: `_leadingUnderscore`

2. **File Organization**
   - One class per file (usually)
   - Related classes in same file (models, enums)
   - Imports organized: dart, package, local

3. **Comments**
   ```dart
   /// Documentation comment for public API
   /// - Use triple slash
   /// - Appears in IDE autocomplete
   
   // Regular comment
   // Use for implementation details
  ```

### Performance Optimization

1. **Image Optimization**
   - Use appropriate image sizes
   - Cache images where possible
   - Use `ImageCache` configuration

2. **State Management**
   - Keep Provider scopes narrow
   - Use `select()` for specific values
   - Avoid rebuilding entire widget tree

3. **Network Requests**
   - Implement pagination
   - Cache responses
   - Cancel requests when widget disposes

### Security

1. **Token Storage**
   - Use `flutter_secure_storage`
   - Never store tokens in SharedPreferences
   - Clear tokens on logout

2. **Input Validation**
   - Validate all user inputs
   - Use form validators
   - Display clear error messages

3. **API Communication**
   - Always use HTTPS in production
   - Implement certificate pinning
   - Validate SSL certificates

---

## Useful Resources

- **Flutter Documentation**: https://flutter.dev/docs
- **Dart Documentation**: https://dart.dev/docs
- **Provider Package**: https://pub.dev/packages/provider
- **Dio Package**: https://pub.dev/packages/dio
- **Material Design**: https://material.io/design

---

**Last Updated**: 2024-06-05
**Version**: 1.0.0
