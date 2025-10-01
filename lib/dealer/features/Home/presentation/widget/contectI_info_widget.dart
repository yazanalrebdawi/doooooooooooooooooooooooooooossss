
import 'package:flutter/material.dart';
import 'package:dooss_business_app/dealer/Core/style/app_Colors.dart';
import 'package:dooss_business_app/dealer/Core/style/app_text_style.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ContactInfoWidget extends StatelessWidget {
  const ContactInfoWidget({
    super.key,
    required this.phone,
  });

  final TextEditingController phone;

  @override
  Widget build(BuildContext context) {
    return Container(margin: EdgeInsets.symmetric(vertical: 16.h),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
              width: 358.w,
              // height: 244.h,
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
    // SvgPicture.asset('assets/icons/svg.svg'),
    Icon(Icons.phone,color: AppColors.primary,),
    SizedBox(width: 8.w),
    Text(
      'Contact Information',
      style:AppTextStyle.poppins514
      
    ),
    // Text('*', style: TextStyle(color: Colors.redAccent)),
                    ],
                  ),
                  SizedBox(height: 18.h),
                    Row(
    children: [
      Text(
          'Phone Number',
          style:AppTextStyle.poppins513black
          
        ),
        Text('*', style: TextStyle(color: Colors.redAccent)),
    ],
                    ),
                    SizedBox(height: 8.h,),    
                  SizedBox(
                    width: 324.w,
                    height: 50.h,
                    child: TextFormField(
    controller: phone,
    decoration: InputDecoration(
      hintText: '+20 123 456 7890',
    ),
                    ),
                  ),
                  SizedBox(height: 18.h),
                    Row(
    children: [
      Text(
          'Email Address',
          style:AppTextStyle.poppins513black
          
        ),
        // Text('*', style: TextStyle(color: Colors.redAccent)),
    ],
                    ),
                    SizedBox(height: 8.h,),  
                  SizedBox(
                    width: 324.w,
                    height: 50.h,
                    child: TextFormField(
    controller: phone,
    decoration: InputDecoration(
      hintText: 'info@elsharkawyauto.com',
    ),
                    ),
                  ),
                
                ],
              ),
            );
  }
}
