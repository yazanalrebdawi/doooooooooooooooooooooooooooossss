import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:dooss_business_app/dealer/Core/network/failure.dart';
import 'package:dooss_business_app/dealer/features/auth/remote/auth_dealer_remote_data_source.dart';
import 'package:dooss_business_app/user/core/network/api.dart';
import 'package:dooss_business_app/user/core/network/api_request.dart';
import 'package:dooss_business_app/user/core/network/api_urls.dart';
import 'package:dooss_business_app/user/core/network/failure.dart';
import 'package:dooss_business_app/user/features/profile_dealer/data/models/dealer_model.dart';

class AuthDealerRemoteDataSourceImpl implements AuthDealerRemoteDataSource {
  final API api;

  AuthDealerRemoteDataSourceImpl({required this.api});

  // ----------------------------------------------------------------------------------------
  @override
  Future<Either<Failure, DealerModel>> signInDealer(
    String name,
    String password,
    String code,
  ) async {
    final ApiRequest apiRequest = ApiRequest(
      url: ApiUrls.login,
      data: {
        "username": name,
        "password": password,
        "code": code,
      },
    );

    try {
      final response = await api.post<Map<String, dynamic>>(
        apiRequest: apiRequest,
      );

      return response.fold(
        (failure) {
          log('❌ Sign in failed: ${failure.message}');
          // 🔴 هذا إرجاع الخطأ
          return Left(Failure.handleError (failure as DioException));
        },
        (data) {
          log('✅ Sign in successful: $data');
          DealerModel authResponse = DealerModel.fromJson(data);
          // 🟢 هذا الإرجاع الأخير في حال النجاح
          return Right(authResponse);
        },
      );
    } catch (e, stackTrace) {
      log('🔥 Exception during signInDealer: $e', stackTrace: stackTrace);
          return Left(Failure.handleError (e as DioException));
    }
  }
}
