// Product Model Unit Tests

import 'package:demo_shop_app/features/products/models/product.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Product Model', () {
    test('should create Product from JSON', () {
      // Arrange
      final json = {
        'id': 1,
        'title': 'iPhone 15',
        'description': 'Latest iPhone',
        'price': 999.99,
        'discountPercentage': 10.5,
        'rating': 4.8,
        'stock': 50,
        'brand': 'Apple',
        'category': 'smartphones',
        'thumbnail': 'thumbnail.jpg',
        'images': ['image1.jpg', 'image2.jpg'],
      };

      // Act
      final product = Product.fromJson(json);

      // Assert
      expect(product.id, 1);
      expect(product.title, 'iPhone 15');
      expect(product.description, 'Latest iPhone');
      expect(product.price, 999.99);
      expect(product.discountPercentage, 10.5);
      expect(product.rating, 4.8);
      expect(product.stock, 50);
      expect(product.brand, 'Apple');
      expect(product.category, 'smartphones');
      expect(product.thumbnail, 'thumbnail.jpg');
      expect(product.images.length, 2);
      expect(product.images.first, 'image1.jpg');
    });

    test('should convert Product to JSON', () {
      // Arrange
      final product = Product(
        id: 1,
        title: 'iPhone 15',
        description: 'Latest iPhone',
        price: 999.99,
        discountPercentage: 10.5,
        rating: 4.8,
        stock: 50,
        brand: 'Apple',
        category: 'smartphones',
        thumbnail: 'thumbnail.jpg',
        images: ['image1.jpg', 'image2.jpg'],
      );

      // Act
      final json = product.toJson();

      // Assert
      expect(json['id'], 1);
      expect(json['title'], 'iPhone 15');
      expect(json['description'], 'Latest iPhone');
      expect(json['price'], 999.99);
      expect(json['discountPercentage'], 10.5);
      expect(json['rating'], 4.8);
      expect(json['stock'], 50);
      expect(json['brand'], 'Apple');
      expect(json['category'], 'smartphones');
      expect(json['thumbnail'], 'thumbnail.jpg');
      expect(json['images'], ['image1.jpg', 'image2.jpg']);
    });

    test('should handle nullable brand', () {
      // Arrange
      final json = {
        'id': 1,
        'title': 'Test Product',
        'description': 'Test Description',
        'price': 99.99,
        'discountPercentage': 5.0,
        'rating': 4.0,
        'stock': 10,
        'brand': null,
        'category': 'test',
        'thumbnail': 'test.jpg',
        'images': [],
      };

      // Act
      final product = Product.fromJson(json);

      // Assert
      expect(product.brand, null);
    });

    test('should calculate discounted price correctly', () {
      // Arrange
      final product = Product(
        id: 1,
        title: 'Test',
        description: 'Test',
        price: 100.0,
        discountPercentage: 20.0,
        rating: 4.0,
        stock: 10,
        brand: 'Test',
        category: 'test',
        thumbnail: 'test.jpg',
        images: [],
      );

      // Act
      final discountedPrice =
          product.price * (1 - product.discountPercentage / 100);

      // Assert
      expect(discountedPrice, 80.0);
    });
  });
}
