// Product Service - API calls for products

import 'package:demo_shop_app/core/constants/api_constants.dart';
import 'package:demo_shop_app/core/utils/error_handler.dart';
import 'package:demo_shop_app/features/products/models/product.dart';
import 'package:demo_shop_app/features/products/models/product_response.dart';
import 'package:dio/dio.dart';

class ProductService {
  ProductService(this._dio);
  final Dio _dio;

  /// Fetch all products with pagination
  /// [limit] - Number of products to fetch (default: 20)
  /// [skip] - Number of products to skip (default: 0)
  Future<ProductResponse> getProducts({int limit = 20, int skip = 0}) async {
    try {
      final response = await _dio.get(
        ApiConstants.productsEndpoint,
        queryParameters: {'limit': limit, 'skip': skip},
      );

      if (response.statusCode == ApiConstants.statusOk) {
        return ProductResponse.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: 'Failed to fetch products',
        );
      }
    } on DioException catch (e) {
      throw Exception(ErrorHandler.handleDioError(e));
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  /// Fetch a single product by ID
  /// [id] - Product ID
  Future<Product> getProductById(int id) async {
    try {
      final response = await _dio.get(ApiConstants.productByIdEndpoint(id));

      if (response.statusCode == ApiConstants.statusOk) {
        return Product.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: 'Failed to fetch product',
        );
      }
    } on DioException catch (e) {
      throw Exception(ErrorHandler.handleDioError(e));
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  /// Search products by query
  /// [query] - Search query string
  Future<ProductResponse> searchProducts(String query) async {
    try {
      final response = await _dio.get(
        ApiConstants.productSearchEndpoint,
        queryParameters: {'q': query},
      );

      if (response.statusCode == ApiConstants.statusOk) {
        return ProductResponse.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: 'Failed to search products',
        );
      }
    } on DioException catch (e) {
      throw Exception(ErrorHandler.handleDioError(e));
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  /// Get products by category
  /// [category] - Category name
  Future<ProductResponse> getProductsByCategory(String category) async {
    try {
      final response = await _dio.get(
        ApiConstants.productsByCategoryEndpoint(category),
      );

      if (response.statusCode == ApiConstants.statusOk) {
        return ProductResponse.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: 'Failed to fetch products by category',
        );
      }
    } on DioException catch (e) {
      throw Exception(ErrorHandler.handleDioError(e));
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
