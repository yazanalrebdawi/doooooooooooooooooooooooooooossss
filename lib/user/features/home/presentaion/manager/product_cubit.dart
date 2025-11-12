import 'package:dooss_business_app/user/core/cubits/optimized_cubit.dart';
import 'product_state.dart';
import 'package:dooss_business_app/user/features/home/data/data_source/product_remote_data_source.dart';
import 'package:dooss_business_app/user/features/home/data/models/product_filter.dart';
import 'package:dooss_business_app/user/features/home/data/models/product_model.dart';

class ProductCubit extends OptimizedCubit<ProductState> {
  final ProductRemoteDataSource dataSource;

  ProductCubit(this.dataSource) : super(const ProductState());

  /// Extract unique categories from products list
  List<String> _extractCategories(List<ProductModel> products) {
    final categoriesSet = <String>{};
    for (final product in products) {
      if (product.category.isNotEmpty) {
        categoriesSet.add(product.category);
      }
    }
    return categoriesSet.toList()..sort();
  }

  /// تحميل المنتجات الرئيسية (أول 10 منتجات)
  void loadProducts() async {
    safeEmit(state.copyWith(isLoading: true, error: null));

    final result = await dataSource.fetchProducts();

    result.fold(
      (failure) {
        safeEmit(state.copyWith(error: failure.message, isLoading: false));
      },
      (allProducts) {
        final homeProducts = allProducts.take(10).toList();
        final categories = _extractCategories(allProducts);

        batchEmit(
          (currentState) => currentState.copyWith(
            products: homeProducts,
            allProducts: allProducts,
            categories: categories,
            isLoading: false,
          ),
        );
      },
    );
  }

  /// تحميل كل المنتجات (مع دعم التصنيف والعرض المحدود)
  void loadAllProducts() async {
    if (state.allProducts.isNotEmpty) {
      final first8Products = state.allProducts.take(8).toList();
      emitOptimized(
        state.copyWith(
          filteredProducts: state.allProducts,
          displayedProducts: first8Products,
          selectedCategory: 'All',
          hasMoreProducts: state.allProducts.length > 8,
        ),
      );
      return;
    }

    safeEmit(state.copyWith(isLoading: true, error: null));

    final result = await dataSource.fetchProducts();

    result.fold(
      (failure) {
        safeEmit(state.copyWith(error: failure.message, isLoading: false));
      },
      (allProducts) {
        final first8Products = allProducts.take(8).toList();
        final categories = _extractCategories(allProducts);
        batchEmit(
          (currentState) => currentState.copyWith(
            allProducts: allProducts,
            filteredProducts: allProducts,
            displayedProducts: first8Products,
            selectedCategory: 'All',
            hasMoreProducts: allProducts.length > 8,
            categories: categories,
            isLoading: false,
          ),
        );
      },
    );
  }

  /// عرض أول 10 منتجات في الصفحة الرئيسية
  void showHomeProducts() {
    final homeProducts = state.allProducts.take(10).toList();
    emitOptimized(state.copyWith(products: homeProducts));
  }

  /// تصفية المنتجات حسب الفئة (Server-side filtering)
  void filterByCategory(String category) async {
    safeEmit(state.copyWith(
        isLoading: true, error: null, selectedCategory: category));

    if (category == 'All') {
      final result = await dataSource.fetchProducts();
      result.fold(
        (failure) {
          safeEmit(state.copyWith(error: failure.message, isLoading: false));
        },
        (allProducts) {
          final first8Products = allProducts.take(8).toList();
          final categories = _extractCategories(allProducts);
          safeEmit(
            state.copyWith(
              filteredProducts: allProducts,
              displayedProducts: first8Products,
              selectedCategory: category,
              hasMoreProducts: allProducts.length > 8,
              categories: categories,
              isLoading: false,
            ),
          );
        },
      );
    } else {
      final filter = ProductFilter(category: category);
      final result = await dataSource.fetchFilteredProducts(filter);

      result.fold(
        (failure) {
          safeEmit(state.copyWith(error: failure.message, isLoading: false));
        },
        (filteredProducts) {
          final first8Products = filteredProducts.take(8).toList();
          safeEmit(
            state.copyWith(
              filteredProducts: filteredProducts,
              displayedProducts: first8Products,
              selectedCategory: category,
              hasMoreProducts: filteredProducts.length > 8,
              isLoading: false,
            ),
          );
        },
      );
    }
  }

  /// Filter products with multiple parameters
  void filterProducts({
    String? name,
    double? minPrice,
    double? maxPrice,
    String? category,
    String? condition,
    String? ordering,
  }) async {
    safeEmit(state.copyWith(isLoading: true, error: null));

    final filter = ProductFilter(
      name: name,
      minPrice: minPrice,
      maxPrice: maxPrice,
      category: category,
      condition: condition,
      ordering: ordering,
    );

    final result = await dataSource.fetchFilteredProducts(filter);

    result.fold(
      (failure) {
        safeEmit(state.copyWith(error: failure.message, isLoading: false));
      },
      (filteredProducts) {
        final first8Products = filteredProducts.take(8).toList();
        safeEmit(
          state.copyWith(
            filteredProducts: filteredProducts,
            displayedProducts: first8Products,
            selectedCategory: category ?? state.selectedCategory,
            hasMoreProducts: filteredProducts.length > 8,
            isLoading: false,
          ),
        );
      },
    );
  }

  /// تحميل المزيد من المنتجات عند التمرير
  void loadMoreProducts() {
    if (state.isLoadingMore || !state.hasMoreProducts) return;

    safeEmit(state.copyWith(isLoadingMore: true));

    final currentDisplayedCount = state.displayedProducts.length;
    final next8Products =
        state.filteredProducts.skip(currentDisplayedCount).take(8).toList();
    final newDisplayedProducts = [...state.displayedProducts, ...next8Products];

    batchEmit(
      (currentState) => currentState.copyWith(
        displayedProducts: newDisplayedProducts,
        hasMoreProducts:
            newDisplayedProducts.length < state.filteredProducts.length,
        isLoadingMore: false,
      ),
    );
  }

  /// تحميل تفاصيل منتج محدد
  void loadProductDetails(int productId) async {
    safeEmit(state.copyWith(isLoading: true, error: null));

    final productResult = await dataSource.fetchProductDetails(productId);

    productResult.fold(
      (failure) {
        safeEmit(state.copyWith(error: failure.message, isLoading: false));
      },
      (product) async {
        safeEmit(state.copyWith(selectedProduct: product, isLoading: false));
        _loadAdditionalProductData(productId);
      },
    );
  }

  /// تبديل حالة المفضلة للمنتج
  void toggleProductFavorite(int productId) {
    emitOptimized(state.copyWith());
  }

  /// تحميل البيانات الإضافية للمنتج (منتجات ذات صلة ومراجعات)
  Future<void> _loadAdditionalProductData(int productId) async {
    final relatedProductsResult =
        await dataSource.fetchRelatedProducts(productId);
    final reviewsResult = await dataSource.fetchProductReviews(productId);

    if (!isClosed) {
      relatedProductsResult.fold(
        (relatedFailure) {
          reviewsResult.fold(
            (reviewFailure) {},
            (reviews) => safeEmit(state.copyWith(productReviews: reviews)),
          );
        },
        (relatedProducts) {
          reviewsResult.fold(
            (reviewFailure) =>
                safeEmit(state.copyWith(relatedProducts: relatedProducts)),
            (reviews) => batchEmit(
              (currentState) => currentState.copyWith(
                relatedProducts: relatedProducts,
                productReviews: reviews,
              ),
            ),
          );
        },
      );
    }
  }
}
