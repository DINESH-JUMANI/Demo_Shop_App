// Product List Loading Widget - Using Skeletonizer

import 'package:demo_shop_app/core/constants/app_sizes.dart';
import 'package:demo_shop_app/features/products/models/product.dart';
import 'package:demo_shop_app/features/products/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProductListLoading extends StatelessWidget {
  const ProductListLoading({super.key});

  @override
  Widget build(BuildContext context) {
    // Create mock products for skeleton
    final mockProducts = List.generate(
      6,
      (index) => Product(
        id: index,
        title: 'Loading Product Name Here',
        description: 'Loading description text here for this product',
        price: 99.99,
        discountPercentage: 15.0,
        rating: 4.5,
        stock: 100,
        brand: 'Brand Name',
        category: 'Category',
        thumbnail: 'https://via.placeholder.com/150',
        images: ['https://via.placeholder.com/150'],
      ),
    );

    return Skeletonizer(
      child: GridView.builder(
        padding: const EdgeInsets.all(AppSizes.padding),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: AppSizes.productGridCrossAxisCount,
          childAspectRatio: AppSizes.productCardAspectRatio,
          crossAxisSpacing: AppSizes.productCardSpacing,
          mainAxisSpacing: AppSizes.productCardSpacing,
        ),
        itemCount: mockProducts.length,
        itemBuilder: (context, index) {
          return ProductCard(
            product: mockProducts[index],
            onTap: () {}, // Empty callback for skeleton
          );
        },
      ),
    );
  }
}
