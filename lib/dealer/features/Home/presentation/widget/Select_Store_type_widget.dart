
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../Core/style/app_Colors.dart';
import '../../../../Core/style/app_text_style.dart';

class storeTypeSelectWidget extends StatelessWidget {
  const storeTypeSelectWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(margin: EdgeInsets.symmetric(vertical: 16.h),
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
                  // SvgPicture.asset('assets/icons/coin.svg'),
                  Icon(Icons.sell,color: AppColors.primary,),
                  SizedBox(width: 4.w),
                  Text(
                    'Store Type',
                    style: AppTextStyle.poppins516,
                  ),
                  Text('*', style: TextStyle(color: Colors.redAccent)),
                 
                ],
              ),
              SizedBox(height: 17.h),
              SizedBox(
                width: 324.w,
                // height: 55.h,
                child: DropdownButtonFormField(
                  icon: Icon(Icons.keyboard_arrow_down,color: Colors.black,),
                  hint: Text(
                    ' Car Dealer',
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
