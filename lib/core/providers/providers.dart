// Core Providers

import 'package:demo_shop_app/core/network/dio_client.dart';
import 'package:demo_shop_app/core/services/theme_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// SharedPreferences Provider - Must be overridden in main
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences must be overridden');
});

// DioClient Provider
final dioClientProvider = Provider<DioClient>((ref) {
  return DioClient.instance;
});

// Theme Mode Provider
final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(
  ThemeModeNotifier.new,
);
