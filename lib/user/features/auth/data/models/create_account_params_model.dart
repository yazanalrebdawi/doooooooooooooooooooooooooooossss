import 'package:flutter/material.dart';

abstract class AccountParams {
  void paramsDispose();
}

class SigninParams implements AccountParams {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final GlobalKey<FormState> formState = GlobalKey<FormState>();

  final FocusNode emailNode = FocusNode();
  final FocusNode passwordNode = FocusNode();

  @override
  void paramsDispose() {
    email.dispose();
    password.dispose();
    emailNode.dispose();
    passwordNode.dispose();
  }
}

class CreateAccountParams extends SigninParams {
  final TextEditingController userName = TextEditingController();
  final TextEditingController phoneNumber = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();
  final FocusNode userNameNode = FocusNode();
  final FocusNode phonenumberNode = FocusNode();
  final FocusNode confirmPasswordNode = FocusNode();
  
  // متغير منفصل لتخزين الرقم الكامل للـ API
  String fullPhoneNumber = '';

  @override
  void paramsDispose() {
    super.paramsDispose();
    userName.dispose();
    phoneNumber.dispose();
    confirmPassword.dispose();
    userNameNode.dispose();
    phonenumberNode.dispose();
    confirmPasswordNode.dispose();
  }
}

class ForgetPasswordParams extends CreateAccountParams {}

class ResetPasswordParams {
  final String phoneNumber;
  final String newPassword;
  // إزالة code لأن الـ OTP تم التحقق منه في الخطوة السابقة

  ResetPasswordParams({
    required this.phoneNumber,
    required this.newPassword,
  });
}
