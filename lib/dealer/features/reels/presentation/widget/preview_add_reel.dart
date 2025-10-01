import 'package:flutter/material.dart';
import 'package:dooss_business_app/dealer/Core/style/app_Colors.dart';
import 'package:dooss_business_app/dealer/Core/style/app_text_style.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class preview_add_reel_widget extends StatelessWidget {
  const preview_add_reel_widget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 358.w,
      decoration: BoxDecoration(
        color: Color(0xffffffff),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.borderColor),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(16, 0, 0, 0),
            offset: Offset(0, 1),
            blurRadius: 2,
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          children: [
            Text('preview', style: AppTextStyle.poppins416blueBlack),
            SizedBox(height: 13.h),
            Container(
              padding: EdgeInsets.all(13.r),
              width: 324.w,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.borderColor),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48.w,
                    height: 48.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: AppColors.borderColor,
                    ),
                    child: Icon(
                      Icons.play_arrow_rounded,
                      color: AppColors.lightGrey,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Your reel caption will appear here...',
                          style: AppTextStyle.poppins414BD,
                        ),
                        Text(
                          '#hashtags #will #show #here',
                          style: AppTextStyle.intel412gray,
                        ),
                        Text(
                          'No product attached',
                          style: AppTextStyle.poppins412Primary,
                        ),
                      ],
                    ),
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
