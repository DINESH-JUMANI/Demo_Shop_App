// Product Providers - State management with Riverpod

import 'dart:convert';

import 'package:demo_shop_app/core/providers/providers.dart';
import 'package:demo_shop_app/core/services/local_storage_service.dart';
import 'package:demo_shop_app/core/utils/app_logger.dart';
import 'package:demo_shop_app/features/products/models/product.dart';
import 'package:demo_shop_app/features/products/services/product_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

// Product Service Provider
final productServiceProvider = Provider<ProductService>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return ProductService(dioClient.dio);
});

// Product State Provider
final productProvider = StateNotifierProvider<ProductNotifier, ProductState>((
  ref,
) {
  final productService = ref.watch(productServiceProvider);
  return ProductNotifier(productService);
});

// Single Product Provider
final productDetailProvider = FutureProvider.family<Product, int>((
  ref,
  productId,
) async {
  final productService = ref.watch(productServiceProvider);
  return await productService.getProductById(productId);
});

// Product State
class ProductState {
  ProductState({
    this.products = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.error,
    this.hasMore = true,
    this.currentSkip = 0,
  });
  final List<Product> products;
  final bool isLoading;
  final bool isLoadingMore;
  final String? error;
  final bool hasMore;
  final int currentSkip;

  ProductState copyWith({
    List<Product>? products,
    bool? isLoading,
    bool? isLoadingMore,
    String? error,
    bool? hasMore,
    int? currentSkip,
  }) {
    return ProductState(
      products: products ?? this.products,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: error,
      hasMore: hasMore ?? this.hasMore,
      currentSkip: currentSkip ?? this.currentSkip,
    );
  }
}

// Product Notifier
class ProductNotifier extends StateNotifier<ProductState> {
  ProductNotifier(this._productService) : super(ProductState()) {
    _loadCachedProducts();
    fetchProducts();
  }
  final ProductService _productService;

  /// Load cached products from local storage
  void _loadCachedProducts() {
    try {
      final cachedData = LocalStorageService.getCachedProducts();
      if (cachedData != null) {
        final List<dynamic> decoded = json.decode(cachedData);
        final products = decoded.map((e) => Product.fromJson(e)).toList();
        state = state.copyWith(products: products);
      }
    } catch (e) {
      // If cache loading fails, continue without cache
      AppLogger.error('Error loading cached products: $e', 'ProductNotifier');
    }
  }

  /// Cache products to local storage
  Future<void> _cacheProducts(List<Product> products) async {
    try {
      final encoded = json.encode(products.map((e) => e.toJson()).toList());
      await LocalStorageService.setCachedProducts(encoded);
    } catch (e) {
      // If caching fails, log but don't crash
      AppLogger.error('Error caching products: $e', 'ProductNotifier');
    }
  }

  /// Fetch initial products
  Future<void> fetchProducts() async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, currentSkip: 0);

    try {
      final response = await _productService.getProducts();

      state = state.copyWith(
        products: response.products,
        isLoading: false,
        hasMore: response.products.length < response.total,
        currentSkip: response.products.length,
      );

      // Cache the products for offline support
      await _cacheProducts(response.products);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Load more products (pagination)
  Future<void> loadMoreProducts() async {
    if (state.isLoadingMore || !state.hasMore) return;

    state = state.copyWith(isLoadingMore: true);

    try {
      final response = await _productService.getProducts(
        skip: state.currentSkip,
      );

      final updatedProducts = [...state.products, ...response.products];

      state = state.copyWith(
        products: updatedProducts,
        isLoadingMore: false,
        hasMore: updatedProducts.length < response.total,
        currentSkip: updatedProducts.length,
      );

      // Update cache with new products
      await _cacheProducts(updatedProducts);
    } catch (e) {
      state = state.copyWith(isLoadingMore: false, error: e.toString());
    }
  }

  /// Refresh products (pull to refresh)
  Future<void> refreshProducts() async {
    state = ProductState(); // Reset state
    await fetchProducts();
  }

  /// Search products
  Future<void> searchProducts(String query) async {
    if (query.isEmpty) {
      await fetchProducts();
      return;
    }

    state = state.copyWith(isLoading: true);

    try {
      final response = await _productService.searchProducts(query);

      state = state.copyWith(
        products: response.products,
        isLoading: false,
        hasMore: false, // Disable pagination for search results
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}
