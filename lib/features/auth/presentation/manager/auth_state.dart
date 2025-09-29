// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dooss_business_app/features/auth/data/models/auth_response_model.dart';

class AuthState {
  final CheckAuthState? checkAuthState;
  final bool isLoading;
  final String? error;
  final String? userToken;
  final String? success;
  final String? resetCode;
  final bool? isObscurePassword;
  final bool? isFingerprintAvailable;
  final bool? isRememberMe;
  AuthState({
    this.checkAuthState,
    this.isLoading = false,
    this.error,
    this.userToken,
    this.success,
    this.isObscurePassword = true,
    this.isFingerprintAvailable = false,
    this.isRememberMe = false,
    this.resetCode,
  });

  AuthState copyWith({
    CheckAuthState? checkAuthState,
    bool? isLoading,
    String? error,
    String? userToken,
    String? success,
    bool? isObscurePassword,
    bool? isFingerprintAvailable,
    bool? isRememberMe,
    String? resetCode,
  }) {
    return AuthState(
      checkAuthState: checkAuthState ?? CheckAuthState.none,
      isLoading: isLoading ?? this.isLoading,
      userToken: userToken ?? this.userToken,
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
