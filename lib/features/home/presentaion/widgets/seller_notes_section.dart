import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/text_styles.dart';

class SellerNotesSection extends StatelessWidget {
  final String notes;

  const SellerNotesSection({
    super.key,
    required this.notes,
  });

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final backgroundColor = isDark ? Colors.grey[900]! : AppColors.white;
    final cardColor = isDark ? Colors.grey[800]! : AppColors.gray.withOpacity(0.05);
    final borderColor = isDark ? Colors.grey[700]! : AppColors.gray.withOpacity(0.1);
    final textColor = isDark ? Colors.white : AppColors.black;

    return Container(
      padding: EdgeInsets.all(20.w),
      color: backgroundColor,
=======
    return Container(
      padding: EdgeInsets.all(20.w),
      color: AppColors.white,
>>>>>>> zoz
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          Text(
            'Seller Notes',
<<<<<<< HEAD
            style: AppTextStyles.s18w700.copyWith(color: textColor),
          ),
          SizedBox(height: 12.h),
          
          // Notes Card
=======
            style: AppTextStyles.s18w700.copyWith(
              color: AppColors.black,
            ),
          ),
          SizedBox(height: 12.h),
          
          
>>>>>>> zoz
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
<<<<<<< HEAD
              color: cardColor,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: borderColor,
=======
              color: AppColors.gray.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: AppColors.gray.withOpacity(0.1),
>>>>>>> zoz
                width: 1,
              ),
            ),
            child: Text(
              notes.isNotEmpty ? notes : 'No seller notes available.',
              style: AppTextStyles.s14w400.copyWith(
<<<<<<< HEAD
                color: textColor,
=======
                color: AppColors.black,
>>>>>>> zoz
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
