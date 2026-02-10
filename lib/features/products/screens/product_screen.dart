// Product List Screen

import 'dart:async';

import 'package:demo_shop_app/core/constants/app_colors.dart';
import 'package:demo_shop_app/core/constants/app_sizes.dart';
import 'package:demo_shop_app/core/constants/app_strings.dart';
import 'package:demo_shop_app/core/routes/app_routes.dart';
import 'package:demo_shop_app/core/utils/app_logger.dart';
import 'package:demo_shop_app/core/widgets/app_bar_widget.dart';
import 'package:demo_shop_app/core/widgets/icon_loader.dart';
import 'package:demo_shop_app/features/products/providers/product_provider.dart';
import 'package:demo_shop_app/features/products/widgets/empty_state_widget.dart';
import 'package:demo_shop_app/features/products/widgets/error_state_widget.dart';
import 'package:demo_shop_app/features/products/widgets/product_card.dart';
import 'package:demo_shop_app/features/products/widgets/product_list_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductScreen extends ConsumerStatefulWidget {
  const ProductScreen({super.key});

  @override
  ConsumerState<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends ConsumerState<ProductScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    AppLogger.info('Product screen initialized', 'ProductScreen');
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      // Load more when user is near the bottom
      ref.read(productProvider.notifier).loadMoreProducts();
    }
  }

  void _onSearch(String query) {
    ref.read(productProvider.notifier).searchProducts(query);
  }

  void _onSearchChanged(String query) {
    // Cancel the previous timer
    _debounce?.cancel();

    // Create a new timer
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _onSearch(query);
    });

    // Update UI to show/hide clear button
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final productState = ref.watch(productProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.backgroundDark
          : AppColors.backgroundLight,
      appBar: const CustomAppBar(title: AppStrings.productsTitle),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSizes.padding,
              AppSizes.paddingSm,
              AppSizes.padding,
              AppSizes.paddingMd,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceDark : Colors.white,
                borderRadius: BorderRadius.circular(AppSizes.radius),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(13),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: AppStrings.searchHint,
                  hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondaryLight,
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: AppColors.textSecondaryLight,
                  ),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(
                            Icons.clear,
                            color: AppColors.textSecondaryLight,
                          ),
                          onPressed: () {
                            _searchController.clear();
                            _onSearch('');
                          },
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radius),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.padding,
                    vertical: AppSizes.paddingMd,
                  ),
                ),
                onSubmitted: _onSearch,
                onChanged: _onSearchChanged,
              ),
            ),
          ),

          // Content
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                await ref.read(productProvider.notifier).refreshProducts();
              },
              child: _buildBody(productState),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(ProductState state) {
    // Initial loading state
    if (state.isLoading && state.products.isEmpty) {
      return const ProductListLoading();
    }

    // Error state with no cached data
    if (state.error != null && state.products.isEmpty) {
      return ErrorStateWidget(
        error: state.error!,
        onRetry: () {
          ref.read(productProvider.notifier).fetchProducts();
        },
      );
    }

    // Empty state
    if (state.products.isEmpty) {
      return EmptyStateWidget(
        title: AppStrings.noProductsTitle,
        message: AppStrings.noProductsMessage,
        onRetry: () {
          _searchController.clear();
          ref.read(productProvider.notifier).fetchProducts();
        },
      );
    }

    // Products list
    return Column(
      children: [
        // Error banner if there's an error but we have cached data
        if (state.error != null && state.products.isNotEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSizes.padding),
            color: AppColors.error.withAlpha(26),
            child: Row(
              children: [
                const Icon(
                  Icons.warning,
                  color: AppColors.error,
                  size: AppSizes.iconSm,
                ),
                const SizedBox(width: AppSizes.spaceSm),
                Expanded(
                  child: Text(
                    '${AppStrings.showingCachedData} ${state.error!.replaceAll('Exception: ', '')}',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: AppColors.error),
                  ),
                ),
              ],
            ),
          ),

        // Product Grid
        Expanded(
          child: GridView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(AppSizes.padding),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: AppSizes.productGridCrossAxisCount,
              childAspectRatio: AppSizes.productCardAspectRatio,
              crossAxisSpacing: AppSizes.productCardSpacing,
              mainAxisSpacing: AppSizes.productCardSpacing,
            ),
            itemCount: state.products.length,
            itemBuilder: (context, index) {
              final product = state.products[index];
              return ProductCard(
                product: product,
                onTap: () {
                  AppLogger.info(
                    'Navigating to product detail: ${product.id}',
                    'ProductScreen',
                  );
                  Navigator.pushNamed(
                    context,
                    AppRoutes.productDetail,
                    arguments: product.id,
                  );
                },
              );
            },
          ),
        ),

        // Loading indicator at bottom center for pagination
        if (state.isLoadingMore)
          Container(
            padding: const EdgeInsets.all(AppSizes.padding),
            child: const IconLoader(),
          ),
      ],
    );
  }
}
