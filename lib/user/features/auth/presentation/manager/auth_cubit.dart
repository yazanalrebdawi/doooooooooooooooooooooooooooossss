import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:dooss_business_app/user/core/cubits/optimized_cubit.dart';
import 'package:dooss_business_app/user/core/services/locator_service.dart';
import 'package:dooss_business_app/user/core/services/storage/secure_storage/secure_storage_service.dart';
import 'package:dooss_business_app/user/core/services/storage/shared_preferances/shared_preferences_service.dart';
import 'package:dooss_business_app/user/core/utils/response_status_enum.dart';
import '../../../../core/constants/cache_keys.dart';
import '../../../../core/network/app_dio.dart';
import '../../../../core/network/failure.dart';
import '../../../../core/services/token_service.dart';
import '../../../../core/services/user_preferences_service.dart';
import '../../data/models/create_account_params_model.dart';
import '../../data/models/auth_response_model.dart';
import '../../data/models/user_model.dart';
import '../../data/source/remote/auth_remote_data_source_imp.dart';
import '../pages/verify_otp_page.dart';
import 'auth_state.dart';

class AuthCubit extends OptimizedCubit<AuthState> {
  final AuthRemoteDataSourceImp remote;
  final SecureStorageService secureStorage;
  final SharedPreferencesService sharedPreference;

  AuthCubit({
    required this.remote,
    required this.secureStorage,
    required this.sharedPreference,
  }) : super(AuthState());

  saveAuthRespnseModel(AuthResponceModel user) {
    safeEmit(state.copyWith(user: user));
  }

  void togglePasswordVisibility() {
    emitOptimized(
      state.copyWith(isObscurePassword: !(state.isObscurePassword ?? false)),
    );
  }

  void toggleRememberMe() {
    emitOptimized(state.copyWith(isRememberMe: !(state.isRememberMe ?? false)));
  }

  /// Load saved credentials if remember me was enabled
  Future<Map<String, String>?> loadRememberedCredentials() async {
    try {
      final isRememberMeEnabled = await sharedPreference.storagePreferences
          .getBool(CacheKeys.isRememberMeEnabled);

      if (isRememberMeEnabled == true) {
        final savedEmail = await sharedPreference.storagePreferences
            .getString(CacheKeys.rememberedEmail);
        final savedPassword =
            await secureStorage.storage.read(key: CacheKeys.rememberedPassword);

        if (savedEmail != null && savedPassword != null) {
          safeEmit(state.copyWith(isRememberMe: true));
          log("✅ Loaded remembered credentials");
          return {'email': savedEmail, 'password': savedPassword};
        }
      }
    } catch (e) {
      log("❌ Error loading remembered credentials: $e");
    }
    return null;
  }

  /// Save credentials if remember me is enabled
  Future<void> saveCredentialsIfRemembered(
      String email, String password) async {
    try {
      if (state.isRememberMe == true) {
        // Save email in SharedPreferences (non-sensitive)
        await sharedPreference.storagePreferences
            .setString(CacheKeys.rememberedEmail, email);
        // Save password in SecureStorage (sensitive)
        await secureStorage.storage
            .write(key: CacheKeys.rememberedPassword, value: password);
        // Save remember me flag
        await sharedPreference.storagePreferences
            .setBool(CacheKeys.isRememberMeEnabled, true);
        log("✅ Credentials saved (remember me enabled)");
      } else {
        // Clear saved credentials if remember me is disabled
        await sharedPreference.storagePreferences
            .remove(CacheKeys.rememberedEmail);
        await secureStorage.storage.delete(key: CacheKeys.rememberedPassword);
        await sharedPreference.storagePreferences
            .setBool(CacheKeys.isRememberMeEnabled, false);
        log("✅ Credentials cleared (remember me disabled)");
      }
    } catch (e) {
      log("❌ Error saving credentials: $e");
    }
  }

