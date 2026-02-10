# Demo Shop App

A modern Flutter application showcasing product browsing with clean architecture, state management, and comprehensive testing.

## About

Demo Shop App is a full-featured Flutter e-commerce application that demonstrates best practices in mobile app development. It includes:

- **Product Browsing**: Browse through a catalog of products with pagination
- **Search Functionality**: Real-time debounced search to find products quickly
- **Product Details**: Detailed view with image carousel and complete product information
- **Theme Support**: Light and dark theme with persistent storage
- **Offline Caching**: Products are cached locally for offline access
- **Clean Architecture**: Well-organized code structure with separation of concerns
- **State Management**: Riverpod for efficient and scalable state management
- **Error Handling**: Comprehensive error handling with user-friendly messages
- **Loading States**: Skeleton screens for better UX during data loading

## API

This app uses the **DummyJSON API** for fetching product data:

- **API Base URL**: [https://dummyjson.com](https://dummyjson.com)
- **Documentation**: [https://dummyjson.com/docs](https://dummyjson.com/docs)
- **Endpoints Used**:
  - `GET /products` - Fetch all products with pagination
  - `GET /products/{id}` - Fetch single product by ID
  - `GET /products/search?q={query}` - Search products
  - `GET /products/category/{category}` - Get products by category

## Architecture

```
lib/
├── app.dart                          # Main app widget
├── main.dart                         # App entry point
├── core/                             # Core functionality
│   ├── constants/                    # App-wide constants
│   │   ├── api_constants.dart        # API endpoints & status codes
│   │   ├── app_assets.dart           # Asset paths
│   │   ├── app_colors.dart           # Color palette
│   │   ├── app_sizes.dart            # Size constants
│   │   └── app_strings.dart          # Text strings
│   ├── extensions/                   # Dart extensions
│   ├── network/                      # Network setup
│   │   └── dio_client.dart           # Dio HTTP client
│   ├── routes/                       # Navigation
│   │   └── app_routes.dart           # Route definitions
│   ├── services/                     # Core services
│   │   ├── local_storage_service.dart # SharedPreferences wrapper
│   │   └── theme_service.dart        # Theme management
│   └── utils/                        # Utility classes
│       ├── app_logger.dart           # Logging utility
│       └── error_handler.dart        # Error handling
├── features/                         # Feature modules
│   ├── products/                     # Product feature
│   │   ├── models/                   # Data models
│   │   ├── providers/                # State providers
│   │   ├── screens/                  # UI screens
│   │   ├── services/                 # API services
│   │   └── widgets/                  # Reusable widgets
│   ├── settings/                     # Settings feature
│   │   ├── settings_screen.dart
│   │   └── widgets/
│   └── splash/                       # Splash screen
│       └── screen/
└── utils/                            # App utilities
    └── custom_widgets/               # Custom widgets
```

## Getting Started

### Prerequisites

- Flutter SDK: `^3.10.8`
- Dart SDK: `^3.10.8`
- iOS Simulator / Android Emulator / Physical Device

### Installation

1. **Clone the repository**

   ```bash
   git clone https://github.com/DINESH-JUMANI/Demo_Shop_App.git
   cd demo_shop_app
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Build Commands

**Development Build (Debug)**

```bash
flutter run
```

**Release Build - Android**

```bash
flutter build apk --release
# Or for app bundle
flutter build appbundle --release
```

**Release Build - iOS**

```bash
flutter build ios --release
```

**Release Build - Web**

```bash
flutter build web --release
```

## Testing

The app includes comprehensive test coverage with unit tests, widget tests, and integration tests.

### Test Structure

```
test/
├── unit/                             # Unit tests
│   ├── models/                       # Model tests
│   ├── services/                     # Service tests
│   └── utils/                        # Utility tests
├── widget/                           # Widget tests
│   └── widgets/                      # Widget component tests
└── widget_test.dart                  # Main widget test

integration_test/
└── app_test.dart                     # Integration tests
```

### Run Tests

**Run all unit and widget tests**

```bash
flutter test
```

**Run tests with coverage**

```bash
flutter test --coverage
```

**View coverage report (requires lcov)**

```bash
# Install lcov (macOS)
brew install lcov

# Generate HTML coverage report
genhtml coverage/lcov.info -o coverage/html

# Open coverage report
open coverage/html/index.html
```

**Run specific test file**

```bash
flutter test test/unit/services/product_service_test.dart
```

**Run integration tests**

```bash
flutter test integration_test/app_test.dart
```

**Run integration tests on device**

```bash
flutter test integration_test/app_test.dart
```

### Test Coverage

The test suite includes:
- **Unit Tests**: Services (ProductService, LocalStorageService), models (Product), and utilities (ErrorHandler)
- **Widget Tests**: Custom widgets (ProductCard, EmptyStateWidget, ErrorStateWidget)
- **Integration Tests**: Full app flow with user interactions

**Note**: Network tests are marked as skipped since they require internet connection. Local storage tests use `SharedPreferences.setMockInitialValues()` for mocking.

## Dependencies

### Production Dependencies

- **flutter**: SDK
- **cupertino_icons** (^1.0.8): iOS style icons
- **dio** (^5.9.1): HTTP client for REST API calls
- **pretty_dio_logger** (^1.4.0): Beautiful HTTP request/response logging
- **flutter_riverpod** (^3.2.1): Modern state management solution
- **shared_preferences** (^2.5.4): Persistent key-value storage
- **persistent_bottom_nav_bar_v2** (^6.2.0): Persistent bottom navigation bar
- **cached_network_image** (^3.4.1): Network image caching
- **skeletonizer** (^2.1.2): Skeleton loading screens
- **carousel_slider** (^5.1.2): Image carousel widget

### Development Dependencies

- **flutter_test**: Testing framework (SDK)
- **integration_test**: Integration testing framework (SDK)
- **flutter_lints** (^6.0.0): Official Flutter linting rules
- **flutter_launcher_icons** (^0.14.4): Generate app icons for iOS and Android

## Features

### Product Browsing

- Grid layout with product cards
- Infinite scroll with pagination
- Skeleton loading states
- Product images with caching
- Discount badges
- Rating display

### Search

- Debounced search (500ms delay)
- Real-time results
- Empty state handling
- Search query persistence

### Product Details

- Image carousel with indicators
- Product information (price, discount, rating, stock)
- Brand and category display
- Description text
- Back navigation

### Settings

- Theme selection (Light/Dark/System)
- Organized settings sections
- Persistent theme storage

### Error Handling

- User-friendly error messages
- Retry functionality
- Offline detection
- Network error handling

### Performance

- Image caching for faster loading
- Local product caching
- Efficient state management
- Optimized list rendering
