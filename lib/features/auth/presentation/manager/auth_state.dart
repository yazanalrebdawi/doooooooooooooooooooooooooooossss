// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dooss_business_app/core/utils/response_status_enum.dart';
import 'package:dooss_business_app/features/auth/data/models/auth_response_model.dart';

class AuthState {
  final CheckAuthState? checkAuthState;
  final bool isLoading;
  final String? error;
  final String? success;
  final String? resetCode;
  final bool? isObscurePassword;
  final bool? isFingerprintAvailable;
  final bool? isRememberMe;
  //?-------------------------------------------
  final AuthResponceModel? user;
  final ResponseStatusEnum? logOutStatus;
  final String? errorLogOut;
  //?-------------------------------------------

  AuthState({
    this.logOutStatus = ResponseStatusEnum.initial,
    this.user,
    this.errorLogOut,
    this.checkAuthState,
    this.isLoading = false,
    this.error,
    this.success,
    this.isObscurePassword = true,
    this.isFingerprintAvailable = false,
    this.isRememberMe = false,
    this.resetCode,
  });

  AuthState copyWith({
    String? errorLogOut,
    ResponseStatusEnum? logOutStatus,
    AuthResponceModel? user,
    CheckAuthState? checkAuthState,
    bool? isLoading,
    String? error,
    String? success,
    bool? isObscurePassword,
    bool? isFingerprintAvailable,
    bool? isRememberMe,
    String? resetCode,
  }) {
    return AuthState(
      errorLogOut: errorLogOut,
      logOutStatus: logOutStatus ?? this.logOutStatus,
      user: user ?? this.user,
      checkAuthState: checkAuthState ?? CheckAuthState.none,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      success: success,
      isObscurePassword: isObscurePassword ?? true,
      isFingerprintAvailable: isFingerprintAvailable,
      isRememberMe: isRememberMe ?? false,
      resetCode: resetCode ?? this.resetCode,
    );
  }
}

enum CheckAuthState {
  none,
  isPinSet,
  isLoading,
  success,
  signinSuccess,
  logoutSuccess,
  resendOtpSuccess,
  error,
}