  Future<void> signIn(SigninParams params) async {
    log("🚀 AuthCubit - Starting sign in process");
    safeEmit(state.copyWith(isLoading: true));

    final Either<Failure, AuthResponceModel> result =
        await remote.signin(params);

    result.fold(
      (failure) {
        log("❌ AuthCubit - Sign in failed: ${failure.message}");
        safeEmit(state.copyWith(
          isLoading: false,
          error: failure.message,
          checkAuthState: CheckAuthState.error,
        ));
      },
      (authResponse) async {
        log("✅ AuthCubit - Sign in successful");

        if (authResponse.token.isNotEmpty) {
          TokenService.saveToken(authResponse.token);

          final cachedToken = await TokenService.getToken();
          if (cachedToken != null && cachedToken.isNotEmpty) {
            final isExpired = await TokenService.isTokenExpired();
            if (!isExpired) {
              appLocator<AppDio>().addTokenToHeader(cachedToken);
              log("Token added to Dio header");
            }
          }
          saveAuthRespnseModel(authResponse);
        }

        await secureStorage.saveAuthModel(authResponse);
        // Save user ID to TokenService so it can be retrieved later for message differentiation
        TokenService.saveUserId(authResponse.user.id.toString());
        log("✅ User ID saved in AuthCubit: ${authResponse.user.id}");

        // Save credentials if remember me is enabled
        await saveCredentialsIfRemembered(
            params.email.text, params.password.text);

        safeEmit(state.copyWith(
          isLoading: false,
          checkAuthState: CheckAuthState.signinSuccess,
          success: authResponse.message,
        ));
      },
    );
  }

  Future<void> register(CreateAccountParams params) async {
    log("🚀 AuthCubit - Starting register process");
    safeEmit(state.copyWith(isLoading: true));

    final Either<Failure, UserModel> result = await remote.register(params);

    result.fold(
      (failure) {
        log("❌ AuthCubit - Register failed: ${failure.message}");
        safeEmit(state.copyWith(
          isLoading: false,
          error: failure.message,
          checkAuthState: CheckAuthState.error,
        ));
      },
      (userModel) async {
        log("✅ AuthCubit - Register successful");
        log("✅ AuthCubit - User ID: ${userModel.id}, Name: '${userModel.name}', Phone: '${userModel.phone}'");
        log("✅ AuthCubit - UserModel details - ID: ${userModel.id}, Name length: ${userModel.name.length}, Phone length: ${userModel.phone.length}");
        
        // If name is empty, use username from params
        UserModel finalUserModel = userModel;
        if (userModel.name.isEmpty && params.userName.text.isNotEmpty) {
          log("⚠️ Name is empty in response, using username from params: ${params.userName.text}");
          finalUserModel = userModel.copyWith(name: params.userName.text);
          log("✅ Updated UserModel with name: '${finalUserModel.name}'");
        }
        
        // Ensure phone number is correct
        if (finalUserModel.phone != params.fullPhoneNumber) {
          log("⚠️ Phone mismatch - Model: '${finalUserModel.phone}', Params: '${params.fullPhoneNumber}'");
          finalUserModel = finalUserModel.copyWith(phone: params.fullPhoneNumber);
          log("✅ Updated UserModel with phone: '${finalUserModel.phone}'");
        }
        
        // Check if this is a +963 number (auto-verified)
        final isSyrianNumber = params.fullPhoneNumber.startsWith('+963');
        log("🔍 Is Syrian number (+963): $isSyrianNumber");
        
        // Save user ID for later use
        TokenService.saveUserId(finalUserModel.id.toString());
        log("✅ User ID saved in AuthCubit: ${finalUserModel.id}");
        
        // Check if token was already saved from registration response
        final savedToken = await TokenService.getToken();
        log("🔍 Saved token exists: ${savedToken != null && savedToken.isNotEmpty}");
        
        // Save UserModel in secure storage
        // For +963 numbers, save complete AuthModel with token if available
        try {
          final token = savedToken ?? '';
          final message = isSyrianNumber 
              ? "Account created and auto-verified (Syrian number)."
              : "Account created successfully! Please verify your phone number.";
          
          log("🔍 Creating AuthModel - Name: '${finalUserModel.name}', Phone: '${finalUserModel.phone}', Token: ${token.isNotEmpty ? 'exists' : 'empty'}");
          
          final authModel = AuthResponceModel(
            message: message,
            user: finalUserModel,
            token: token,
            refreshToken: token.isNotEmpty ? token : '',
            expiry: token.isNotEmpty ? DateTime.now().add(const Duration(hours: 1)) : null,
          );
          
          await secureStorage.saveAuthModel(authModel);
          log("✅ AuthModel saved successfully");
          log("✅ AuthModel details - Name: '${authModel.user.name}', Phone: '${authModel.user.phone}', ID: ${authModel.user.id}, Has Token: ${authModel.token.isNotEmpty}");
          
          // Verify what was saved
          final verifyAuth = await secureStorage.getAuthModel();
          if (verifyAuth != null) {
            log("✅ Verification - Saved AuthModel has - Name: '${verifyAuth.user.name}', Phone: '${verifyAuth.user.phone}', ID: ${verifyAuth.user.id}");
          } else {
            log("❌ Verification - No AuthModel found after saving!");
          }
          
          // If token exists, add it to Dio header
          if (token.isNotEmpty) {
            appLocator<AppDio>().addTokenToHeader(token);
            log("✅ Token added to Dio header");
          }
        } catch (e, stackTrace) {
          log("❌ Error saving AuthModel: $e");
          log("❌ Stack trace: $stackTrace");
        }
        
        safeEmit(state.copyWith(
          isLoading: false,
          checkAuthState: CheckAuthState.success,
          success: isSyrianNumber
              ? "Account created and auto-verified!"
              : "Account created successfully! Please verify your phone number.",
        ));
      },
    );
  }

