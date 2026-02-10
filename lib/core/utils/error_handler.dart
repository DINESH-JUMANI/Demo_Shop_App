import 'package:demo_shop_app/core/constants/api_constants.dart';
import 'package:dio/dio.dart';

/// Error handler for DioException
class ErrorHandler {
  /// Handle DioException and return user-friendly error message
  static String handleDioError(DioException error) {
    // First check if response has a message
    if (error.response != null) {
      final statusCode = error.response!.statusCode;
      final data = error.response!.data;

      // Extract message from response if available
      if (data is Map<String, dynamic> && data.containsKey('message')) {
        return data['message'] as String;
      }

      // Handle specific status codes
      if (statusCode == ApiConstants.statusBadRequest) {
        return 'Invalid request. Please check your input.';
      } else if (statusCode == ApiConstants.statusUnauthorized) {
        return 'Unauthorized access. Please login again.';
      } else if (statusCode == ApiConstants.statusForbidden) {
        return 'Access forbidden.';
      } else if (statusCode == ApiConstants.statusNotFound) {
        return 'Resource not found.';
      } else if (statusCode == ApiConstants.statusInternalServerError) {
        return 'Server error. Please try again later.';
      } else if (statusCode != null && statusCode >= 500) {
        return 'Server error. Please try again later.';
      }

      return 'Request failed with status: $statusCode';
    }

    // Handle different DioException types
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timeout. Please check your internet connection.';
      case DioExceptionType.badResponse:
        return 'Server error. Please try again later.';
      case DioExceptionType.cancel:
        return 'Request cancelled.';
      case DioExceptionType.connectionError:
        return 'No internet connection. Please check your network settings.';
      case DioExceptionType.badCertificate:
        return 'Security certificate error.';
      case DioExceptionType.unknown:
        return error.message ?? 'An unexpected error occurred.';
    }
  }
}
