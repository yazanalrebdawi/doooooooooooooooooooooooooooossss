import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/text_styles.dart';

class EmptySection extends StatelessWidget {
  final String message;

  const EmptySection({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.r),
      decoration: BoxDecoration(
        color: AppColors.gray.withOpacity(0.1), // Static gray background
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          Icon(
            Icons.inbox_outlined,
            color: AppColors.gray, // Static gray icon
            size: 48.sp,
          ),
          SizedBox(height: 16.h),
          Text(
            message,
            style: AppTextStyles.s16w400.copyWith(color: AppColors.gray), // Static gray, no theme toggle
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
