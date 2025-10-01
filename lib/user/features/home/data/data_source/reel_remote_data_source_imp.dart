import 'package:dartz/dartz.dart';
import '../../../../core/network/failure.dart';
import '../../../../core/network/api_urls.dart';
import '../../../../core/network/app_dio.dart';
import '../models/reel_model.dart';
import 'reel_remote_data_source.dart';

class ReelRemoteDataSourceImp implements ReelRemoteDataSource {
  final AppDio dio;

  ReelRemoteDataSourceImp({required this.dio});

  @override
  Future<Either<Failure, ReelsResponseModel>> fetchReels({
    int page = 1,
    int pageSize = 20,
    String ordering = '-created_at',
  }) async {
    try {
      print('🎬 ReelDataSource: Fetching reels (page: $page, pageSize: $pageSize)...');
      
      final response = await dio.dio.get(
        ApiUrls.reels,
        queryParameters: {
          'page': page,
          'page_size': pageSize,
          'ordering': ordering,
        },
      );

      print('✅ ReelDataSource: Successfully fetched reels');
      print('📊 ReelDataSource: Response data: ${response.data}');

      final reelsResponse = ReelsResponseModel.fromJson(response.data);
      
      print('🎬 ReelDataSource: Parsed ${reelsResponse.results.length} reels');
      
      return Right(reelsResponse);
    } catch (e) {
      print('❌ ReelDataSource: Error fetching reels: $e');
      return Left(Failure(message: 'Failed to fetch reels: ${e.toString()}'));
    }
  }
}
