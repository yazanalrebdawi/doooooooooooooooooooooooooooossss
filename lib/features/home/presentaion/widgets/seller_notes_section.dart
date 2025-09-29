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
    return Container(
      padding: EdgeInsets.all(20.w),
      color: AppColors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          Text(
            'Seller Notes',
            style: AppTextStyles.s18w700.copyWith(
              color: AppColors.black,
            ),
          ),
          SizedBox(height: 12.h),
          
          
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: AppColors.gray.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: AppColors.gray.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: Text(
              notes.isNotEmpty ? notes : 'No seller notes available.',
              style: AppTextStyles.s14w400.copyWith(
                color: AppColors.black,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
