import 'package:dartz/dartz.dart';

import '../../../../core/network/failure.dart';
import '../../presentation/pages/verify_otp_page.dart';
import '../models/auth_response_model.dart';
import '../models/create_account_params_model.dart';
import '../models/user_model.dart';


abstract class AuthRemoteDataSource {
  Future<Either<Failure, AuthResponceModel>> signin(SigninParams params);
  Future<Either<Failure, UserModel>> register(
    CreateAccountParams params,
  );
  Future<Either<Failure, Map<String, dynamic>>> resetPassword(String email);
  Future<Either<Failure, String>> verifyOtp(VerifycodeParams params);
  Future<Either<Failure, String>> verifyOtpForResetPassword(
    ResetPasswordParams params,
  );
  Future<Either<Failure, String>> newPassword(
    ResetPasswordParams params,
  );
  Future<Either<Failure, String>> logout(String refreshToken);
  Future<Either<Failure, String>> resendOtp(String phoneNumber);
}


