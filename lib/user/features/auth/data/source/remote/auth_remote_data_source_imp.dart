import 'dart:developer';
import 'package:dartz/dartz.dart';
import '../../../../../core/network/api.dart';
import '../../../../../core/network/api_request.dart';
import '../../../../../core/network/api_urls.dart';
import '../../../../../core/network/failure.dart';
import '../../../../../core/services/token_service.dart';
import '../../../presentation/pages/verify_otp_page.dart';
import '../../models/auth_response_model.dart';
import '../../models/create_account_params_model.dart';
import '../../models/user_model.dart';
import 'auth_remote_data_source.dart';

class AuthRemoteDataSourceImp implements AuthRemoteDataSource {
  final API api;

  AuthRemoteDataSourceImp({required this.api});
  //?----------------------------------------------------------------------------------------

  //* LogIn

  @override
  Future<Either<Failure, AuthResponceModel>> signin(SigninParams params) async {
    log('🔍 Attempting to sign in with username: ${params.email.text}');

    final ApiRequest apiRequest = ApiRequest(
      url: ApiUrls.login,
      data: {
        "username": params.email.text, // تغيير من email إلى username
        "password": params.password.text,
      },
    );

    final respons = await api.post<Map<String, dynamic>>(
      apiRequest: apiRequest,
    );

    return respons.fold(
      (failure) {
        log('❌ Sign in failed: ${failure.message}');
        return Left(failure);
      },
      (response) {
        log('✅ Sign in successful: $response');
        AuthResponceModel authresponse = AuthResponceModel.fromJson(response);
        return Right(authresponse);
      },
    );
  }

  //?----------------------------------------------------------------------------------------

  //* Sign Up

  @override
  Future<Either<Failure, UserModel>> register(
    CreateAccountParams params,
  ) async {
    log('📝 Attempting to register with username: ${params.userName.text}');
    log('📱 Phone number: ${params.fullPhoneNumber}');
    log('🔑 Password: ${params.password.text}');
    log('📱 Full phone number length: ${params.fullPhoneNumber.length}');
    log('📱 Full phone number is empty: ${params.fullPhoneNumber.isEmpty}');

    final ApiRequest apiRequest = ApiRequest(
      url: ApiUrls.rigester,
      data: {
        "username": params.userName.text,
        "phone": params.fullPhoneNumber,
        "password": params.password.text,
      },
    );

    log('📤 API Request data: ${apiRequest.data}');

    final response = await api.post<Map<String, dynamic>>(
      apiRequest: apiRequest,
    );

    return response.fold(
      (failure) {
        log('❌ Registration failed: ${failure.message}');
        return Left(failure);
      },
      (response) {
        log('✅ Registration successful: $response');
        try {
          UserModel user = UserModel.fromJson(response);
          log('✅ UserModel created successfully: ${user.name}');
          return Right(user);
        } catch (e) {
          log('❌ Error creating UserModel: $e');
          log('❌ Response structure: $response');
          return Left(Failure(message: 'Invalid response format: $e'));
        }
      },
    );
  }

  //?----------------------------------------------------------------------------------------

  //* Forgot Password

  @override
  Future<Either<Failure, Map<String, dynamic>>> resetPassword(
    String phoneNumber,
  ) async {
    log('🔍 Reset Password - Phone: $phoneNumber');
    log('🔍 Reset Password - URL: ${ApiUrls.forgetPassword}');
    log('🔍 Reset Password - Phone length: ${phoneNumber.length}');
    log(
      '🔍 Reset Password - Phone starts with +: ${phoneNumber.startsWith('+')}',
    );

    final ApiRequest apiRequest = ApiRequest(
      url: ApiUrls.forgetPassword,
      data: {"phone": phoneNumber},
    );

    log('📤 API Request data: ${apiRequest.data}');
    log('📤 API Request URL: ${apiRequest.url}');

    final response = await api.post<Map<String, dynamic>>(
      apiRequest: apiRequest,
    );

    return response.fold(
      (failure) {
        log('❌ Reset Password failed: ${failure.message}');
        log('❌ Reset Password failure type: ${failure.runtimeType}');
        return Left(failure);
      },
      (result) {
        log('✅ Reset Password successful: $result');
        log('✅ Reset Password result type: ${result.runtimeType}');
        return Right(result);
      },
    );
  }

  //?----------------------------------------------------------------------------------------

  //*  بعد ما المستخدم يستلم كود التحقق SMS ويكتبه.
  @override
  Future<Either<Failure, String>> verifyOtp(VerifycodeParams params) async {
    log('🔍 Verify OTP - Phone: ${params.phoneNumber}');
    log('🔍 Verify OTP - Code: ${params.otp}');
    log('🔍 Verify OTP - Is Reset Password: ${params.isResetPassword}');

    // تحديد نوع الـ flow من خلال الـ parameter
    Map<String, dynamic> requestData = {
      "phone": params.phoneNumber,
      "code": params.otp,
    };

    // اختيار الـ URL الصحيح حسب نوع الـ flow
    String verifyUrl;
    if (params.isResetPassword) {
      log('🔄 Forget Password Flow - Using reset-password URL');
      verifyUrl = ApiUrls.verifyForgetPasswordOtp;
    } else {
      log('🔄 Signup Flow - Using verify URL');
      verifyUrl = ApiUrls.verifyOtp;
    }

    final ApiRequest apiRequest = ApiRequest(url: verifyUrl, data: requestData);

    log('📤 API Request URL: ${apiRequest.url}');
    log('📤 API Request data: ${apiRequest.data}');

    final response = await api.post<Map<String, dynamic>>(
      apiRequest: apiRequest,
    );

    return response.fold(
      (failure) {
        log('❌ Verify OTP failed: ${failure.message}');
        return Left(failure);
      },
      (result) {
        log('✅ Verify OTP successful: $result');
        try {
          // محاولة استخراج الـ token من الـ response
          String? token;
          if (result.containsKey('token')) {
            token = result['token'];
          } else if (result.containsKey('access')) {
            token = result['access'];
          } else if (result.containsKey('access_token')) {
            token = result['access_token'];
          }

          if (token != null) {
            log('🔑 Token found: $token');
            TokenService.saveToken(token);
            log('💾 Token save operation initiated');
          } else {
            log('⚠️ No token found in response');
          }

          final String message =
              result["status"] ??
              result["message"] ??
              "OTP verified successfully";
          return Right(message);
        } catch (e) {
          log('❌ Error parsing verify OTP response: $e');
          return Left(Failure(message: 'Invalid response format: $e'));
        }
      },
    );
  }

