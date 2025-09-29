import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/text_styles.dart';

class ServicePhotoCardWidget extends StatelessWidget {
  final String title;

  const ServicePhotoCardWidget({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120.w,
      margin: EdgeInsets.only(right: 12.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        color: AppColors.gray.withOpacity(0.1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(8.r)),
                color: AppColors.gray.withOpacity(0.2),
              ),
              child: Center(child: Icon(Icons.image, color: AppColors.gray, size: 32.sp)),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.w),
            child: Text(
              title,
              style: AppTextStyles.secondaryS12W400.copyWith(color: AppColors.black, fontWeight: FontWeight.w500),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
