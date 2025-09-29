
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
}
