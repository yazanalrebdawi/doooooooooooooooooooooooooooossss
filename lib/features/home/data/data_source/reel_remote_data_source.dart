import 'package:dartz/dartz.dart';
import '../../../../core/network/failure.dart';
import '../models/reel_model.dart';

abstract class ReelRemoteDataSource {
  Future<Either<Failure, ReelsResponseModel>> fetchReels({
    int page = 1,
    int pageSize = 20,
    String ordering = '-created_at',
  });
}
