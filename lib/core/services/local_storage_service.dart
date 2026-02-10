// Local Storage Service

import 'package:demo_shop_app/core/utils/app_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static late SharedPreferences _prefs;

  // Storage Keys
  static const String _keyCachedProducts = 'cached_products';
  static const String _keyThemeMode = 'theme_mode';
  static const String _keyIsFirstLaunch = 'is_first_launch';
  static const String _keyLastSync = 'last_sync';

  // For backward compatibility
  static const String keyCachedProducts = _keyCachedProducts;
  static const String keyThemeMode = _keyThemeMode;
  static const String keyIsFirstLaunch = _keyIsFirstLaunch;
  static const String keyLastSync = _keyLastSync;

  // Initialize SharedPreferences
  static Future<void> init() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      AppLogger.success('LocalStorageService initialized');
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to initialize LocalStorageService: $e',
        e,
        stackTrace,
      );
      rethrow;
    }
  }

  // Get SharedPreferences instance
  static SharedPreferences get instance => _prefs;

  // Theme Mode - Specific Getters and Setters
  static String? getTheme() {
    try {
      return _prefs.getString(_keyThemeMode);
    } catch (e) {
      AppLogger.error('Error getting theme mode', e);
      return null;
    }
  }

  static Future<bool> setTheme(String themeMode) async {
    try {
      final result = await _prefs.setString(_keyThemeMode, themeMode);
      if (result) {
        AppLogger.debug('Theme mode saved: $themeMode');
      }
      return result;
    } catch (e) {
      AppLogger.error('Error setting theme mode', e);
      return false;
    }
  }

  // Cached Products - Specific Getters and Setters
  static String? getCachedProducts() {
    try {
      return _prefs.getString(_keyCachedProducts);
    } catch (e) {
      AppLogger.error('Error getting cached products', e);
      return null;
    }
  }

  static Future<bool> setCachedProducts(String productsJson) async {
    try {
      final result = await _prefs.setString(_keyCachedProducts, productsJson);
      if (result) {
        AppLogger.debug('Cached products saved');
      }
      return result;
    } catch (e) {
      AppLogger.error('Error setting cached products', e);
      return false;
    }
  }

  // First Launch - Specific Getters and Setters
  static bool getIsFirstLaunch() {
    try {
      return _prefs.getBool(_keyIsFirstLaunch) ?? true;
    } catch (e) {
      AppLogger.error('Error getting first launch flag', e);
      return true;
    }
  }

  static Future<bool> setIsFirstLaunch(bool isFirstLaunch) async {
    try {
      final result = await _prefs.setBool(_keyIsFirstLaunch, isFirstLaunch);
      if (result) {
        AppLogger.debug('First launch flag saved: $isFirstLaunch');
      }
      return result;
    } catch (e) {
      AppLogger.error('Error setting first launch flag', e);
      return false;
    }
  }

  // Last Sync - Specific Getters and Setters
  static String? getLastSync() {
    try {
      return _prefs.getString(_keyLastSync);
    } catch (e) {
      AppLogger.error('Error getting last sync', e);
      return null;
    }
  }

  static Future<bool> setLastSync(String timestamp) async {
    try {
      final result = await _prefs.setString(_keyLastSync, timestamp);
      if (result) {
        AppLogger.debug('Last sync timestamp saved: $timestamp');
      }
      return result;
    } catch (e) {
      AppLogger.error('Error setting last sync timestamp', e);
      return false;
    }
  }

  // Remove specific key
  static Future<bool> remove(String key) async {
    try {
      final result = await _prefs.remove(key);
      if (result) {
        AppLogger.debug('Removed key: $key');
      }
      return result;
    } catch (e) {
      AppLogger.error('Error removing key: $key', e);
      return false;
    }
  }

  // Clear cached products specifically
  static Future<bool> clearCachedProducts() async {
    try {
      final result = await _prefs.remove(_keyCachedProducts);
      if (result) {
        AppLogger.debug('Cached products cleared');
      }
      return result;
    } catch (e) {
      AppLogger.error('Error clearing cached products', e);
      return false;
    }
  }

  // Clear all data
  static Future<bool> clear() async {
    try {
      final result = await _prefs.clear();
      if (result) {
        AppLogger.warning('Cleared all local storage');
      }
      return result;
    } catch (e) {
      AppLogger.error('Error clearing local storage', e);
      return false;
    }
  }

  // Check if key exists
  static bool containsKey(String key) {
    try {
      return _prefs.containsKey(key);
    } catch (e) {
      AppLogger.error('Error checking key: $key', e);
      return false;
    }
  }

  // Get all keys
  static Set<String> getKeys() {
    try {
      return _prefs.getKeys();
    } catch (e) {
      AppLogger.error('Error getting all keys', e);
      return {};
    }
  }
}
