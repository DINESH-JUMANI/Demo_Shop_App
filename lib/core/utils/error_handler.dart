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
        return 'Bad request. Please check your input.';
      } else if (statusCode == ApiConstants.statusUnauthorized) {
        return 'Unauthorized. Please login again.';
      } else if (statusCode == ApiConstants.statusForbidden) {
        return 'You don\'t have permission to access this resource.';
      } else if (statusCode == ApiConstants.statusNotFound) {
        return 'Resource not found.';
      } else if (statusCode == ApiConstants.statusInternalServerError) {
        return 'Internal server error. Please try again later.';
      } else if (statusCode != null && statusCode >= 500) {
        return 'Server error. Please try again later.';
      }

      return 'Request failed with status: $statusCode';
    }

    // Handle different DioException types
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return 'Connection timeout. Please try again.';
      case DioExceptionType.sendTimeout:
        return 'Request timeout. Please try again.';
      case DioExceptionType.receiveTimeout:
        return 'Server is taking too long to respond. Please try again.';
      case DioExceptionType.badResponse:
        return 'Server error. Please try again later.';
      case DioExceptionType.cancel:
        return 'Request was cancelled.';
      case DioExceptionType.connectionError:
        return 'No internet connection. Please check your network settings.';
      case DioExceptionType.badCertificate:
        return 'Security certificate error.';
      case DioExceptionType.unknown:
        return error.message ??
            'An unexpected error occurred. Please try again.';
    }
  }
}
