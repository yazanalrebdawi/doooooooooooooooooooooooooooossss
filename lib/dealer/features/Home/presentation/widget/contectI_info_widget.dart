
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../user/core/utiles/validator.dart';
import '../../../../Core/style/app_Colors.dart';
import '../../../../Core/style/app_text_style.dart';

class ContactInfoWidget extends StatelessWidget {
  const ContactInfoWidget({
    super.key,
    required this.phone, required this.email,
  });

  final TextEditingController phone;
  final TextEditingController email;
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 400;
    
    return LayoutBuilder(
      builder: (context, constraints) {
        // Use responsive width - full width minus padding, max 600px
        final containerWidth = constraints.maxWidth > 0 
            ? constraints.maxWidth 
            : (isSmallScreen ? screenWidth - 32.w : 358.w);
        
        return Container(
          margin: EdgeInsets.symmetric(vertical: 16.h),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          width: containerWidth,
          constraints: BoxConstraints(maxWidth: 600),
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
                    width: double.infinity,
                    height: 70.h,
                    child: TextFormField(validator: (value) => Validator.notNullValidation(value),
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
                    width: double.infinity,
                    height: 50.h,
                    child: TextFormField(
    controller: email,
    decoration: InputDecoration(
      hintText: 'info@elsharkawyauto.com',
    ),
                    ),
                  ),
                
                ],
              ),
            );
      },
    );
  }
}
