import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:dooss_business_app/core/network/failure.dart';
import 'package:dooss_business_app/features/auth/data/models/user_model.dart';
import 'package:dooss_business_app/features/my_profile/data/models/edit_user_model.dart';
import 'package:dooss_business_app/features/my_profile/data/models/favorite_model.dart';

abstract class MyProfileRemoteDataSource {
  //* Get Info User
  Future<Either<Failure, UserModel>> getInfoUserRemote();

  //* Update Info User
  Future<Either<Failure, EditUserModel>> updateProfileRemote({
    String? name,
    String? phone,
    File? avatar,
  });

  //* Change Password
  Future<Either<Failure, String>> changePasswordRemote(
    String newPassword,
    String phone,
  );

  //* Get Favorites List ( Cars & Product )
  Future<Either<Failure, List<FavoriteModel>>> getListFavoritesRemote();

  //* Remove Item Favorites
  Future<Either<Failure, void>> deleteFavoriteRemote(int favoriteId);

  //* Request Update Phone Otp
  Future<Either<Failure, String?>> confirmPhoneRemote({
    required String phone,
    required String code,
  });

  //* Request OTP for Phone Confirmation
  Future<Either<Failure, String?>> requestOtpRemote({required String phone});

  //* Cancel Phone Number Update OTP

  Future<Either<Failure, String?>> cancelPhoneUpdateRemote();

  Future<Failure?> updateAvatar(File avatarFile);
}
