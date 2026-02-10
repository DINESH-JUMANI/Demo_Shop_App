// Product Card Widget Test

import 'package:cached_network_image/cached_network_image.dart';
import 'package:demo_shop_app/core/routes/app_routes.dart';
import 'package:demo_shop_app/features/products/models/product.dart';
import 'package:demo_shop_app/features/products/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late Product testProduct;

  setUp(() {
    testProduct = Product(
      id: 1,
      title: 'Test Product',
      description: 'Test Description',
      price: 99.99,
      discountPercentage: 15.0,
      rating: 4.5,
      stock: 100,
      brand: 'Test Brand',
      category: 'test',
      thumbnail: 'https://test.com/image.jpg',
      images: ['https://test.com/image1.jpg'],
    );
  });

  Widget createTestWidget(Product product) {
    return MaterialApp(
      home: Scaffold(
        body: ProductCard(product: product, onTap: () {}),
      ),
      routes: {
        AppRoutes.productDetail: (context) =>
            const Scaffold(body: Center(child: Text('Product Detail'))),
      },
    );
  }

  group('ProductCard Widget', () {
    testWidgets('should display product information', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(createTestWidget(testProduct));

      // Assert
      expect(find.text('Test Brand'), findsOneWidget);
      expect(find.text('Test Product'), findsOneWidget);
      expect(find.text('\$99.99'), findsOneWidget);
      expect(find.text('15% OFF'), findsOneWidget);
      expect(find.text('4.5'), findsOneWidget);
    });

    testWidgets('should display discount badge', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(createTestWidget(testProduct));

      // Assert
      expect(find.text('15% OFF'), findsOneWidget);
    });

    testWidgets('should display rating with star icon', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(createTestWidget(testProduct));

      // Assert
      expect(find.byIcon(Icons.star), findsOneWidget);
      expect(find.text('4.5'), findsOneWidget);
    });

    testWidgets('should display CachedNetworkImage', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(createTestWidget(testProduct));

      // Assert
      expect(find.byType(CachedNetworkImage), findsOneWidget);
    });

    testWidgets('should be tappable', (tester) async {
      // Arrange
      var tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProductCard(product: testProduct, onTap: () => tapped = true),
          ),
        ),
      );

      // Act
      await tester.tap(find.byType(InkWell));
      await tester.pump();

      // Assert
      expect(tapped, true);
    });

    testWidgets('should handle product without discount', (tester) async {
      // Arrange
      final productWithoutDiscount = Product(
        id: 2,
        title: 'No Discount Product',
        description: 'Test Description',
        price: 50.0,
        discountPercentage: 0.0,
        rating: 4.0,
        stock: 50,
        brand: 'Test',
        category: 'test',
        thumbnail: 'https://test.com/image.jpg',
        images: [],
      );

      // Act
      await tester.pumpWidget(createTestWidget(productWithoutDiscount));

      // Assert
      expect(find.text('0% OFF'), findsNothing);
    });
  });
}
