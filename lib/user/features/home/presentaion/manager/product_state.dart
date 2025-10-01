// Product State
// Single state class for product feature

import '../../data/models/product_model.dart';

class ProductState {
  final List<ProductModel> products;      // First 10 products for home screen
  final List<ProductModel> allProducts;   // All products for "View All" screen
  final List<ProductModel> filteredProducts; // Filtered products based on category
  final List<ProductModel> displayedProducts; // Products currently displayed (first 8)
  final ProductModel? selectedProduct;    // Selected product for details
  final List<ProductModel> relatedProducts; // Related products
  final List<Map<String, dynamic>> productReviews; // Product reviews
  final bool isLoading;
  final String? error;
  final String selectedCategory; // Selected category filter
  final bool hasMoreProducts; // Whether there are more products to load
  final bool isLoadingMore; // Loading state for pagination

  const ProductState({
    this.products = const [],
    this.allProducts = const [],
    this.filteredProducts = const [],
    this.displayedProducts = const [],
    this.selectedProduct,
    this.relatedProducts = const [],
    this.productReviews = const [],
    this.isLoading = false,
    this.error,
    this.selectedCategory = 'All',
    this.hasMoreProducts = true,
    this.isLoadingMore = false,
  });

  ProductState copyWith({
    List<ProductModel>? products,
    List<ProductModel>? allProducts,
    List<ProductModel>? filteredProducts,
    List<ProductModel>? displayedProducts,
    ProductModel? selectedProduct,
    List<ProductModel>? relatedProducts,
    List<Map<String, dynamic>>? productReviews,
    bool? isLoading,
    String? error,
    String? selectedCategory,
    bool? hasMoreProducts,
    bool? isLoadingMore,
  }) {
    return ProductState(
      products: products ?? this.products,
      allProducts: allProducts ?? this.allProducts,
      filteredProducts: filteredProducts ?? this.filteredProducts,
      displayedProducts: displayedProducts ?? this.displayedProducts,
      selectedProduct: selectedProduct ?? this.selectedProduct,
      relatedProducts: relatedProducts ?? this.relatedProducts,
      productReviews: productReviews ?? this.productReviews,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      hasMoreProducts: hasMoreProducts ?? this.hasMoreProducts,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  
  int get totalProductsCount => allProducts.length;
}
