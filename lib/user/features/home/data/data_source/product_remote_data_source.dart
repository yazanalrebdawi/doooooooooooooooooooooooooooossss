import 'package:dartz/dartz.dart';
import '../../../../core/network/failure.dart';
import 'package:dooss_business_app/user/features/home/data/models/product_model.dart';
import 'package:dooss_business_app/user/features/home/data/models/product_filter.dart';

abstract class ProductRemoteDataSource {
  Future<Either<Failure, List<ProductModel>>> fetchProducts();
  Future<Either<Failure, List<ProductModel>>> fetchProductsByCategory(
      String category);
  Future<Either<Failure, ProductModel>> fetchProductDetails(int productId);
  Future<Either<Failure, List<ProductModel>>> fetchRelatedProducts(
      int productId);
  Future<Either<Failure, List<Map<String, dynamic>>>> fetchProductReviews(
      int productId);
  Future<Either<Failure, List<ProductModel>>> fetchFilteredProducts(
      ProductFilter filter);
}
