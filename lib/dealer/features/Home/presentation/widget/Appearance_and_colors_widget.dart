import 'package:flutter/material.dart';
import 'package:dooss_business_app/dealer/Core/style/app_Colors.dart';
import 'package:dooss_business_app/dealer/Core/style/app_text_style.dart';
import 'package:dooss_business_app/dealer/features/Home/presentation/page/add_new_car_page.dart';
import 'package:dooss_business_app/dealer/features/Home/presentation/widget/custom_form_with_title.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppearanceAndColorsWidget extends StatelessWidget {
  AppearanceAndColorsWidget({super.key, required this.color});
  final TextEditingController color;
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
                      'Appearance & Colors',
                      style: AppTextStyle.poppins718black,
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                CustomFormWithTitleWidget(
                  model: color,
                  hintForm: 'Metallic Red',
                  title: 'Exterior Color',
                ),
                SizedBox(height: 16.h),
                CustomFormWithTitleWidget(
                  model: TextEditingController(),
                  hintForm: 'Beige Leather',
                  title: 'Interior Color (Optional)',
                ),
                SizedBox(height: 16.h),
                CustomFormWithTitleWidget(
                  model: TextEditingController(),
                  hintForm: '18" Alloy Wheels',
                  title: 'Rims Type',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
