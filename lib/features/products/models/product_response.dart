// Product Response Model

import 'package:demo_shop_app/features/products/models/product.dart';

class ProductResponse {
  // Factory constructor for creating ProductResponse from JSON
  factory ProductResponse.fromJson(Map<String, dynamic> json) {
    return ProductResponse(
      products:
          (json['products'] as List<dynamic>?)
              ?.map((e) => Product.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      total: json['total'] as int? ?? 0,
      skip: json['skip'] as int? ?? 0,
      limit: json['limit'] as int? ?? 0,
    );
  }

  ProductResponse({
    required this.products,
    required this.total,
    required this.skip,
    required this.limit,
  });
  final List<Product> products;
  final int total;
  final int skip;
  final int limit;

  // Method to convert ProductResponse to JSON
  Map<String, dynamic> toJson() {
    return {
      'products': products.map((e) => e.toJson()).toList(),
      'total': total,
      'skip': skip,
      'limit': limit,
    };
  }

  // CopyWith method for creating modified copies
  ProductResponse copyWith({
    List<Product>? products,
    int? total,
    int? skip,
    int? limit,
  }) {
    return ProductResponse(
      products: products ?? this.products,
      total: total ?? this.total,
      skip: skip ?? this.skip,
      limit: limit ?? this.limit,
    );
  }
}
