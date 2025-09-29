import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:dooss_business_app/core/network/failure.dart';
import 'package:dooss_business_app/features/auth/data/models/user_model.dart';
import 'package:dooss_business_app/features/my_profile/data/models/edit_user_model.dart';
import 'package:dooss_business_app/features/my_profile/data/models/favorite_model.dart';

abstract class MyProfileRepository {
  //* Get Info User
  Future<Either<Failure, UserModel>> getInfoUserRepo();

  //* Update Info User
  Future<Either<Failure, EditUserModel>> updateProfileRepo(
    String? name,
    String? phone,
    File? avatar,
  );

  //* Change Password
  Future<Either<Failure, String>> changePasswordRepo(
    String newPassword,
    String phone,
  );

  //* Get Favorites List ( Cars & Product )
  Future<Either<Failure, List<FavoriteModel>>> getFavoriteRepo();

  //* Remove Item Favorites
  Future<Either<Failure, void>> deleteFavoriteRepo(int favoriteId);

  //* Request Update Phone Otp
  Future<Either<Failure, String?>> confirmPhoneRepo({
    required String phone,
    required String code,
  });

  //* Request OTP for Phone Confirmation
  Future<Either<Failure, String?>> requestOtpRepo({required String phone});

  //* Cancel Phone Update
  Future<Either<Failure, String?>> cancelPhoneUpdateRepo();

  Future<Either<Failure, EditUserModel>> updateAvatarRepo(File avatar);
}
