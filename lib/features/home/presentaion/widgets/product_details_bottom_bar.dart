import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/text_styles.dart';

class ProductDetailsBottomBar extends StatelessWidget {
  final VoidCallback onChatPressed;
  final VoidCallback onCallPressed;

  const ProductDetailsBottomBar({
    super.key,
    required this.onChatPressed,
    required this.onCallPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Chat with Seller Button
          Expanded(
            flex: 3,
            child: ElevatedButton.icon(
              onPressed: onChatPressed,
              icon: Icon(
                Icons.chat_bubble_outline,
                color: AppColors.white,
                size: 20.sp,
              ),
              label: Text(
                'Chat with Seller',
                style: AppTextStyles.s14w500.copyWith(color: AppColors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                padding: EdgeInsets.symmetric(vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            ),
          ),
          
          SizedBox(width: 12.w),
          
          // Call Button
          Container(
            width: 56.w,
            height: 48.h,
            child: ElevatedButton(
              onPressed: onCallPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.gray.withOpacity(0.1),
                foregroundColor: AppColors.black,
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: Icon(
                Icons.phone,
                color: AppColors.black,
                size: 24.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
