import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../Core/style/app_Colors.dart';
import '../../../../Core/style/app_text_style.dart';

class PublishingOptionsWidget extends StatelessWidget {
  const PublishingOptionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.only(bottom: 16.h),
      width: 358.w,
      decoration: BoxDecoration(
        color: Color(0xffffffff),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.borderColor),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 1),
            color: Color.fromARGB(14, 0, 0, 0),
            blurRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Publishing Options', style: AppTextStyle.poppins416blueBlack),
          SizedBox(height: 13.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Publish Now', style: AppTextStyle.poppins414BD),
              Transform.scale(
                scale: 0.8,

                child: Switch(
                  // activeThumbColor: AppColors.primary,
                  activeColor: Colors.white,
                  value: true,
                  onChanged: (value) {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