  //?----------------------------------------------------------------------------------------

  //* لما المستخدم يكتب الـ OTP ويحدد كلمة سر جديدة بنفس الخطوة
  @override
  Future<Either<Failure, String>> verifyOtpForResetPassword(
    ResetPasswordParams params,
  ) async {
    log('🔍 Verify OTP for Reset Password - Phone: ${params.phoneNumber}');
    log(
      '🔍 Verify OTP for Reset Password - New Password: ${params.newPassword}',
    );

    final ApiRequest apiRequest = ApiRequest(
      url:
          ApiUrls
              .verifyForgetPasswordOtp, // استخدام URL الخاص بـ forget password
      data: {
        "phone": params.phoneNumber,
        "new_password": params.newPassword, // إرسال الـ new_password
      },
    );

    log('📤 API Request URL: ${apiRequest.url}');
    log('📤 API Request data: ${apiRequest.data}');

    final response = await api.post<Map<String, dynamic>>(
      apiRequest: apiRequest,
    );

    return response.fold(
      (failure) {
        log('❌ Verify OTP for Reset Password failed: ${failure.message}');
        return Left(failure);
      },
      (result) {
        log('✅ Verify OTP for Reset Password successful: $result');
        final String message =
            result["status"] ??
            result["message"] ??
            "Password reset successfully";
        return Right(message);
      },
    );
  }

  //?----------------------------------------------------------------------------------------

  //* لما الـ OTP تم التحقق منه مسبقًا والمستخدم جاهز يحط كلمة سر جديدة.
  @override
  Future<Either<Failure, String>> newPassword(
    ResetPasswordParams params,
  ) async {
    log('🔍 Set New Password - Phone: ${params.phoneNumber}');
    log('🔍 Set New Password - New Password: ${params.newPassword}');

    final ApiRequest apiRequest = ApiRequest(
      url: ApiUrls.setNewPassword, // استخدام URL الجديد
      data: {
        "phone": params.phoneNumber,
        "new_password": params.newPassword,
        // لا نرسل code هنا لأن الـ OTP تم التحقق منه في الخطوة السابقة
      },
    );

    log('📤 API Request URL: ${apiRequest.url}');
    log('📤 API Request data: ${apiRequest.data}');

    final response = await api.post<Map<String, dynamic>>(
      apiRequest: apiRequest,
    );

    return response.fold(
      (failure) {
        log('❌ Set New Password failed: ${failure.message}');
        return Left(failure);
      },
      (result) {
        log('✅ Set New Password successful: $result');
        final String message =
            result["status"] ??
            result["message"] ??
            "Password changed successfully";
        return Right(message);
      },
    );
  }

  //?----------------------------------------------------------------------------------------

  //* logOut
  @override
  Future<Either<Failure, String>> logout(String refreshToken) async {
    log('🔍 Logout - Refresh Token: $refreshToken');

    final ApiRequest apiRequest = ApiRequest(
      url: ApiUrls.logout,
      data: {"refresh": refreshToken},
    );

    log('📤 API Request URL: ${apiRequest.url}');
    log('📤 API Request data: ${apiRequest.data}');

    final response = await api.post<Map<String, dynamic>>(
      apiRequest: apiRequest,
    );

    return response.fold(
      (failure) {
        log('❌ Logout failed: ${failure.message}');
        return Left(failure);
      },
      (result) {
        log('✅ Logout successful: $result');
        // التعامل مع response كـ Map
        final String message =
            result["detail"] ??
            result["status"] ??
            result["message"] ??
            "Logged out successfully";
        return Right(message);
      },
    );
  }

  //?----------------------------------------------------------------------------------------

  //* لما المستخدم ما استلم كود التحقق أو خلص وقت الكود وبدو يعيد إرساله.
  @override
  Future<Either<Failure, String>> resendOtp(String phoneNumber) async {
    log('🔍 Resend OTP - Phone: $phoneNumber');

    final ApiRequest apiRequest = ApiRequest(
      url: ApiUrls.resendOtp,
      data: {"phone": phoneNumber},
    );

    log('📤 API Request URL: ${apiRequest.url}');
    log('📤 API Request data: ${apiRequest.data}');

    final response = await api.post<Map<String, dynamic>>(
      apiRequest: apiRequest,
    );

    return response.fold(
      (failure) {
        log('❌ Resend OTP failed: ${failure.message}');
        return Left(failure);
      },
      (result) {
        log('✅ Resend OTP successful: $result');
        final String message =
            result["detail"] ??
            result["status"] ??
            result["message"] ??
            "OTP resent successfully";
        return Right(message);
      },
    );
  }

  //?----------------------------------------------------------------------------------------
}
