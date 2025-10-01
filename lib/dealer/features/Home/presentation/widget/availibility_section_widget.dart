
import 'package:flutter/material.dart';
import 'package:dooss_business_app/dealer/Core/style/app_Colors.dart';
import 'package:dooss_business_app/dealer/Core/style/app_text_style.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class availabilitySectionWidget extends StatelessWidget {
  const availabilitySectionWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 62.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColors.borderColor,
          width: 0.5,
        ),
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
        padding: EdgeInsets.symmetric(horizontal: 17.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Availability',
              style: AppTextStyle.poppins514black,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  height: 15.h,
                  width: 40.w,
                  child: Transform.scale(
                    scale: 0.8,
                    child: Switch(
                      value: true,
                      onChanged: (value) {},
                      activeTrackColor: AppColors.primary,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Text(
                  'Available',
                  style: AppTextStyle.poppins514black,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
