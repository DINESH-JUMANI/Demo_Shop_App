// Product Detail Loading Widget

import 'package:demo_shop_app/core/constants/app_colors.dart';
import 'package:demo_shop_app/core/constants/app_sizes.dart';
import 'package:demo_shop_app/core/constants/app_strings.dart';
import 'package:demo_shop_app/features/products/models/product.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProductDetailLoading extends StatelessWidget {
  const ProductDetailLoading({super.key});

  @override
  Widget build(BuildContext context) {
    // Create a mock product for skeleton
    final mockProduct = Product(
      id: 0,
      title: 'Loading Product Name Here',
      description:
          'Loading description text here for this product. This is a placeholder text that will be replaced with actual product description.',
      price: 99.99,
      discountPercentage: 15.0,
      rating: 4.5,
      stock: 100,
      brand: 'Brand Name',
      category: 'Category',
      thumbnail: 'https://via.placeholder.com/400',
      images: ['https://via.placeholder.com/400'],
    );

    return Scaffold(
      body: Skeletonizer(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: AppSizes.carouselHeight,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(color: AppColors.borderLight),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.padding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mockProduct.brand.toUpperCase(),
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(fontSize: 11),
                    ),
                    const SizedBox(height: AppSizes.spaceMd),
                    Text(
                      mockProduct.title,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: AppSizes.padding),
                    Text(
                      '\$${mockProduct.price.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: AppSizes.padding),
                    Text(
                      mockProduct.category,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: AppSizes.paddingXl),
                    Text(
                      AppStrings.description,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: AppSizes.paddingMd),
                    Text(
                      mockProduct.description,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