  Future<void> resetPassword(String phoneNumber) async {
    log("🚀 AuthCubit - Starting reset password for: $phoneNumber");
    safeEmit(state.copyWith(isLoading: true));

    final Either<Failure, Map<String, dynamic>> result =
        await remote.resetPassword(phoneNumber);

    result.fold(
      (failure) {
        log("❌ AuthCubit - Reset password failed: ${failure.message}");
        safeEmit(state.copyWith(
          isLoading: false,
          error: failure.message,
          checkAuthState: CheckAuthState.error,
        ));
      },
      (successResponse) {
        log("✅ AuthCubit - Reset password successful");
        safeEmit(state.copyWith(
          isLoading: false,
          checkAuthState: CheckAuthState.success,
          success: successResponse["message"] ?? "OTP sent successfully",
        ));
      },
    );
  }

  Future<void> verifyOtp(VerifycodeParams params) async {
    log("🚀 AuthCubit - Starting OTP verification for: ${params.phoneNumber}");
    safeEmit(state.copyWith(isLoading: true));

    final Either<Failure, String> result = await remote.verifyOtp(params);

    result.fold(
      (failure) {
        log("❌ AuthCubit - OTP verification failed: ${failure.message}");
        safeEmit(state.copyWith(
          isLoading: false,
          error: failure.message,
          checkAuthState: CheckAuthState.error,
        ));
      },
      (successMessage) {
        log("✅ AuthCubit - OTP verification successful");
        safeEmit(state.copyWith(
          isLoading: false,
          checkAuthState: CheckAuthState.success,
          success: successMessage,
        ));
      },
    );
  }

