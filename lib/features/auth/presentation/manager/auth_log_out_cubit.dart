import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dooss_business_app/core/network/failure.dart';
import 'package:dooss_business_app/core/services/locator_service.dart';
import 'package:dooss_business_app/core/services/storage/hivi/hive_service.dart';
import 'package:dooss_business_app/core/services/storage/secure_storage/secure_storage_service.dart';
import 'package:dooss_business_app/core/services/storage/shared_preferances/shared_preferences_service.dart';
import 'package:dooss_business_app/core/services/token_service.dart';
import 'package:dooss_business_app/core/utils/response_status_enum.dart';
import 'package:dooss_business_app/features/auth/data/source/remote/auth_remote_data_source_imp.dart';
import 'package:dooss_business_app/features/auth/presentation/manager/auth_log_out_stete.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthLogOutCubit extends Cubit<AuthLogOutStete> {
  AuthLogOutCubit({
    required this.remote,
    required this.secureStorage,
    required this.sharedPreference,
  }) : super(AuthLogOutStete());
  final AuthRemoteDataSourceImp remote;
  final SecureStorageService secureStorage;
  final SharedPreferencesService sharedPreference;

  //?----------------------------------------------------
  Future<void> logout() async {
    emit(state.copyWith(logOutStatus: ResponseStatusEnum.loading));

    try {
      // الحصول على الـ refresh token
      final refreshToken = await TokenService.getRefreshToken();

      if (refreshToken != null && refreshToken.isNotEmpty) {
        // إرسال طلب تسجيل الخروج للـ API
        final Either<Failure, String> result = await remote.logout(
          refreshToken,
        );

        result.fold(
          (failure) async {
            log("❌ AuthCubit - API logout failed: ${failure.message}");
            emit(
              state.copyWith(
                logOutStatus: ResponseStatusEnum.failure,
                errorLogOut: failure.message,
              ),
            );
            await appLocator<HiveService>().clearAllInCache();
            await appLocator<SharedPreferencesService>().removeLocaleInCache();
            await appLocator<SharedPreferencesService>().saveThemeModeInCache(
              true,
            );
          },
          (successMessage) async {
            log("✅ AuthCubit - API logout successful");

            //todo _clearLocalData();
            emit(state.copyWith(logOutStatus: ResponseStatusEnum.success));
            await appLocator<HiveService>().clearAllInCache();
            await appLocator<SharedPreferencesService>().removeLocaleInCache();
            await appLocator<SharedPreferencesService>().saveThemeModeInCache(
              true,
            );
          },
        );
      } else {
        log("⚠️ AuthCubit - No refresh token found, clearing local data only");
        // إذا لم يكن هناك refresh token، نقوم بحذف البيانات محلياً فقط
        //todo await _clearLocalData();
        emit(state.copyWith(logOutStatus: ResponseStatusEnum.success));
      }
    } catch (e) {
      log("❌ AuthCubit - Logout failed: $e");
      // في حالة الخطأ، نقوم بحذف البيانات محلياً على أي حال
      //todo await _clearLocalData();
      emit(
        state.copyWith(
          logOutStatus: ResponseStatusEnum.failure,
          errorLogOut: "Error",
        ),
      );
    }
  }

  //?----------------------------------------------------
}
