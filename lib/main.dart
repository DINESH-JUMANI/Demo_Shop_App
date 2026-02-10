import 'package:demo_shop_app/app.dart';
import 'package:demo_shop_app/core/services/local_storage_service.dart';
import 'package:demo_shop_app/core/utils/app_logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize Local Storage
    LoggerUtils.initialize();
    LoggerUtils.logAppStart();
    await LocalStorageService.init();

    runApp(const ProviderScope(child: MyApp()));
  } catch (e, stackTrace) {
    AppLogger.error('Failed to initialize app: ', e, stackTrace);
    rethrow;
  }
}
