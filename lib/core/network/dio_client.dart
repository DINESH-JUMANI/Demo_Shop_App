// Global Imports

import 'package:demo_shop_app/core/constants/api_constants.dart';
import 'package:demo_shop_app/core/utils/app_logger.dart';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioClient {
  DioClient._internal(String baseUrl) {
    AppLogger.info('Initializing DioClient with baseUrl: $baseUrl');
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    _setupInterceptors();
  }
  // Singleton pattern
  static DioClient? _instance;

  // Instance getter
  static DioClient get instance {
    _instance ??= DioClient._internal(ApiConstants.baseUrl);
    return _instance!;
  }

  void _setupInterceptors() {
    _dio.interceptors.add(
      PrettyDioLogger(requestHeader: true, requestBody: true),
    );
    AppLogger.success('DioClient interceptors configured');
  }

  late Dio _dio;

  // Getter to expose Dio instance
  Dio get dio => _dio;
}
