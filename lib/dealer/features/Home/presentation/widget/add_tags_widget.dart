
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../Core/style/app_Colors.dart';

class AddTagsWidget extends StatelessWidget {
  const AddTagsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tags',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            fontFamily: 'poppins',
            color: Color(0xff374151),
          ),
        ),
        SizedBox(height: 5.h),
        Row(
          children: [
            ...List.generate(2, (i) {
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 4.w),
                width: 71.w,
                alignment: Alignment.center,
                height: 28.h,
                decoration: BoxDecoration(
                  color: AppColors.lightGreen,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'mobile',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        color: Color(0xff16A34A),
                      ),
                    ),
                    Icon(Icons.close, color: AppColors.primary, size: 18.r),
                  ],
                ),
              );
            }),
          ],
        ),
        SizedBox(height: 16.h),
        TextFormField(
          controller: TextEditingController(),
          decoration: InputDecoration(
            hintText: 'Add tags (mobile, emergency, 24/7)',
          ),
        ),
      ],
    );
  }
}
