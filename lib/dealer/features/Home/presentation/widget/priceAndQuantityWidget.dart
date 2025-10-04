import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../user/core/utiles/validator.dart';
import '../../../../Core/style/app_Colors.dart';
import '../../../../Core/style/app_text_style.dart';

class priceAndQuantityWidget extends StatelessWidget {
  const priceAndQuantityWidget({
    super.key,
    required this.price,
    required this.quantity,
  });
  final TextEditingController price;
  final TextEditingController quantity;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
            width: 171.w,
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
                    SizedBox(width: 8.w),
                    Text('price', style: AppTextStyle.poppins514),
                    Text('*', style: TextStyle(color: Colors.redAccent)),
                  ],
                ),
                SizedBox(height: 17.h),
                SizedBox(
                  width: 137.w,
                  // height: 55.h,
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    validator: (value) => Validator.notNullValidation(value),
                    controller: price,
                    decoration: InputDecoration(hintText: '0.00'),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
            // width: 171.w,
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
                    Icon(Icons.discount, color: AppColors.primary),
                    SizedBox(width: 8.w),
                    Text('discount', style: AppTextStyle.poppins514),
                  ],
                ),
                SizedBox(height: 17.h),
                SizedBox(
                  width: 137.w,
                  // height: 55.h,
                  child: TextFormField(
                    validator: (value) => Validator.notNullValidation(value),
                    controller: quantity,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(hintText: '0'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
