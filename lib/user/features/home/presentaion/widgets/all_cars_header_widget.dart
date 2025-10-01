import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/text_styles.dart';

class AllCarsHeaderWidget extends StatelessWidget {
  const AllCarsHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.all(16.w),
      height: 180.h,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2A2A2A) : AppColors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.4 : 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.r),
        child: Stack(
          children: [
            // Background Image
            Image.asset(
              'assets/images/view_all_cars_screen.jpg',
              width: double.infinity,
              height: 180.h,
              fit: BoxFit.cover,
            ),
            // Gradient Overlay
            Container(
              width: double.infinity,
              height: 180.h,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Colors.black.withOpacity(0.7),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
            // Text Content
            Positioned(
              left: 18.w,
              top: 20.h,
              bottom: 0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Get the best\nvalue for your car',
                    style: AppTextStyles.whiteS18W700,
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'List it for sale with us easily and find the perfect match\nquickly!',
                    style: AppTextStyles.whiteS16W400.copyWith(
                      fontSize: 14.sp,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
