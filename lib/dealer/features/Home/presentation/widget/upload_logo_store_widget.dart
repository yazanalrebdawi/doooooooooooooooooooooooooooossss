
import 'package:flutter/material.dart';
import 'package:dooss_business_app/dealer/Core/style/app_Colors.dart';
import 'package:dooss_business_app/dealer/Core/style/app_text_style.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class AddStoreLogoWidget extends StatelessWidget {
  const AddStoreLogoWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(margin: EdgeInsets.symmetric(vertical: 16.h),
    padding: EdgeInsets.symmetric(horizontal: 16.w,vertical: 16.h),
      width: 358.w,
      // height: 138.h,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12.r),
        color: const Color(0xffffffff),
        border: Border.all(color: AppColors.borderColor,width: 0.5),
        boxShadow: [
                  BoxShadow(
    color: Color.fromARGB(8, 0, 0, 0),
    blurRadius: 4.r,
    offset: Offset(0, 2),
                  ),
                ],
      ),
      child:Column(
        children: [
               Row(
    children: [
Icon(Icons.photo,color: AppColors.primary,),
      SizedBox(width: 8.w),
      Text(
        'Store Logo',
        style:AppTextStyle.poppins514black
        
      ),
    ],
                  ),
                  SizedBox(height: 12.h,),
    Row(
      children: [
        Container(width: 46.w,
        height: 46.w,
          decoration: BoxDecoration(
            color: AppColors.silver,border:Border.all(color: AppColors.borderColor,width: 2),
            borderRadius: BorderRadius.circular(8.r)
          ),
          child: Center(
            child: SvgPicture.asset('assets/icons/svg.svg',color: AppColors.silverDark,),
          ),
        ),SizedBox(width: 16.w,),
        Expanded(
          child: Column(mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(alignment: Alignment.center,
              height: 50.h,
              width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.primary,width: 1),
                  borderRadius: BorderRadius.circular(8)
                ),child: Text('Upload Logo',style: AppTextStyle.poppins516primaryColor),
              ),
              Text('Max 5MB, .png/.jpg format',style: AppTextStyle.intel412gray,)
            ],
          ),
        )
      ],
    )
          
        ],
      ) ,
    );
  }
}
