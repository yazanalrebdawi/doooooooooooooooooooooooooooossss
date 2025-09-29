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
}
