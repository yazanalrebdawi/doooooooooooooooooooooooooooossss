import 'dart:developer';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:dooss_business_app/core/network/api.dart';
import 'package:dooss_business_app/core/network/api_request.dart';
import 'package:dooss_business_app/core/network/api_urls.dart';
import 'package:dooss_business_app/core/network/failure.dart';
import 'package:dooss_business_app/core/services/locator_service.dart';
import 'package:dooss_business_app/core/services/storage/secure_storage/secure_storage_service.dart';
import 'package:dooss_business_app/features/auth/data/models/user_model.dart';
import 'package:dooss_business_app/features/my_profile/data/models/edit_user_model.dart';
import 'package:dooss_business_app/features/my_profile/data/models/favorite_model.dart';
import 'package:dooss_business_app/features/my_profile/data/source/remote/my_profile_remote_data_source.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class MyProfileRemoteDataSourceImpl implements MyProfileRemoteDataSource {
  final API api;

  MyProfileRemoteDataSourceImpl({required this.api});

  //?----------------------------------------------------------------
  @override
  Future<Either<Failure, UserModel>> getInfoUserRemote() async {
    final response = await api.get(
      apiRequest: ApiRequest(url: ApiUrls.getInfoProfile),
    );

    return response.fold(
      (failure) {
        log('Failure: ${failure.message}');
        return Left(failure);
      },
      (data) {
        log('Data received: $data');

        if (data == null) {
          return Left(Failure(message: 'No data received from server'));
        }

        if (data is Map<String, dynamic>) {
          try {
            final user = UserModel.fromJson(data);
            return Right(user);
          } catch (e, st) {
            log('Parsing error: $e', stackTrace: st);
            return Left(Failure(message: 'Failed to parse user data'));
          }
        } else {
          return Left(Failure(message: 'Unexpected response format: $data'));
        }
      },
    );
  }

  @override
  Future<Failure?> updateAvatar(File avatarFile) async {
    try {
      final user = await appLocator<SecureStorageService>().getAuthModel();
      final token = user?.token;

      if (token == null) {
        return Failure(message: 'No authentication token found');
      }

      final Dio dio = Dio();

      final formData = FormData();
      formData.files.add(
        MapEntry(
          'avatar',
          await MultipartFile.fromFile(
            avatarFile.path,
            filename: avatarFile.path.split('/').last,
          ),
        ),
      );

      final response = await dio.patch(
        ApiUrls.editInfoProfile,
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        log('✅ Avatar updated successfully');
        return null;
      } else {
        return Failure(message: 'Failed with status ${response.statusCode}');
      }
    } catch (e) {
      log('❌ updateAvatar Exception: $e');
      if (e is DioException) {
        return Failure.handleError(e);
      } else {
        return Failure(message: e.toString());
      }
    }
  }

  //?----------------------------------------------------------------
  @override
  Future<Either<Failure, EditUserModel>> updateProfileRemote({
    String? name,
    String? phone,
    File? avatar,
  }) async {
    log("😂😂😂 Start updateProfileRemote");
    try {
      final user = await appLocator<SecureStorageService>().getAuthModel();
      final token = user?.token;
      if (token == null) {
        return Left(Failure(message: 'No authentication token found'));
      }

      final Dio dio = Dio();
      final formData = FormData();

      dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
          compact: true,
          maxWidth: 90,
          enabled: true,
        ),
      );

      if (name != null && name.isNotEmpty) {
        formData.fields.add(MapEntry('name', name));
      }
      if (phone != null && phone.isNotEmpty) {
        formData.fields.add(MapEntry('phone', phone));
      }
      if (avatar != null) {
        formData.files.add(
          MapEntry(
            'profile_image',
            await MultipartFile.fromFile(
              avatar.path,
              filename: avatar.path.split('/').last,
            ),
          ),
        );
      }

      final response = await dio.patch(
        ApiUrls.editInfoProfile,
        data: formData,
        options: Options(
          headers: {
            "Content-Type": "multipart/form-data",
            "Authorization": "Bearer $token",
          },
        ),
      );

      if (response.statusCode == 200) {
        final user = EditUserModel.fromMap(response.data);
        return Right(user);
      } else {
        return Left(
          Failure(message: 'Failed with status ${response.statusCode}'),
        );
      }
    } catch (e) {
      log(e.toString());
      return Left(Failure.handleError(e as DioException));
    }
  }

  //?----------------------------------------------------------------
  //?---------------------------------------------------------------------
  //?----------------------------------------------------------------
  //* Request OTP for Phone Confirmation
  @override
  Future<Either<Failure, String?>> requestOtpRemote({
    required String phone,
  }) async {
    try {
      final response = await api.post(
        apiRequest: ApiRequest(url: ApiUrls.requestOtp, data: {"phone": phone}),
      );

      return response.fold(
        (failure) => Left(Failure(message: failure.message)),
        (data) {
          if (data is Map<String, dynamic> && data.containsKey('detail')) {
            return Right(data['detail'] as String);
          }
          return const Right(null);
        },
      );
    } catch (e) {
      return Left(Failure.handleError(e as DioException));
    }
  }

  //?----------------------------------------------------------------
  //* Cancel Phone Number Update OTP
  @override
  Future<Either<Failure, String?>> cancelPhoneUpdateRemote() async {
    try {
      final user = await appLocator<SecureStorageService>().getAuthModel();
      final token = user?.token;

      if (token == null) {
        return Left(Failure(message: 'No authentication token found'));
      }

      final response = await api.post(
        apiRequest: ApiRequest(
          url: ApiUrls.cancelUpdatePhoneOtp,
          data: {"code": "355186"},
        ),
      );

      return response.fold(
        (failure) => Left(Failure(message: failure.message)),
        (data) {
          if (data is Map<String, dynamic> && data.containsKey('detail')) {
            return Right(data['detail'] as String);
          }
          return const Right(null);
        },
      );
    } catch (e) {
      return Left(Failure.handleError(e as DioException));
    }
  }

  //?----------------------------------------------------------------
  //* Confirm Phone Number Update
  @override
  Future<Either<Failure, String?>> confirmPhoneRemote({
    required String phone,
    required String code,
  }) async {
    try {
      final user = await appLocator<SecureStorageService>().getAuthModel();
      final token = user?.token;
      if (token == null) {
        return Left(Failure(message: 'No authentication token found'));
      }

      final response = await api.post(
        apiRequest: ApiRequest(
          url:
              "http://192.168.1.105:8010/api/users/profile/phone/confirm/?phone=+$phone&code=$code",
          data: {"code": code},
        ),
      );

      return response.fold(
        (failure) => Left(Failure(message: failure.message)),
        (data) {
          if (data is Map<String, dynamic> && data.containsKey('detail')) {
            return Right(data['detail'] as String);
          }
          return const Right(null);
        },
      );
    } catch (e) {
      return Left(Failure.handleError(e as DioException));
    }
  }

  //?----------------------------------------------------------------
  @override
  Future<Either<Failure, String>> changePasswordRemote(
    String newPassword,
    String phone,
  ) async {
    try {
      final response = await api.post(
        apiRequest: ApiRequest(
          url: ApiUrls.changePasswordInProfile,
          data: {"phone": phone, "new_password": newPassword},
        ),
      );

      return response.fold(
        (failure) {
          log('❌ Set New Password failed: ${failure.message}');
          return Left(failure);
        },
        (result) {
          log('✅ Set New Password successful: $result');

          if (result is Map<String, dynamic>) {
            final message =
                result["message"] ?? "Password changed successfully";
            return Right(message);
          } else {
            return Right("Password changed successfully");
          }
        },
      );
    } catch (e) {
      log('❌ changePasswordRemote Exception: $e');
      if (e is DioException) {
        return Left(Failure.handleError(e));
      } else {
        return Left(Failure(message: e.toString()));
      }
    }
  }

  //?----------------------------------------------------------------
  @override
  Future<Either<Failure, List<FavoriteModel>>> getListFavoritesRemote() async {
    final ApiRequest request = ApiRequest(url: ApiUrls.getFavorites);
    final response = await api.get(apiRequest: request);

    return response.fold(
      (failure) {
        log('❌ getFavorites Network Error : ${failure.message}');

        if (failure is DioException) {
          return Left(Failure.handleError(failure as DioException));
        } else {
          return Left(Failure(message: failure.toString(), statusCode: -1));
        }
      },
      (result) {
        try {
          if (result is List) {
            final favorites =
                result
                    .map(
                      (item) =>
                          FavoriteModel.fromJson(item as Map<String, dynamic>),
                    )
                    .toList();

            for (final fav in favorites) {
              log(
                '⭐ Fav[${fav.id}] type=${fav.targetType} name=${fav.target.name}',
              );
            }

            return Right(favorites);
          } else {
            final favorite = FavoriteModel.fromJson(
              result as Map<String, dynamic>,
            );
            return Right([favorite]);
          }
        } catch (e, stack) {
          log('❌ Parsing Favorites Error: $e\n$stack');
          return Left(
            Failure(message: 'Parsing Favorites Failed', statusCode: -1),
          );
        }
      },
    );
  }

  //?----------------------------------------------------------------
  @override
  Future<Either<Failure, void>> deleteFavoriteRemote(int favoriteId) async {
    try {
      final response = await api.delete(
        apiRequest: ApiRequest(
          url: "http://192.168.1.105:8010/api/favorites/$favoriteId/",
        ),
      );
      return response.fold(
        (failure) {
          log('❌ Delete favorite failed: ${failure.message}');
          return Left(failure);
        },
        (data) {
          log('✅ Favorite deleted successfully');
          return const Right(null);
        },
      );
    } catch (e) {
      log('❌ Delete favorite error: $e');
      return Left(Failure.handleError(e as DioException));
    }
  }

  //?----------------------------------------------------------------
}
