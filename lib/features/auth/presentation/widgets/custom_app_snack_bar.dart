import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';
import 'package:dooss_business_app/core/constants/colors.dart';
import '../../../../core/constants/text_styles.dart';

/// Abstract interface for toast notifications
abstract class ToastNotification {
  void showErrorMessage(BuildContext context, String message);
  void showSuccessMessage(BuildContext context, String message);
}

/// Implementation using Toastification package
class ToastNotificationImpl implements ToastNotification {
  @override
  void showErrorMessage(BuildContext context, String message) {
    toastification.show(
      style: ToastificationStyle.flatColored,
      type: ToastificationType.error,
      context: context,
      title: Text(message),
      autoCloseDuration: const Duration(seconds: 5),
    );
  }

  @override
  void showSuccessMessage(BuildContext context, String message) {
    toastification.show(
      style: ToastificationStyle.flatColored,
      type: ToastificationType.success,
      context: context,
      title: Text(message),
      autoCloseDuration: const Duration(seconds: 5),
    );
  }
}

/// Custom SnackBar implementation
SnackBar customAppSnackBar(String message, BuildContext context) {
  return SnackBar(
    elevation: 0,
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent,
    padding: const EdgeInsets.all(15),
    content: Container(
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
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
}
