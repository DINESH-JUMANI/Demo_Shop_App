// Error Handler Unit Tests

import 'package:demo_shop_app/core/constants/api_constants.dart';
import 'package:demo_shop_app/core/utils/error_handler.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ErrorHandler - handleDioError', () {
    test('should return connection timeout message', () {
      // Arrange
      final error = DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: DioExceptionType.connectionTimeout,
      );

      // Act
      final result = ErrorHandler.handleDioError(error);

      // Assert
      expect(result, 'Connection timeout. Please try again.');
    });

    test('should return send timeout message', () {
      // Arrange
      final error = DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: DioExceptionType.sendTimeout,
      );

      // Act
      final result = ErrorHandler.handleDioError(error);

      // Assert
      expect(result, 'Request timeout. Please try again.');
    });

    test('should return receive timeout message', () {
      // Arrange
      final error = DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: DioExceptionType.receiveTimeout,
      );

      // Act
      final result = ErrorHandler.handleDioError(error);

      // Assert
      expect(result, 'Server is taking too long to respond. Please try again.');
    });

    test('should return bad request message for 400', () {
      // Arrange
      final error = DioException(
        requestOptions: RequestOptions(path: '/test'),
        response: Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: ApiConstants.statusBadRequest,
        ),
        type: DioExceptionType.badResponse,
      );

      // Act
      final result = ErrorHandler.handleDioError(error);

      // Assert
      expect(result, 'Bad request. Please check your input.');
    });

    test('should return unauthorized message for 401', () {
      // Arrange
      final error = DioException(
        requestOptions: RequestOptions(path: '/test'),
        response: Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: ApiConstants.statusUnauthorized,
        ),
        type: DioExceptionType.badResponse,
      );

      // Act
      final result = ErrorHandler.handleDioError(error);

      // Assert
      expect(result, 'Unauthorized. Please login again.');
    });

    test('should return forbidden message for 403', () {
      // Arrange
      final error = DioException(
        requestOptions: RequestOptions(path: '/test'),
        response: Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: ApiConstants.statusForbidden,
        ),
        type: DioExceptionType.badResponse,
      );

      // Act
      final result = ErrorHandler.handleDioError(error);

      // Assert
      expect(result, "You don't have permission to access this resource.");
    });

    test('should return not found message for 404', () {
      // Arrange
      final error = DioException(
        requestOptions: RequestOptions(path: '/test'),
        response: Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: ApiConstants.statusNotFound,
        ),
        type: DioExceptionType.badResponse,
      );

      // Act
      final result = ErrorHandler.handleDioError(error);

      // Assert
      expect(result, 'Resource not found.');
    });

    test('should return server error message for 500', () {
      // Arrange
      final error = DioException(
        requestOptions: RequestOptions(path: '/test'),
        response: Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: ApiConstants.statusInternalServerError,
        ),
        type: DioExceptionType.badResponse,
      );

      // Act
      final result = ErrorHandler.handleDioError(error);

      // Assert
      expect(result, 'Internal server error. Please try again later.');
    });

    test('should return connection error message', () {
      // Arrange
      final error = DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: DioExceptionType.connectionError,
      );

      // Act
      final result = ErrorHandler.handleDioError(error);

      // Assert
      expect(
        result,
        'No internet connection. Please check your network settings.',
      );
    });

    test('should return cancel message', () {
      // Arrange
      final error = DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: DioExceptionType.cancel,
      );

      // Act
      final result = ErrorHandler.handleDioError(error);

      // Assert
      expect(result, 'Request was cancelled.');
    });

    test('should return generic error message for unknown error', () {
      // Arrange
      final error = DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: DioExceptionType.unknown,
      );

      // Act
      final result = ErrorHandler.handleDioError(error);

      // Assert
      expect(result, 'An unexpected error occurred. Please try again.');
    });
  });
}
