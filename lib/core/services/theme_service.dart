// Theme Service

import 'package:demo_shop_app/core/services/local_storage_service.dart';
import 'package:demo_shop_app/core/utils/app_logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeService {
  // Get saved theme mode
  static ThemeMode getThemeMode() {
    try {
      final savedTheme = LocalStorageService.getTheme();
      if (savedTheme == null) return ThemeMode.system;

      switch (savedTheme) {
        case 'light':
          return ThemeMode.light;
        case 'dark':
          return ThemeMode.dark;
        default:
          return ThemeMode.system;
      }
    } catch (e) {
      AppLogger.error('Error getting theme mode: $e', e);
      return ThemeMode.system;
    }
  }

  // Save theme mode
  static Future<void> setThemeMode(ThemeMode mode) async {
    try {
      String themeString;
      switch (mode) {
        case ThemeMode.light:
          themeString = 'light';
          break;
        case ThemeMode.dark:
          themeString = 'dark';
          break;
        case ThemeMode.system:
          themeString = 'system';
          break;
      }

      await LocalStorageService.setTheme(themeString);
      AppLogger.info('Theme mode changed to: $themeString');
    } catch (e) {
      AppLogger.error('Error setting theme mode: $e', e);
    }
  }

  // Get theme name for display
  static String getThemeName(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
        return 'System Default';
    }
  }
}

class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() => ThemeService.getThemeMode();

  Future<void> setThemeMode(ThemeMode mode) async {
    await ThemeService.setThemeMode(mode);
    state = mode;
  }
}
