class ProductFilter {
  final String? name;
  final double? minPrice;
  final double? maxPrice;
  final String? category;
  final String? condition;
  final String? ordering; // e.g., '-created_at', 'price', '-price'
  final int? productId; // For single product fetch

  const ProductFilter({
    this.name,
    this.minPrice,
    this.maxPrice,
    this.category,
    this.condition,
    this.ordering,
    this.productId,
  });

  /// Build query string from filter parameters
  String buildQueryString() {
    final queryParams = <String>[];

    if (name != null && name!.isNotEmpty) {
      queryParams.add('name=${Uri.encodeComponent(name!)}');
    }

    if (minPrice != null) {
      queryParams.add('min_price=$minPrice');
    }

    if (maxPrice != null) {
      queryParams.add('max_price=$maxPrice');
    }

    if (category != null && category!.isNotEmpty) {
      queryParams.add('category=${Uri.encodeComponent(category!)}');
    }

    if (condition != null && condition!.isNotEmpty) {
      queryParams.add('condition=${Uri.encodeComponent(condition!)}');
    }

    if (ordering != null && ordering!.isNotEmpty) {
      queryParams.add('ordering=${Uri.encodeComponent(ordering!)}');
    }

    return queryParams.isEmpty ? '' : '?${queryParams.join('&')}';
  }

  /// Build URL for products endpoint
  String buildUrl(String baseUrl) {
    if (productId != null) {
      return '$baseUrl$productId/';
    }
    return '$baseUrl${buildQueryString()}';
  }

  ProductFilter copyWith({
    String? name,
    double? minPrice,
    double? maxPrice,
    String? category,
    String? condition,
    String? ordering,
    int? productId,
  }) {
    return ProductFilter(
      name: name ?? this.name,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      category: category ?? this.category,
      condition: condition ?? this.condition,
      ordering: ordering ?? this.ordering,
      productId: productId ?? this.productId,
    );
  }
}



