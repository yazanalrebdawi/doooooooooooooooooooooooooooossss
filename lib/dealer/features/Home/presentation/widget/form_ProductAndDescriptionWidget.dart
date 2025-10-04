import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../user/core/utiles/validator.dart';
import '../../../../Core/style/app_Colors.dart';
import '../../../../Core/style/app_text_style.dart';

class formProductAndDescrictionWidget extends StatelessWidget {
  const formProductAndDescrictionWidget({
    super.key,
    required this.product,
    required this.Description,
  });

  final TextEditingController product;
  final TextEditingController Description;
  // final Function(TextEditingController product)
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
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
                  Icon(Icons.sell, size: 18, color: AppColors.primary),
                  SizedBox(width: 8.w),
                  Text('product Name', style: AppTextStyle.poppins514),
                  Text('*', style: TextStyle(color: Colors.redAccent)),
                ],
              ),
              SizedBox(height: 17.h),
              SizedBox(
                width: 324.w,
                height: 50.h,
                child: TextFormField(
                  validator: (value) => Validator.notNullValidation(value),
                  controller: product,
                  decoration: InputDecoration(
                    hintText: 'e.g., Brake Pads - Toyota',
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          width: 358.w,
          // height: 203,
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
                  Text('Description', style: AppTextStyle.poppins514),
                  Text('*', style: TextStyle(color: Colors.redAccent)),
                ],
              ),
              SizedBox(height: 12.h),
              SizedBox(
                width: 324.w,

                child: TextFormField(
                  validator: (value) => Validator.notNullValidation(value),
                  controller: Description,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText:
                        'Brief description including model,\nusage, warranty...',
                    //  , hintStyle: TextStyle(overflow: TextOverflow.ellipsis,)
                  ),
                ),
              ),
              SizedBox(height: 12.h),
            ],
          ),
        ),
      ],
    );
  }
}
