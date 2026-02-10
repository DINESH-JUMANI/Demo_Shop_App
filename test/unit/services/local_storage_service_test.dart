// Local Storage Service Unit Tests

import 'package:demo_shop_app/core/services/local_storage_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    // Initialize with fake shared preferences
    SharedPreferences.setMockInitialValues({});
    await LocalStorageService.init();
  });

  group('LocalStorageService - Theme', () {
    test('should save and retrieve theme', () async {
      // Act
      await LocalStorageService.setTheme('dark');
      final result = LocalStorageService.getTheme();

      // Assert
      expect(result, 'dark');
    });

    test('should update theme', () async {
      // Arrange
      await LocalStorageService.setTheme('dark');

      // Act
      await LocalStorageService.setTheme('light');
      final result = LocalStorageService.getTheme();

      // Assert
      expect(result, 'light');
    });

    test('should return null for unset theme', () async {
      // Arrange
      SharedPreferences.setMockInitialValues({});
      await LocalStorageService.init();

      // Act
      final result = LocalStorageService.getTheme();

      // Assert
      expect(result, isNull);
    });
  });

  group('LocalStorageService - Cached Products', () {
    test('should save and retrieve cached products', () async {
      // Arrange
      const productsJson = '{"products": []}';

      // Act
      await LocalStorageService.setCachedProducts(productsJson);
      final result = LocalStorageService.getCachedProducts();

      // Assert
      expect(result, productsJson);
    });

    test('should clear cached products', () async {
      // Arrange
      await LocalStorageService.setCachedProducts('{"products": []}');

      // Act
      await LocalStorageService.clearCachedProducts();
      final result = LocalStorageService.getCachedProducts();

      // Assert
      expect(result, isNull);
    });
  });

  group('LocalStorageService - First Launch', () {
    test('should return true by default for first launch', () async {
      // Arrange
      SharedPreferences.setMockInitialValues({});
      await LocalStorageService.init();

      // Act
      final result = LocalStorageService.getIsFirstLaunch();

      // Assert
      expect(result, true);
    });

    test('should save and retrieve first launch status', () async {
      // Act
      await LocalStorageService.setIsFirstLaunch(false);
      final result = LocalStorageService.getIsFirstLaunch();

      // Assert
      expect(result, false);
    });
  });

  group('LocalStorageService - Last Sync', () {
    test('should save and retrieve last sync timestamp', () async {
      // Arrange
      const timestamp = '2026-02-11T10:00:00Z';

      // Act
      await LocalStorageService.setLastSync(timestamp);
      final result = LocalStorageService.getLastSync();

      // Assert
      expect(result, timestamp);
    });

    test('should return null for unset last sync', () async {
      // Arrange
      SharedPreferences.setMockInitialValues({});
      await LocalStorageService.init();

      // Act
      final result = LocalStorageService.getLastSync();

      // Assert
      expect(result, isNull);
    });
  });

  group('LocalStorageService - Constants', () {
    test('should have correct key constants', () {
      // Assert
      expect(LocalStorageService.keyCachedProducts, 'cached_products');
      expect(LocalStorageService.keyThemeMode, 'theme_mode');
      expect(LocalStorageService.keyIsFirstLaunch, 'is_first_launch');
      expect(LocalStorageService.keyLastSync, 'last_sync');
    });
  });
}
