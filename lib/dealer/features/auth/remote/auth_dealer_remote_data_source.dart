import 'package:dartz/dartz.dart';
import 'package:dooss_business_app/dealer/Core/network/failure.dart';
import 'package:dooss_business_app/user/core/network/failure.dart';
import 'package:dooss_business_app/user/features/auth/data/models/create_account_params_model.dart';
import 'package:dooss_business_app/user/features/profile_dealer/data/models/dealer_model.dart';

abstract class AuthDealerRemoteDataSource {
  Future<Either<Failure, DealerModel>> signInDealer(
      String name, String passeord, String code);
}
