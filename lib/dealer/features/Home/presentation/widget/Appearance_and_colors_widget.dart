import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../user/core/utiles/validator.dart';
import '../../../../Core/style/app_Colors.dart';
import '../../../../Core/style/app_text_style.dart';
import '../page/google_map.dart';
import 'custom_form_with_title.dart';

class AppearanceAndColorsWidget extends StatelessWidget {
  AppearanceAndColorsWidget({
    super.key,
    required this.color,
    required this.lat,
    required this.lon,
  });
  final TextEditingController color;
  final Function(double value) lat;
  final Function(double value) lon;
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
                  validation: (value)=>  Validator.notNullValidation(value),
                  model: color,
                  hintForm: 'Metallic Red',
                  title: 'Exterior Color',
                ),
                // SizedBox(height: 16.h),
                // CustomFormWithTitleWidget(
                //   model: TextEditingController(),
                //   hintForm: 'Beige Leather',
                //   title: 'Interior Color (Optional)',
                // ),
                // SizedBox(height: 16.h),
                // CustomFormWithTitleWidget(
                //   model: TextEditingController(),
                //   hintForm: '18" Alloy Wheels',
                //   title: 'Rims Type',
                // ),
                SizedBox(height: 16.h),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MapScreen(
                          lat: (value) {
                            print(value);
                            lat(double.parse(value));
                          },
                          lon: (value) {
                            print(value);
                            lon(double.parse(value));
                          },
                        ),
                      ),
                    );
                  },
                  child: Container(alignment: Alignment.centerLeft,
                  
                  padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'select location ',
                          style: AppTextStyle.poppins514BlueDark,
                        ),
                        Icon(Icons.location_pin,color: AppColors.red,)
                      ],
                    ),
                    width: 358.w,
                    height: 68.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: AppColors.borderColor),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