  Future<void> verifyOtpForResetPassword(ResetPasswordParams params) async {
    log("🚀 AuthCubit - Starting OTP verification for reset password: ${params.phoneNumber}");
    safeEmit(state.copyWith(isLoading: true));

    final Either<Failure, String> result =
        await remote.verifyOtpForResetPassword(params);

    result.fold(
      (failure) {
        log("❌ AuthCubit - OTP verification for reset password failed: ${failure.message}");
        safeEmit(state.copyWith(
          isLoading: false,
          error: failure.message,
          checkAuthState: CheckAuthState.error,
        ));
      },
      (successMessage) {
        log("✅ AuthCubit - OTP verification for reset password successful");
        safeEmit(state.copyWith(
          isLoading: false,
          checkAuthState: CheckAuthState.success,
          success: successMessage,
        ));
      },
    );
  }

  Future<void> createNewPassword(ResetPasswordParams params) async {
    log("🚀 AuthCubit - Starting new password creation");
    safeEmit(state.copyWith(isLoading: true));

    final Either<Failure, String> result = await remote.newPassword(params);

    result.fold(
      (failure) {
        log("❌ AuthCubit - New password creation failed: ${failure.message}");
        safeEmit(state.copyWith(
          isLoading: false,
          error: failure.message,
          checkAuthState: CheckAuthState.error,
        ));
      },
      (successMessage) {
        log("✅ AuthCubit - New password creation successful");
        safeEmit(state.copyWith(
          isLoading: false,
          checkAuthState: CheckAuthState.success,
          success: successMessage,
        ));
      },
    );
  }

  Future<void> resendOtp(String phoneNumber) async {
    log("🚀 AuthCubit - Starting resend OTP for: $phoneNumber");
    safeEmit(state.copyWith(isLoading: true));

    final Either<Failure, String> result = await remote.resendOtp(phoneNumber);

    result.fold(
      (failure) {
        log("❌ AuthCubit - Resend OTP failed: ${failure.message}");
        safeEmit(state.copyWith(
          isLoading: false,
          error: failure.message,
          checkAuthState: CheckAuthState.error,
        ));
      },
      (successMessage) {
        log("✅ AuthCubit - Resend OTP successful");
        safeEmit(state.copyWith(
          isLoading: false,
          checkAuthState: CheckAuthState.resendOtpSuccess,
          success: successMessage,
        ));
      },
    );
  }

  Future<void> logout() async {
    log("🚀 AuthCubit - Starting logout process");
    safeEmit(state.copyWith(logOutStatus: ResponseStatusEnum.loading));

    try {
      final refreshToken = await TokenService.getRefreshToken();
      if (refreshToken != null && refreshToken.isNotEmpty) {
        final Either<Failure, String> result =
            await remote.logout(refreshToken);

        result.fold(
          (failure) async {
            log("❌ AuthCubit - API logout failed: ${failure.message}");
            await _clearLocalData();
            safeEmit(state.copyWith(
              logOutStatus: ResponseStatusEnum.failure,
              errorLogOut: failure.message,
            ));
          },
          (successMessage) async {
            log("✅ AuthCubit - API logout successful");
            await _clearLocalData();
            safeEmit(state.copyWith(
              logOutStatus: ResponseStatusEnum.success,
            ));
          },
        );
      } else {
        log("⚠️ No refresh token found, clearing local data only");
        await _clearLocalData();
        safeEmit(state.copyWith(
          isLoading: false,
          checkAuthState: CheckAuthState.logoutSuccess,
          success: "Logged out successfully",
        ));
      }
    } catch (e) {
      log("❌ AuthCubit - Logout failed: $e");
      await _clearLocalData();
      safeEmit(state.copyWith(
        isLoading: false,
        error: "Logout failed: $e",
        checkAuthState: CheckAuthState.error,
      ));
    }
  }

  Future<void> _clearLocalData() async {
    try {
      await TokenService.clearToken();
      await UserPreferencesService.clearAuthData();
      log("✅ AuthCubit - Local data cleared successfully");
    } catch (e) {
      log("❌ AuthCubit - Error clearing local data: $e");
    }
  }

  void resetState() {
    emitOptimized(AuthState());
  }

  @override
  Future<void> close() {
    log("🔒 AuthCubit - Closing");
    return super.close();
  }
}
