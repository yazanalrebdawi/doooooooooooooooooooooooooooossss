import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:dooss_business_app/core/app/source/local/user_storage_service.dart';
import 'package:dooss_business_app/core/cubits/optimized_cubit.dart';
import 'package:dooss_business_app/core/network/app_dio.dart';
import 'package:dooss_business_app/core/services/locator_service.dart';
import 'package:dooss_business_app/core/services/storage/secure_storage/secure_storage_service.dart';
import 'package:dooss_business_app/core/services/storage/shared_preferances/shared_preferences_service.dart';
import 'package:dooss_business_app/core/utils/response_status_enum.dart';
import '../../../../core/services/token_service.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/services/user_preferences_service.dart';
import '../../../../core/network/failure.dart';
import '../../data/source/remote/auth_remote_data_source_imp.dart'
    show AuthRemoteDataSourceImp;
import '../../data/models/create_account_params_model.dart';
import '../../data/models/auth_response_model.dart';
import '../../data/models/user_model.dart';
import '../pages/verify_otp_page.dart';
import '../manager/auth_state.dart';

class AuthCubit extends OptimizedCubit<AuthState> {
  final AuthRemoteDataSourceImp remote;
  final SecureStorageService secureStorage;
  final SharedPreferencesService sharedPreference;

  AuthCubit({
    required this.remote,
    required this.secureStorage,
    required this.sharedPreference,
  }) : super(AuthState());

  //?--------------------------------------------------------------------------------
  /// حفظ بيانات المستخدم مؤقتاً
  saveAuthRespnseModel(AuthResponceModel user) {
    safeEmit(state.copyWith(user: user));
  }

  //?--------------------------------------------------------------------------------
  /// تبديل إظهار/إخفاء كلمة المرور
  void togglePasswordVisibility() {
    emitOptimized(
      state.copyWith(isObscurePassword: !(state.isObscurePassword ?? false)),
    );
  }

  /// تبديل حالة "تذكرني"
  void toggleRememberMe() {
    emitOptimized(state.copyWith(isRememberMe: !(state.isRememberMe ?? false)));
  }

  //?--------------------------------------------------------------------------------
  /// تسجيل الدخول
  Future<void> signIn(SigninParams params) async {
    log("🚀 AuthCubit - Starting sign in process");
    safeEmit(state.copyWith(isLoading: true));

    final Either<Failure, AuthResponceModel> result = await remote.signin(
      params,
    );

    result.fold(
      (failure) {
        log("❌ AuthCubit - Sign in failed: ${failure.message}");
        safeEmit(
          state.copyWith(
            isLoading: false,
            error: failure.message,
            checkAuthState: CheckAuthState.error,
          ),
        );
      },
      (authResponse) async {
        log("✅ AuthCubit - Sign in successful");
        log("🔍 AuthCubit - Token: ${authResponse.token}");

        if (authResponse.token.isNotEmpty) {
          final cachedToken = await TokenService.getToken();

          if (cachedToken != null && cachedToken.isNotEmpty) {
            final isExpired = await TokenService.isTokenExpired();
            if (!isExpired) {
              appLocator<AppDio>().addTokenToHeader(cachedToken);
              log("Token added to Dio header");
            }
          }

          saveAuthRespnseModel(authResponse);
          final isAuthenticated = await AuthService.isAuthenticated();
          log("🔍 AuthCubit - Is authenticated: $isAuthenticated");
        } else {
          log("⚠️ AuthCubit - Token is empty");
        }

        if (authResponse.user != null) {
          await secureStorage.saveAuthModel(authResponse);
        }

        safeEmit(
          state.copyWith(
            isLoading: false,
            checkAuthState: CheckAuthState.signinSuccess,
            success: authResponse.message,
          ),
        );
      },
    );
  }

