
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../user/core/utiles/validator.dart';
import '../../../../Core/style/app_Colors.dart';
import '../../../../Core/style/app_text_style.dart';

class formEditProfileWidget extends StatelessWidget {
  const formEditProfileWidget({
    super.key,
    required this.storeName,
    required this.storeDescription,
  });

  final TextEditingController storeName;
  final TextEditingController storeDescription;

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
        
        return Column(
          children: [
            Container(
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
                  SvgPicture.asset('assets/icons/svg.svg',color: AppColors.primary,),
                  SizedBox(width: 8.w),
                  Text(
                    'Store Name',
                    style:AppTextStyle.poppins514
                    
                  ),
                  // Text('*', style: TextStyle(color: Colors.redAccent)),
                ],
              ),
              SizedBox(height: 17.h),
              SizedBox(
                width: double.infinity,
                height: 70.h,
                child: TextFormField(validator: (value) => Validator.notNullValidation(value),
                  controller: storeName,
                  decoration: InputDecoration(
                    hintText: 'El Sharkawy Auto',
                  ),
                ),
              ),
            
            ],
          ),
        ),
            SizedBox(height: 16.h,),
            Container(
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
          SvgPicture.asset('assets/icons/coin.svg'),
          SizedBox(width: 8.w),
          Text(
            'Store Description',
            style:AppTextStyle.poppins514
          ),
          Text('*', style: TextStyle(color: Colors.redAccent)),
        ],
      ),
      SizedBox(height: 17.h),
      SizedBox(
        width: double.infinity,
        child: TextFormField(maxLines: 4,
        validator: (value) => Validator.notNullValidation(value),
          controller: storeDescription,
          decoration: InputDecoration(
            hintText: 'Premium car dealership specializing in\nluxury vehicles and automotive\naccessories. We offer new and used\ncars with comprehensive warranty and',
          ),
        ),
      ),
    ],
              ),
            ),
          ],
        );
      },
    );
  }
}
