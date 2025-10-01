import 'package:flutter/material.dart';
import 'package:dooss_business_app/dealer/Core/style/app_Colors.dart';
import 'package:dooss_business_app/dealer/Core/style/app_text_style.dart';
import 'package:dooss_business_app/dealer/features/Home/presentation/widget/custom_checkBox_with_Title.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class featuresAndOptionsWidget extends StatelessWidget {
  const featuresAndOptionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 358.w,
      // height: 515.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.borderColor, width: 0.5),
        color: Color(0xffffffff),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(8, 0, 0, 0),
            blurRadius: 4.r,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.color_lens, color: AppColors.primary),

                    SizedBox(width: 8.w),
                    Text(
                      'Features & Options',
                      style: AppTextStyle.poppins718black,
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomCheckBoxWithTitleWidget(
                            title: 'Parking\nSensors',
                          ),
                          SizedBox(height: 12.h),
                          CustomCheckBoxWithTitleWidget(title: 'Sunroof'),
                          SizedBox(height: 12.h),
                          CustomCheckBoxWithTitleWidget(title: 'Touchscreen'),
                          SizedBox(height: 12.h),
                          CustomCheckBoxWithTitleWidget(title: 'Dual-zone A/C'),
                          SizedBox(height: 12.h),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomCheckBoxWithTitleWidget(title: 'Rear Camera'),
                          SizedBox(height: 12.h),
                          CustomCheckBoxWithTitleWidget(
                            title: 'Cruise Control',
                          ),
                          SizedBox(height: 12.h),
                          CustomCheckBoxWithTitleWidget(title: 'Bluetooth'),
                          SizedBox(height: 12.h),
                          CustomCheckBoxWithTitleWidget(title: 'Keyless Entry'),
                          SizedBox(height: 12.h),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