  //?--------------------------------------------------------------------------------
  /// إنشاء حساب جديد
  Future<void> register(CreateAccountParams params) async {
    log("🚀 AuthCubit - Starting register process");
    safeEmit(state.copyWith(isLoading: true));

    final Either<Failure, UserModel> result = await remote.register(params);

    result.fold(
      (failure) {
        log("❌ AuthCubit - Register failed: ${failure.message}");
        safeEmit(
          state.copyWith(
            isLoading: false,
            error: failure.message,
            checkAuthState: CheckAuthState.error,
          ),
        );
      },
      (userModel) async {
        log("✅ AuthCubit - Register successful");
        safeEmit(
          state.copyWith(
            isLoading: false,
            checkAuthState: CheckAuthState.success,
            success:
                "Account created successfully! Please verify your phone number.",
          ),
        );
      },
    );
  }

  //?--------------------------------------------------------------------------------
  /// طلب كود التحقق (OTP)
  Future<void> resetPassword(String phoneNumber) async {
    log("🚀 AuthCubit - Starting reset password process for: $phoneNumber");
    safeEmit(state.copyWith(isLoading: true));

    final Either<Failure, Map<String, dynamic>> result = await remote
        .resetPassword(phoneNumber);

    result.fold(
      (failure) {
        log("❌ AuthCubit - Reset password failed: ${failure.message}");
        safeEmit(
          state.copyWith(
            isLoading: false,
            error: failure.message,
            checkAuthState: CheckAuthState.error,
          ),
        );
      },
      (successResponse) {
        log("✅ AuthCubit - Reset password successful");
        safeEmit(
          state.copyWith(
            isLoading: false,
            checkAuthState: CheckAuthState.success,
            success: successResponse["message"] ?? "OTP sent successfully",
          ),
        );
      },
    );
  }

  //?--------------------------------------------------------------------------------
  /// التحقق من كود OTP
  Future<void> verifyOtp(VerifycodeParams params) async {
    log("🚀 AuthCubit - Starting OTP verification for: ${params.phoneNumber}");
    safeEmit(state.copyWith(isLoading: true));

    final Either<Failure, String> result = await remote.verifyOtp(params);

    result.fold(
      (failure) {
        log("❌ AuthCubit - OTP verification failed: ${failure.message}");
        safeEmit(
          state.copyWith(
            isLoading: false,
            error: failure.message,
            checkAuthState: CheckAuthState.error,
          ),
        );
      },
      (successMessage) async {
        log("✅ AuthCubit - OTP verification successful");
        safeEmit(
          state.copyWith(
            isLoading: false,
            checkAuthState: CheckAuthState.success,
            success: successMessage,
          ),
        );
      },
    );
  }

  //?--------------------------------------------------------------------------------
  /// التحقق من كود OTP مع إعادة تعيين كلمة المرور
  Future<void> verifyOtpForResetPassword(ResetPasswordParams params) async {
    log(
      "🚀 AuthCubit - Starting OTP verification for reset password: ${params.phoneNumber}",
    );
    safeEmit(state.copyWith(isLoading: true));

    final Either<Failure, String> result = await remote
        .verifyOtpForResetPassword(params);

    result.fold(
      (failure) {
        log(
          "❌ AuthCubit - OTP verification for reset password failed: ${failure.message}",
        );
        safeEmit(
          state.copyWith(
            isLoading: false,
            error: failure.message,
            checkAuthState: CheckAuthState.error,
          ),
        );
      },
      (successMessage) {
        log("✅ AuthCubit - OTP verification for reset password successful");
        safeEmit(
          state.copyWith(
            isLoading: false,
            checkAuthState: CheckAuthState.success,
            success: successMessage,
          ),
        );
      },
    );
  }

