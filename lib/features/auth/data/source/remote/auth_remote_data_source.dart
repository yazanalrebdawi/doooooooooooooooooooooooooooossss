import 'package:dartz/dartz.dart';

import '../../../../../core/network/failure.dart';
import '../../../presentation/pages/verify_otp_page.dart';
import '../../models/auth_response_model.dart';
import '../../models/create_account_params_model.dart';
import '../../models/user_model.dart';

abstract class AuthRemoteDataSource {
  //?----------------------------------------------------------------------

  //* LogIn
  Future<Either<Failure, AuthResponceModel>> signin(SigninParams params);

  //* Sign Up
  Future<Either<Failure, UserModel>> register(CreateAccountParams params);

  //* Forgot Password
  Future<Either<Failure, Map<String, dynamic>>> resetPassword(String email);

  //*  بعد ما المستخدم يستلم كود التحقق SMS ويكتبه.
  Future<Either<Failure, String>> verifyOtp(VerifycodeParams params);

  //* لما المستخدم يكتب الـ OTP ويحدد كلمة سر جديدة بنفس الخطوة
  Future<Either<Failure, String>> verifyOtpForResetPassword(
    ResetPasswordParams params,
  );

  //* لما الـ OTP تم التحقق منه مسبقًا والمستخدم جاهز يحط كلمة سر جديدة.
  Future<Either<Failure, String>> newPassword(ResetPasswordParams params);

  //* logOut
  Future<Either<Failure, String>> logout(String refreshToken);

  //* لما المستخدم ما استلم كود التحقق أو خلص وقت الكود وبدو يعيد إرساله.
  Future<Either<Failure, String>> resendOtp(String phoneNumber);
}
