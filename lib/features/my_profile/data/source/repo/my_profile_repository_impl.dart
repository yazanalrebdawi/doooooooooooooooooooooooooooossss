import 'dart:developer';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:dooss_business_app/core/network/failure.dart';
import 'package:dooss_business_app/core/services/network/network_info_service.dart';
import 'package:dooss_business_app/features/auth/data/models/user_model.dart';
import 'package:dooss_business_app/features/my_profile/data/models/edit_user_model.dart';
import 'package:dooss_business_app/features/my_profile/data/models/favorite_model.dart';
import 'package:dooss_business_app/features/my_profile/data/source/local/my_profile_local_data_source.dart';
import 'package:dooss_business_app/features/my_profile/data/source/remote/my_profile_remote_data_source.dart';
import 'package:dooss_business_app/features/my_profile/data/source/repo/my_profile_repository.dart';

class MyProfileRepositoryImpl implements MyProfileRepository {
  final NetworkInfoService network;
  final MyProfileLocalDataSource local;
  final MyProfileRemoteDataSource remote;

  MyProfileRepositoryImpl({
    required this.network,
    required this.local,
    required this.remote,
  });

  //?---------------------------------------------------------
  @override
  Future<Either<Failure, UserModel>> getInfoUserRepo() async {
    try {
      if (await network.isConnected) {
        final result = await remote.getInfoUserRemote();
        return result.fold((failure) => Left(failure), (user) async {
          return Right(user);
        });
      } else {
        return Left(FailureNoConnection());
      }
    } catch (e) {
      return Left(Failure.handleError(e as DioException));
    }
  }

  //?---------------------------------------------------------
  @override
  Future<Either<Failure, EditUserModel>> updateProfileRepo(
    String? name,
    String? phone,
    File? avatar,
  ) async {
    try {
      if (await network.isConnected) {
        final result = await remote.updateProfileRemote(
          name: name,
          phone: phone,
          avatar: avatar,
        );
        return result.fold((failure) => Left(failure), (updatedUser) async {
          //! ممكن تخزن النسخة الجديدة باللوكل إذا بدك
          //! await local.cacheUserData(updatedUser.toUserModel());
          return Right(updatedUser);
        });
      } else {
        return Left(FailureNoConnection());
      }
    } catch (e) {
      return Left(Failure.handleError(e as DioException));
    }
  }
  //?---------------------------------------------------------

  @override
  Future<Either<Failure, EditUserModel>> updateAvatarRepo(File avatar) async {
    try {
      if (await network.isConnected) {
        final result = await remote.updateProfileRemote(avatar: avatar);

        return result.fold((failure) => Left(failure), (updatedUser) async {
          //! لو بدك، خزّن نسخة جديدة في اللوكل
          //! await local.cacheUserData(updatedUser.toUserModel());
          return Right(updatedUser);
        });
      } else {
        return Left(FailureNoConnection());
      }
    } catch (e) {
      return Left(Failure.handleError(e as DioException));
    }
  }
  //?---------------------------------------------------------

  @override
  Future<Either<Failure, String>> changePasswordRepo(
    String newPassword,
    String phone,
  ) async {
    try {
      if (await network.isConnected) {
        final result = await remote.changePasswordRemote(newPassword, phone);
        return result.fold(
          (failure) => Left(failure),
          (message) => Right(message),
        );
      } else {
        return Left(FailureNoConnection());
      }
    } catch (e) {
      return Left(Failure.handleError(e as DioException));
    }
  }

  //?---------------------------------------------------------

  @override
  Future<Either<Failure, List<FavoriteModel>>> getFavoriteRepo() async {
    try {
      if (await network.isConnected) {
        final result = await remote.getListFavoritesRemote();

        return result.fold(
          (failure) async {
            final localFavorites = local.getCarsListFavoritesLocal();
            return Right(localFavorites);
          },
          (data) async {
            if (data.isEmpty) {
              // final localFavorites = local.getCarsListFavoritesLocal();
              return Right([]);
            } else {
              await local.saveCarsListFavoritesLocal(data);
              return Right(data);
            }
          },
        );
      } else {
        final localFavorites = local.getCarsListFavoritesLocal();
        return Right(localFavorites);
      }
    } catch (e) {
      log('❌ getFavoriteRepo Error: $e');
      return Left(Failure.handleError(e as DioException));
    }
  }

  //?---------------------------------------------------------

  @override
  Future<Either<Failure, void>> deleteFavoriteRepo(int favoriteId) async {
    try {
      if (await network.isConnected) {
        final result = await remote.deleteFavoriteRemote(favoriteId);
        return result.fold(
          (failure) => Left(failure),
          (data) => const Right(null),
        );
      } else {
        return Left(FailureNoConnection());
      }
    } catch (e) {
      log('❌ Delete favorite repo error: $e');
      return Left(Failure.handleError(e as DioException));
    }
  }

  //?---------------------------------------------------------
  //* Cancel Phone Update

  @override
  Future<Either<Failure, String?>> cancelPhoneUpdateRepo() async {
    try {
      if (!await network.isConnected) {
        return Left(FailureNoConnection());
      }
      final result = await remote.cancelPhoneUpdateRemote();
      return result.fold(
        (failure) => Left(failure),
        (message) => Right(message),
      );
    } catch (e) {
      return Left(Failure.handleError(e as DioException));
    }
  }

  //?---------------------------------------------------------
  //* Request OTP for Phone Confirmation

  @override
  Future<Either<Failure, String?>> requestOtpRepo({
    required String phone,
  }) async {
    try {
      if (!await network.isConnected) {
        return Left(FailureNoConnection());
      }

      final result = await remote.requestOtpRemote(phone: phone);

      return result.fold(
        (failure) => Left(failure),
        (message) => Right(message),
      );
    } catch (e) {
      return Left(Failure.handleError(e as DioException));
    }
  }

  //?---------------------------------------------------------

  //* Confirm Phone Repository
  @override
  Future<Either<Failure, String?>> confirmPhoneRepo({
    required String phone,
    required String code,
  }) async {
    try {
      if (await network.isConnected) {
        final result = await remote.confirmPhoneRemote(
          phone: phone,
          code: code,
        );

        return result.fold(
          (failure) => Left(failure),
          (message) => Right(message),
        );
      } else {
        return Left(FailureNoConnection());
      }
    } catch (e) {
      log('❌ confirmPhoneRepo Error: $e');
      return Left(Failure.handleError(e as DioException));
    }
  }

  //?---------------------------------------------------------
}