  //?--------------------------------------------------------------------------------
  /// إنشاء كلمة مرور جديدة
  Future<void> createNewPassword(ResetPasswordParams params) async {
    log("🚀 AuthCubit - Starting new password creation");
    safeEmit(state.copyWith(isLoading: true));

    final Either<Failure, String> result = await remote.newPassword(params);

    result.fold(
      (failure) {
        log("❌ AuthCubit - New password creation failed: ${failure.message}");
        safeEmit(
          state.copyWith(
            isLoading: false,
            error: failure.message,
            checkAuthState: CheckAuthState.error,
          ),
        );
      },
      (successMessage) {
        log("✅ AuthCubit - New password creation successful");
        safeEmit(
          state.copyWith(
            isLoading: false,
            checkAuthState: CheckAuthState.success,
            success: successMessage,
          ),
        );
      },
    );
  }

  //?--------------------------------------------------------------------------------
  /// إعادة إرسال كود OTP
  Future<void> resendOtp(String phoneNumber) async {
    log("🚀 AuthCubit - Starting resend OTP for: $phoneNumber");
    safeEmit(state.copyWith(isLoading: true));

    final Either<Failure, String> result = await remote.resendOtp(phoneNumber);

    result.fold(
      (failure) {
        log("❌ AuthCubit - Resend OTP failed: ${failure.message}");
        safeEmit(
          state.copyWith(
            isLoading: false,
            error: failure.message,
            checkAuthState: CheckAuthState.error,
          ),
        );
      },
      (successMessage) {
        log("✅ AuthCubit - Resend OTP successful");
        safeEmit(
          state.copyWith(
            isLoading: false,
            checkAuthState: CheckAuthState.resendOtpSuccess,
            success: successMessage,
          ),
        );
      },
    );
  }

  //?--------------------------------------------------------------------------------
  /// تسجيل الخروج
  Future<void> logout() async {
    log("🚀 AuthCubit - Starting logout process");
    safeEmit(state.copyWith(logOutStatus: ResponseStatusEnum.loading));

    try {
      final refreshToken = await TokenService.getRefreshToken();
      log("🔍 AuthCubit - Refresh token: $refreshToken");

      if (refreshToken != null && refreshToken.isNotEmpty) {
        final Either<Failure, String> result = await remote.logout(
          refreshToken,
        );

        result.fold(
          (failure) {
            log("❌ AuthCubit - API logout failed: ${failure.message}");
            _clearLocalData();
            emit(
              state.copyWith(
                logOutStatus: ResponseStatusEnum.failure,
                errorLogOut: failure.message,
              ),
            );
          },
          (successMessage) {
            log("✅ AuthCubit - API logout successful");
            _clearLocalData();
            emit(state.copyWith(logOutStatus: ResponseStatusEnum.success));
          },
        );
      } else {
        log("⚠️ AuthCubit - No refresh token found, clearing local data only");
        await _clearLocalData();
        safeEmit(
          state.copyWith(
            isLoading: false,
            checkAuthState: CheckAuthState.logoutSuccess,
            success: "Logged out successfully",
          ),
        );
      }
    } catch (e) {
      log("❌ AuthCubit - Logout failed: $e");
      await _clearLocalData();
      emit(
        state.copyWith(
          isLoading: false,
          error: "Logout failed: $e",
          checkAuthState: CheckAuthState.error,
        ),
      );
    }
  }

  //?--------------------------------------------------------------------------------
  /// حذف البيانات المحلية
  Future<void> _clearLocalData() async {
    try {
      await TokenService.clearToken();
      log("✅ AuthCubit - All tokens cleared successfully");

      await UserPreferencesService.clearAuthData();
      log("✅ AuthCubit - User data cleared successfully");
    } catch (e) {
      log("❌ AuthCubit - Error clearing local data: $e");
    }
  }

  //?--------------------------------------------------------------------------------
  /// إعادة تعيين الحالة إلى الحالة الأولية
  void resetState() {
    emitOptimized(AuthState());
  }

  //?--------------------------------------------------------------------------------
  @override
  Future<void> close() {
    log("🔒 AuthCubit - Closing");
    return super.close();
  }
}
