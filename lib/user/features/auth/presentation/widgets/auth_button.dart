import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/text_styles.dart';

class AuthButton extends StatelessWidget {
  final void Function()? onTap;
  final String buttonText;
  final bool isLoading;

  const AuthButton({
    super.key,
    required this.onTap,
    required this.buttonText,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    print('🔘 AuthButton - isLoading: $isLoading');
    print('🔘 AuthButton - buttonText: $buttonText');
    
    return SizedBox(
      width: double.infinity,
      height: 54.h,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.r),
          ),
          elevation: 2,
          padding: EdgeInsets.zero,
        ),
        child: Center(
          child: isLoading
              ? SizedBox(
                  width: 24.w,
                  height: 24.h,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.w,
                  ),
                )
              : Text(
                  buttonText,
                  style: AppTextStyles.buttonTextStyleWhiteS22W700,
                ),
        ),
      ),
    );
  }
}
