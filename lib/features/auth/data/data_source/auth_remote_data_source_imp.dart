import 'package:dartz/dartz.dart';

import '../../../../core/network/api.dart';
import '../../../../core/network/api_request.dart';
import '../../../../core/network/api_urls.dart';
import '../../../../core/network/failure.dart';
import '../../../../core/services/token_service.dart';
import '../../presentation/pages/verify_otp_page.dart';
import '../models/auth_response_model.dart';
import '../models/create_account_params_model.dart';
import '../models/user_model.dart';
import 'auth_remote_data_source.dart';

class AuthRemoteDataSourceImp implements AuthRemoteDataSource {
  final API api;

  AuthRemoteDataSourceImp({required this.api});

  @override
  Future<Either<Failure, AuthResponceModel>> signin(
    SigninParams params,
  ) async {
    print('🔍 Attempting to sign in with username: ${params.email.text}');
    
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
        print('❌ Sign in failed: ${failure.message}');
        return Left(failure);
      },
      (response) {
        print('✅ Sign in successful: $response');
        AuthResponceModel authresponse = AuthResponceModel.fromJson(response);
        return Right(authresponse);
      },
    );
  }

  @override
  Future<Either<Failure, UserModel>> register(
    CreateAccountParams params,
  ) async { 

    print('📝 Attempting to register with username: ${params.userName.text}');
    print('📱 Phone number: ${params.fullPhoneNumber}');
    print('🔑 Password: ${params.password.text}');
    print('📱 Full phone number length: ${params.fullPhoneNumber.length}');
    print('📱 Full phone number is empty: ${params.fullPhoneNumber.isEmpty}');
    
    final ApiRequest apiRequest = ApiRequest(
      url: ApiUrls.rigester,
      data: {
        "username": params.userName.text,
        "phone": params.fullPhoneNumber,
        "password": params.password.text,
      },
    );
    
    print('📤 API Request data: ${apiRequest.data}');

    final response = await api.post<Map<String, dynamic>>(apiRequest: apiRequest);
    
    return response.fold(
      (failure) {
        print('❌ Registration failed: ${failure.message}');
        return Left(failure);
      },
      (response) {
        print('✅ Registration successful: $response');
        try {
          // محاولة تحويل الـ response إلى UserModel
          UserModel user = UserModel.fromJson(response);
          print('✅ UserModel created successfully: ${user.name}');
          return Right(user);
        } catch (e) {
          print('❌ Error creating UserModel: $e');
          print('❌ Response structure: $response');
          // إذا فشل تحويل الـ response، نعيد error
          return Left(Failure(message: 'Invalid response format: $e'));
        }
      },
    );
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> resetPassword(
    String phoneNumber,
  ) async {
    print('🔍 Reset Password - Phone: $phoneNumber');
    print('🔍 Reset Password - URL: ${ApiUrls.forgetPassword}');
    print('🔍 Reset Password - Phone length: ${phoneNumber.length}');
    print('🔍 Reset Password - Phone starts with +: ${phoneNumber.startsWith('+')}');
    
    final ApiRequest apiRequest = ApiRequest(
      url: ApiUrls.forgetPassword,
      data: {
        "phone": phoneNumber,
      },
    );
    
    print('📤 API Request data: ${apiRequest.data}');
    print('📤 API Request URL: ${apiRequest.url}');
    
    final response = await api.post<Map<String, dynamic>>(
      apiRequest: apiRequest,
    );
    
    return response.fold(
      (failure) {
        print('❌ Reset Password failed: ${failure.message}');
        print('❌ Reset Password failure type: ${failure.runtimeType}');
        return Left(failure);
      },
      (result) {
        print('✅ Reset Password successful: $result');
        print('✅ Reset Password result type: ${result.runtimeType}');
        return Right(result);
      },
    );
  }

  @override
  Future<Either<Failure, String>> verifyOtp(
    VerifycodeParams params,
  ) async {
    print('🔍 Verify OTP - Phone: ${params.phoneNumber}');
    print('🔍 Verify OTP - Code: ${params.otp}');
    print('🔍 Verify OTP - Is Reset Password: ${params.isResetPassword}');
    
    // تحديد نوع الـ flow من خلال الـ parameter
    Map<String, dynamic> requestData = {
      "phone": params.phoneNumber,
      "code": params.otp,
    };
    
    // اختيار الـ URL الصحيح حسب نوع الـ flow
    String verifyUrl;
    if (params.isResetPassword) {
      print('🔄 Forget Password Flow - Using reset-password URL');
      verifyUrl = ApiUrls.verifyForgetPasswordOtp;
    } else {
      print('🔄 Signup Flow - Using verify URL');
      verifyUrl = ApiUrls.verifyOtp;
    }
    
    final ApiRequest apiRequest = ApiRequest(
      url: verifyUrl,
      data: requestData,
    );
    
    print('📤 API Request URL: ${apiRequest.url}');
    print('📤 API Request data: ${apiRequest.data}');
    
    final response = await api.post<Map<String, dynamic>>(
      apiRequest: apiRequest,
    );
    
    return response.fold(
      (failure) {
        print('❌ Verify OTP failed: ${failure.message}');
        return Left(failure);
      },
      (result) {
        print('✅ Verify OTP successful: $result');
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
            print('🔑 Token found: $token');
            TokenService.saveToken(token);
            print('💾 Token save operation initiated');
          } else {
            print('⚠️ No token found in response');
          }
          
          final String message = result["status"] ?? result["message"] ?? "OTP verified successfully";
          return Right(message);
        } catch (e) {
          print('❌ Error parsing verify OTP response: $e');
          return Left(Failure(message: 'Invalid response format: $e'));
        }
      },
    );
  }

  @override
  Future<Either<Failure, String>> verifyOtpForResetPassword(
    ResetPasswordParams params,
  ) async {
    print('🔍 Verify OTP for Reset Password - Phone: ${params.phoneNumber}');
    print('🔍 Verify OTP for Reset Password - New Password: ${params.newPassword}');
    
    final ApiRequest apiRequest = ApiRequest(
      url: ApiUrls.verifyForgetPasswordOtp, // استخدام URL الخاص بـ forget password
      data: {
        "phone": params.phoneNumber,
        "new_password": params.newPassword, // إرسال الـ new_password
      },
    );
    
    print('📤 API Request URL: ${apiRequest.url}');
    print('📤 API Request data: ${apiRequest.data}');
    
    final response = await api.post<Map<String, dynamic>>(
      apiRequest: apiRequest,
    );
    
    return response.fold(
      (failure) {
        print('❌ Verify OTP for Reset Password failed: ${failure.message}');
        return Left(failure);
      },
      (result) {
        print('✅ Verify OTP for Reset Password successful: $result');
        final String message = result["status"] ?? result["message"] ?? "Password reset successfully";
        return Right(message);
      },
    );
  }

  @override
  Future<Either<Failure, String>> newPassword(
    ResetPasswordParams params,
  ) async {
    print('🔍 Set New Password - Phone: ${params.phoneNumber}');
    print('🔍 Set New Password - New Password: ${params.newPassword}');
    
    final ApiRequest apiRequest = ApiRequest(
      url: ApiUrls.setNewPassword, // استخدام URL الجديد
      data: {
        "phone": params.phoneNumber,
        "new_password": params.newPassword,
        // لا نرسل code هنا لأن الـ OTP تم التحقق منه في الخطوة السابقة
      },
    );
    
    print('📤 API Request URL: ${apiRequest.url}');
    print('📤 API Request data: ${apiRequest.data}');
    
    final response = await api.post<Map<String, dynamic>>(
      apiRequest: apiRequest,
    );

    return response.fold(
      (failure) {
        print('❌ Set New Password failed: ${failure.message}');
        return Left(failure);
      },
      (result) {
        print('✅ Set New Password successful: $result');
        final String message = result["status"] ?? result["message"] ?? "Password changed successfully";
        return Right(message);
      },
    );
  }

  @override
  Future<Either<Failure, String>> logout(String refreshToken) async {
    print('🔍 Logout - Refresh Token: $refreshToken');
    
    final ApiRequest apiRequest = ApiRequest(
      url: ApiUrls.logout,
      data: {
        "refresh": refreshToken,
      },
    );
    
    print('📤 API Request URL: ${apiRequest.url}');
    print('📤 API Request data: ${apiRequest.data}');
    
    final response = await api.post<Map<String, dynamic>>(
      apiRequest: apiRequest,
    );

    return response.fold(
      (failure) {
        print('❌ Logout failed: ${failure.message}');
        return Left(failure);
      },
      (result) {
        print('✅ Logout successful: $result');
        // التعامل مع response كـ Map
        final String message = result["detail"] ?? result["status"] ?? result["message"] ?? "Logged out successfully";
        return Right(message);
      },
    );
  }

  @override
  Future<Either<Failure, String>> resendOtp(String phoneNumber) async {
    print('🔍 Resend OTP - Phone: $phoneNumber');
    
    final ApiRequest apiRequest = ApiRequest(
      url: ApiUrls.resendOtp,
      data: {
        "phone": phoneNumber,
      },
    );
    
    print('📤 API Request URL: ${apiRequest.url}');
    print('📤 API Request data: ${apiRequest.data}');
    
    final response = await api.post<Map<String, dynamic>>(
      apiRequest: apiRequest,
    );

    return response.fold(
      (failure) {
        print('❌ Resend OTP failed: ${failure.message}');
        return Left(failure);
      },
      (result) {
        print('✅ Resend OTP successful: $result');
        final String message = result["detail"] ?? result["status"] ?? result["message"] ?? "OTP resent successfully";
        return Right(message);
      },
    );
  }
}
