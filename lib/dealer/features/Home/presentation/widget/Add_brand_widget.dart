
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../Core/style/app_Colors.dart';
import '../../../../Core/style/app_text_style.dart';

class BrandWidget extends StatelessWidget {
  const BrandWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
      margin: EdgeInsets.symmetric(vertical: 16.h),
      width: 358.w,
      // height: 124.h,
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
      child: Column(
        children: [
          Row(
            children: [
              SvgPicture.asset('assets/icons/coin.svg'),
              SizedBox(width: 4.w),
              Text(
                'Brand',
                style:AppTextStyle.poppins514,
              ),
              Text('*', style: TextStyle(color: Colors.redAccent)),
            ],
          ),
          SizedBox(height: 17.h),
          SizedBox(
            width: 324.w,
            // height: 55.h,
            child: DropdownButtonFormField(
              icon: Icon(Icons.keyboard_arrow_down),
              hint: Text(
                ' Select Brand',
                style: AppTextStyle.poppinsw416black,
                textAlign: TextAlign.center,
              ),
              items: [],
              onChanged: (value) {},
            ),
          ),
        ],
      ),
    );
  }
}