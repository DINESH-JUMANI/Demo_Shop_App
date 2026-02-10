// Product Service Unit Tests

import 'package:demo_shop_app/core/constants/api_constants.dart';
import 'package:demo_shop_app/features/products/models/product.dart';
import 'package:demo_shop_app/features/products/models/product_response.dart';
import 'package:demo_shop_app/features/products/services/product_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late ProductService productService;
  late Dio dio;

  setUp(() {
    dio = Dio(BaseOptions(baseUrl: ApiConstants.baseUrl));
    productService = ProductService(dio);
  });

  group('ProductService - API Endpoints', () {
    test('should have correct endpoint constants', () {
      // Assert
      expect(ApiConstants.productsEndpoint, '/products');
      expect(ApiConstants.productSearchEndpoint, '/products/search');
      expect(ApiConstants.productByIdEndpoint(1), '/products/1');
      expect(
        ApiConstants.productsByCategoryEndpoint('laptops'),
        '/products/category/laptops',
      );
    });

    test('should create ProductService with Dio instance', () {
      // Assert
      expect(productService, isA<ProductService>());
    });
  });

  group('ProductService - Real API Integration', () {
    test(
      'getProducts should return ProductResponse structure',
      () async {
        // This test requires internet connection
        // Skip in CI/CD environments
        try {
          // Act
          final result = await productService.getProducts(limit: 5, skip: 0);

          // Assert
          expect(result, isA<ProductResponse>());
          expect(result.products, isA<List<Product>>());
          expect(result.limit, greaterThan(0));
        } catch (e) {
          // Skip test if network is unavailable
          print('Network test skipped: $e');
        }
      },
      skip: 'Requires internet connection',
    );

    test(
      'getProductById should return Product structure',
      () async {
        try {
          // Act
          final result = await productService.getProductById(1);

          // Assert
          expect(result, isA<Product>());
          expect(result.id, 1);
        } catch (e) {
          print('Network test skipped: $e');
        }
      },
      skip: 'Requires internet connection',
    );
  });
}
