// Product Detail Screen

import 'package:demo_shop_app/core/constants/app_assets.dart';
import 'package:demo_shop_app/core/constants/app_sizes.dart';
import 'package:demo_shop_app/core/constants/app_strings.dart';
import 'package:demo_shop_app/core/utils/app_logger.dart';
import 'package:demo_shop_app/features/products/providers/product_provider.dart';
import 'package:demo_shop_app/features/products/widgets/product_detail_loading.dart';
import 'package:demo_shop_app/features/products/widgets/product_image_carousel.dart';
import 'package:demo_shop_app/features/products/widgets/product_info_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductDetailScreen extends ConsumerStatefulWidget {
  const ProductDetailScreen({super.key, required this.productId});
  final int productId;

  @override
  ConsumerState<ProductDetailScreen> createState() =>
      _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  @override
  void initState() {
    super.initState();
    AppLogger.info(
      'Product Detail Screen loaded for product: ${widget.productId}',
    );
  }

  @override
  Widget build(BuildContext context) {
    final productAsync = ref.watch(productDetailProvider(widget.productId));

    return Scaffold(
      body: productAsync.when(
        data: (product) => CustomScrollView(
          slivers: [
            // App Bar with image carousel
            SliverAppBar(
              expandedHeight: AppSizes.carouselHeight,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  children: [ProductImageCarousel(images: product.images)],
                ),
              ),
            ),

            // Product Details
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.padding),
                child: ProductInfoSection(product: product),
              ),
            ),
          ],
        ),
        loading: () => const ProductDetailLoading(),
        error: (error, stackTrace) {
          AppLogger.error('Error loading product: $error');
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.paddingXxl),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      AppAssets.noDataImage,
                      width: AppSizes.iconXxl * 2,
                      height: AppSizes.iconXxl * 2,
                    ),
                    const SizedBox(height: AppSizes.padding),
                    Text(
                      AppStrings.errorLoadingProduct,
                      style: Theme.of(context).textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSizes.spaceMd),
                    Text(
                      error.toString().replaceAll('Exception: ', ''),
                      style: Theme.of(context).textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSizes.paddingXl),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(AppStrings.goBack),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
