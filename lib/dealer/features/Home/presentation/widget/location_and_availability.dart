import 'package:flutter/material.dart';
import 'package:dooss_business_app/dealer/Core/style/app_Colors.dart';
import 'package:dooss_business_app/dealer/Core/style/app_text_style.dart';
import 'package:dooss_business_app/dealer/features/Home/presentation/page/add_new_car_page.dart';
import 'package:dooss_business_app/dealer/features/Home/presentation/page/google_map.dart';
import 'package:dooss_business_app/dealer/features/Home/presentation/widget/custom_form_with_title.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class locationAndAvailability extends StatelessWidget {
  const locationAndAvailability({
    super.key,
    required this.isAvailable,
    required this.isServiceStatus,
  });

  final bool isAvailable;
  final bool isServiceStatus;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 358.w,
      decoration: BoxDecoration(
        color: Color(0xffffffff),
        border: Border.all(color: AppColors.borderColor),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(24, 0, 0, 0),
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(Icons.location_pin, color: AppColors.primary),
                SizedBox(width: 8.w),
                Text('Location & Availability', style: AppTextStyle.Poppins718),
              ],
            ),
          ),
          Divider(color: AppColors.borderColor, height: 1),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                //  Icon(Icons.map_outlined)
                CustomFormWithTitleWidget(
                  model: TextEditingController(),
                  hintForm: 'Enter address or pin location',
                  title: 'Service Area ',
                  isImportant: true,
                ),
                SizedBox(height: 8.h),
                InkWell(
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => GoogleMap()),
                    // );
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.map_outlined,
                        color: AppColors.primary,
                        size: 18,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        'set on map',
                        style: AppTextStyle.poppins514primaryColor,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Always Available',
                      style: AppTextStyle.poppins514BlueDark,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          height: 15.h,
                          width: 40.w,
                          child: Transform.scale(
                            scale: 0.6,
                            child: Switch(
                              value: isAvailable,
                              onChanged: (value) {
                                // setState(() {
                                //   isAvailable = value;
                                // });
                              },
                              activeTrackColor: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Service Status',
                      style: AppTextStyle.poppins514BlueDark,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          height: 15.h,
                          width: 40.w,
                          child: Transform.scale(
                            scale: 0.6,
                            child: Switch(
                              value: isServiceStatus,
                              onChanged: (value) {
                                // setState(() {
                                //   isServiceStatus = value;
                                // });
                              },
                              activeTrackColor: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
