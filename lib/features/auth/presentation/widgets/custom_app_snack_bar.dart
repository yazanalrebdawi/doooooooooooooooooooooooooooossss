<<<<<<< HEAD
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';



abstract class ToastNotification {
  void showErrorMessage(BuildContext context, String message);
  void showSuccessMessage(BuildContext context, String message);
}

class ToastNotificationImp implements ToastNotification {
  @override
  void showErrorMessage(BuildContext context, String message) {
    toastification.show(
      style: ToastificationStyle.flatColored,
      type: ToastificationType.error,
      context: context, // optional if you use ToastificationWrapper
      title: Text(message),
      autoCloseDuration: const Duration(seconds: 5),
    );
  }

  @override
  void showSuccessMessage(BuildContext context, String message) {
    toastification.show(
      style: ToastificationStyle.flatColored,
      type: ToastificationType.success,
      context: context, // optional if you use ToastificationWrapper
      title: Text(message),
      autoCloseDuration: const Duration(seconds: 5),
    );
  }
=======

import 'package:dooss_business_app/core/constants/colors.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/text_styles.dart';

SnackBar customAppSnackBar(String message, BuildContext context) {
  return SnackBar(
    elevation: 0,
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent,
    padding: const EdgeInsets.all(15),
    content: Container(
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: const BorderRadius.all(
          Radius.circular(12),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: AppTextStyles.blackS25W500,
        ),
      ),
    ),
  );
>>>>>>> zoz
}
