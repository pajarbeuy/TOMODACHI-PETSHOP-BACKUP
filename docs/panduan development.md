# 🛠️ Development Guide

## Table of Contents
1. [Development Environment](#development-environment)
2. [Git Workflow](#git-workflow)
3. [Code Standards](#code-standards)
4. [Testing Guide](#testing-guide)
5. [Debugging Tips](#debugging-tips)
6. [Common Tasks](#common-tasks)
7. [Deployment Checklist](#deployment-checklist)

---

## Development Environment

### IDE Recommendations

#### Visual Studio Code (Recommended)
```bash
# Install extensions:
- PHP Intelephense
- Laravel Extension Pack
- Dart
- Flutter
- REST Client
- MySQL
- Git Graph
```

#### PhpStorm
- Professional IDE for PHP/Laravel
- Excellent debugging support
- Built-in database tools

#### Android Studio
- For Flutter/Android development
- Includes emulator
- Built-in profiling tools

### Environment Setup

```bash
# Clone and setup
git clone <repo-url>
cd Project-Tomodachi-Pet-Shop

# Backend setup
cd backend
composer install
cp .env.example .env
php artisan key:generate
php artisan migrate
php artisan db:seed

# Frontend setup
cd ../frontend
flutter pub get
flutter doctor
```

### Local Configuration

**backend/.env** (Development)
```env
APP_ENV=local
APP_DEBUG=true
DB_HOST=127.0.0.1
DB_DATABASE=tomodachi_petshop
SANCTUM_STATEFUL_DOMAINS=localhost:3000,10.0.2.2:3000
```

**frontend/lib/config/api_config.dart** (Development)
```dart
// Android Emulator
const String apiBaseUrl = 'http://10.0.2.2:8000';

// iOS Simulator
// const String apiBaseUrl = 'http://localhost:8000';

// Web/Desktop
// const String apiBaseUrl = 'http://localhost:8000';
```

---

## Git Workflow

### Branch Naming Convention

```
feature/feature-name          # New features
bugfix/issue-description      # Bug fixes
hotfix/critical-fix           # Critical production fixes
refactor/code-section         # Code refactoring
docs/documentation-section    # Documentation
test/test-name               # Tests
```

### Commit Message Format

```
<type>(<scope>): <subject>

<body>

<footer>
```

**Types**:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation
- `style`: Code style changes
- `refactor`: Code refactoring
- `test`: Adding tests
- `chore`: Build/dependency updates

**Examples**:
```bash
feat(auth): add biometric login support
fix(products): resolve null reference in image loading
docs(api): update authentication documentation
refactor(pos): optimize cart calculation
test(transactions): add payment processing tests
```

### Workflow Steps

```bash
# 1. Create feature branch
git checkout -b feature/add-product-search

# 2. Make changes and commit
git add .
git commit -m "feat(products): add product search with filters"

# 3. Push to remote
git push origin feature/add-product-search

# 4. Create Pull Request
# Go to GitHub/GitLab and create PR
# - Write description
# - Request reviewers
# - Wait for approval

# 5. After approval, merge to main
git checkout main
git pull origin main
git merge feature/add-product-search
git push origin main

# 6. Delete feature branch
git branch -d feature/add-product-search
git push origin --delete feature/add-product-search
```

### Conflict Resolution

```bash
# If conflicts occur during merge
git status  # See conflicted files

# Edit conflicted files manually or use:
git mergetool

# After resolving
git add .
git commit -m "merge: resolve conflicts from feature/xxx"
git push origin main
```

---

## Code Standards

### PHP/Laravel Standards

#### Naming Conventions

```php
// Classes: PascalCase
class ProductController { }
class StockService { }

// Methods: camelCase
public function getProduct() { }
public function updateProductPrice() { }

// Constants: UPPER_SNAKE_CASE
const MAX_FILE_SIZE = 5242880;
const DEFAULT_PAGE_LIMIT = 15;

// Variables: camelCase
$userId = 1;
$productName = "Dog Food";

// Private/Protected: _leadingUnderscore
private $_internalState;
protected $_userId;
```

#### Code Style

```php
// Follow PSR-12 coding standards

// Proper spacing
public function store(Request $request)
{
    $data = $request->validate([
        'name' => 'required|string',
        'email' => 'required|email|unique:users',
    ]);
    
    $user = User::create($data);
    
    return response()->json($user, 201);
}

// Use meaningful variable names
// ❌ Bad
$x = Product::find(1);
$y = $x->sp * 0.85;

// ✅ Good
$product = Product::find(1);
$discountedPrice = $product->sell_price * 0.85;

// Add documentation comments
/**
 * Create a new product
 *
 * @param Request $request
 * @return JsonResponse
 * @throws ValidationException
 */
public function store(Request $request): JsonResponse
```

### Dart/Flutter Standards

#### Naming Conventions

```dart
// Classes: PascalCase
class ProductService { }
class LoginScreen extends StatefulWidget { }

// Methods/Functions: camelCase
void fetchProducts() { }
String formatPrice(double price) { }

// Constants: camelCase with const
const String appName = 'Tomodachi Pet Shop';
const int defaultPageSize = 15;

// Variables: camelCase
String userName = 'John';
int productId = 1;

// Private/Protected: _leadingUnderscore
String _privateVariable;
void _privateMethod() { }

// Getters: camelCase (no 'get' prefix)
int get totalItems => _items.length;
```

#### Code Style

```dart
// Follow Dart style guide

// Proper formatting
class ProductService {
  final ApiClient apiClient;
  
  ProductService(this.apiClient);
  
  // Documentation comments
  /// Fetch all products with optional filters
  /// 
  /// Parameters:
  /// - [page]: Page number (default: 1)
  /// - [search]: Search term (optional)
  /// 
  /// Returns: List of products
  Future<List<Product>> fetchProducts({
    int page = 1,
    String? search,
  }) async {
    final response = await apiClient.get(
      '/products',
      queryParameters: {
        'page': page,
        if (search != null) 'search': search,
      },
    );
    
    return (response.data['data'] as List)
        .map((p) => Product.fromJson(p))
        .toList();
  }
}

// Use null safety
String? nullable;
String nonNull = 'required';

// Use meaningful variable names
// ❌ Bad
final x = p.sp * q;

// ✅ Good
final totalPrice = product.sellPrice * quantity;
```

---

## Testing Guide

### Backend Testing

#### Unit Tests

```bash
# Run all tests
php artisan test

# Run specific test file
php artisan test tests/Feature/AuthTest.php

# Run specific test method
php artisan test tests/Feature/AuthTest.php --filter=testLoginSuccess

# Run with coverage
php artisan test --coverage
```

**Example Test**:
```php
<?php

namespace Tests\Feature;

use Tests\TestCase;
use App\Models\User;

class AuthTest extends TestCase
{
    public function testLoginSuccess()
    {
        $user = User::factory()->create([
            'email' => 'test@example.com',
            'password' => bcrypt('password123'),
        ]);
        
        $response = $this->postJson('/api/auth/login', [
            'email' => 'test@example.com',
            'password' => 'password123',
        ]);
        
        $response->assertStatus(200)
                 ->assertJsonStructure([
                     'status',
                     'message',
                     'data' => ['user', 'token'],
                 ]);
    }
    
    public function testLoginFailed()
    {
        $response = $this->postJson('/api/auth/login', [
            'email' => 'nonexistent@example.com',
            'password' => 'wrongpassword',
        ]);
        
        $response->assertStatus(401);
    }
}
```

### Frontend Testing

#### Widget Tests

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/services/auth_service_test.dart

# Run with coverage
flutter test --coverage
```

**Example Test**:
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:frontendd/services/auth_service.dart';

void main() {
  group('AuthService', () {
    late AuthService authService;
    
    setUp(() {
      authService = AuthService();
    });
    
    test('Login with valid credentials', () async {
      // Arrange
      const email = 'test@example.com';
      const password = 'password123';
      
      // Act
      final result = await authService.login(email, password);
      
      // Assert
      expect(result, isNotNull);
      expect(result['status'], true);
    });
    
    test('Login with invalid credentials', () async {
      // Act & Assert
      expect(
        () => authService.login('invalid@example.com', 'wrong'),
        throwsException,
      );
    });
  });
}
```

### Manual Testing Checklist

- [ ] User can login with valid credentials
- [ ] User cannot login with invalid credentials
- [ ] Products load correctly
- [ ] Can add product to cart
- [ ] Cart calculation is correct
- [ ] Can process payment (test with test card)
- [ ] Transaction receipt displays properly
- [ ] Can logout successfully
- [ ] User role permissions work correctly

---

## Debugging Tips

### Backend Debugging

#### Laravel Debugbar

```php
// Install
composer require barryvdh/laravel-debugbar --dev

// Use in code
dd($variable);  // Dump and die
dump($variable);  // Dump and continue
logger($variable);  // Log to storage/logs/laravel.log
```

#### Browser Debugging

```bash
# Enable query logging
DB::enableQueryLog();
// ... your code ...
dd(DB::getQueryLog());
```

#### Tinker (Interactive Shell)

```bash
php artisan tinker

# Test queries
Product::all();
Product::where('sku', 'DF-001')->first();
User::with('role')->get();

# Execute operations
User::factory(10)->create();
Product::count();
```

### Frontend Debugging

#### Flutter DevTools

```bash
# Start DevTools
flutter pub global activate devtools
devtools

# Or in VS Code
# Open command palette → Flutter: Launch DevTools

# Features:
# - Widget inspector
# - Performance monitoring
# - Memory profiler
# - Network monitor
```

#### Logging

```dart
import 'package:flutter/foundation.dart';

// Debug logging
debugPrint('Debug message: $value');

// Conditional logging
if (kDebugMode) {
  print('Only in debug mode');
}

// Using logger package
// Add to pubspec: logger: ^2.0.0
import 'package:logger/logger.dart';

final logger = Logger();
logger.d('Debug message');
logger.e('Error message', error, stackTrace);
```

#### Network Debugging

```dart
// Using Dio interceptors
_dio.interceptors.add(
  InterceptorsWrapper(
    onRequest: (options, handler) {
      debugPrint('Request: ${options.method} ${options.path}');
      debugPrint('Headers: ${options.headers}');
      return handler.next(options);
    },
    onResponse: (response, handler) {
      debugPrint('Response: ${response.statusCode}');
      debugPrint('Data: ${response.data}');
      return handler.next(response);
    },
    onError: (error, handler) {
      debugPrint('Error: $error');
      return handler.next(error);
    },
  ),
);
```

---

## Common Tasks

### Adding a New API Endpoint

#### 1. Create Migration (if needed)

```bash
php artisan make:migration add_new_column_to_products
```

```php
// In migration file
public function up()
{
    Schema::table('products', function (Blueprint $table) {
        $table->string('new_column')->nullable();
    });
}
```

#### 2. Create Controller Method

```php
// app/Http/Controllers/Api/ProductController.php
public function newAction(Request $request)
{
    $validated = $request->validate([
        'param' => 'required|string',
    ]);
    
    // Business logic here
    
    return response()->json([
        'status' => true,
        'message' => 'Action completed',
        'data' => $result,
    ]);
}
```

#### 3. Add Route

```php
// routes/api.php
Route::middleware('auth:sanctum')->group(function () {
    Route::post('/products/new-action', [ProductController::class, 'newAction']);
});
```

#### 4. Test Endpoint

```bash
curl -X POST http://localhost:8000/api/products/new-action \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"param": "value"}'
```

### Adding a New Flutter Screen

#### 1. Create Screen File

```dart
// lib/screens/new_screen.dart
import 'package:flutter/material.dart';

class NewScreen extends StatefulWidget {
  const NewScreen({super.key});

  @override
  State<NewScreen> createState() => _NewScreenState();
}

class _NewScreenState extends State<NewScreen> {
  bool _loading = false;
  
  @override
  void initState() {
    super.initState();
    _loadData();
  }
  
  Future<void> _loadData() async {
    setState(() => _loading = true);
    try {
      // Load data
    } finally {
      setState(() => _loading = false);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    
    return Scaffold(
      appBar: AppBar(title: const Text('New Screen')),
      body: const Center(child: Text('Content')),
    );
  }
}
```

#### 2. Create Service (if needed)

```dart
// lib/services/new_service.dart
class NewService {
  final ApiClient apiClient;
  
  NewService(this.apiClient);
  
  Future<List<Data>> fetchData() async {
    final response = await apiClient.get('/endpoint');
    return (response['data'] as List)
        .map((item) => Data.fromJson(item))
        .toList();
  }
}
```

#### 3. Navigate to Screen

```dart
// From another screen
Navigator.push(
  context,
  MaterialPageRoute(builder: (_) => const NewScreen()),
);

// Or with Go Router
context.go('/new-screen');
```

### Database Seeding

```bash
# Create seeder
php artisan make:seeder ProductSeeder

# In seeder file (database/seeders/ProductSeeder.php)
public function run()
{
    Product::factory(50)->create();
    // Or specific data
    Product::create([
        'name' => 'Dog Food',
        'sku' => 'DF-001',
        'buy_price' => 50000,
        'sell_price' => 75000,
    ]);
}

# Run seeder
php artisan db:seed
php artisan db:seed --class=ProductSeeder
```

---

## Deployment Checklist

### Pre-Deployment

- [ ] All tests passing: `php artisan test` & `flutter test`
- [ ] Code review completed
- [ ] No console errors in frontend
- [ ] No PHP errors in backend logs
- [ ] Database migrations tested
- [ ] Environment variables documented
- [ ] API endpoints verified
- [ ] Performance optimized

### Backend Deployment

```bash
# 1. Pull latest code
git pull origin main

# 2. Install dependencies
composer install --no-dev

# 3. Update environment
cp .env.example .env
php artisan key:generate

# 4. Database migrations
php artisan migrate --force

# 5. Clear caches
php artisan cache:clear
php artisan config:clear
php artisan route:cache
php artisan view:cache

# 6. Set permissions
chmod -R 755 storage bootstrap/cache

# 7. Restart services
php artisan queue:restart
sudo systemctl restart php-fpm
sudo systemctl restart nginx
```

### Frontend Deployment

#### Android

```bash
# 1. Build release APK
flutter build apk --release

# 2. Build App Bundle (recommended)
flutter build appbundle --release

# 3. Upload to Google Play Console
# APK location: build/app/outputs/bundle/release/app-release.aab

# 4. Set version in pubspec.yaml
version: 1.0.0+1
```

#### iOS

```bash
# 1. Build iOS app
flutter build ios --release

# 2. Create IPA (via Xcode)
open ios/Runner.xcworkspace

# 3. In Xcode:
# - Select "Generic iOS Device"
# - Product → Archive
# - Distribute App

# 4. Upload to App Store Connect
```

#### Web

```bash
# 1. Build web
flutter build web --release

# 2. Upload dist/ to web server
# Or deploy to Netlify/Vercel/Firebase Hosting

# Firebase hosting example:
firebase deploy --only hosting
```

### Post-Deployment

- [ ] Test login functionality
- [ ] Verify all API endpoints working
- [ ] Check database connectivity
- [ ] Monitor error logs
- [ ] Test payment processing
- [ ] Verify email notifications (if any)
- [ ] Performance monitoring
- [ ] Security audit

---

## Performance Optimization

### Backend

```php
// Use query optimization
// ❌ Bad - N+1 problem
$products = Product::all();
foreach ($products as $product) {
    echo $product->category->name;  // Extra query per product
}

// ✅ Good - Eager loading
$products = Product::with('category')->get();
foreach ($products as $product) {
    echo $product->category->name;  // No extra queries
}

// Use pagination
$products = Product::paginate(15);  // Better than all()

// Cache queries
$categories = Cache::remember('categories', 3600, function () {
    return Category::all();
});
```

### Frontend

```dart
// Lazy loading lists
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) => ItemWidget(items[index]),
);

// Cache images
Image.network(
  url,
  cacheHeight: 200,
  cacheWidth: 200,
);

// Use const constructors
const Text('Static text');

// Avoid rebuilds
Consumer<MyProvider>(
  selector: (_, provider, __) => provider.selectedItem,
  builder: (_, selected, __) => Text(selected),
);
```

---

**Last Updated**: 2024-06-05
**Version**: 1.0.0
