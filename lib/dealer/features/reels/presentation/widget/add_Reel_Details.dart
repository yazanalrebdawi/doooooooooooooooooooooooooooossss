import 'package:dooss_business_app/user/core/utiles/validator.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../Core/style/app_Colors.dart';
import '../../../../Core/style/app_text_style.dart';
import '../../../Home/presentation/page/home_Page1.dart';
import '../../../Home/presentation/widget/custom_form_with_title.dart';

class addReelDetailsWidget extends StatelessWidget {
  const addReelDetailsWidget({
    super.key,
    required this.title,
    required this.descraption,
  });
  final TextEditingController title;
  final TextEditingController descraption;
  @override
  Widget build(BuildContext context) {
    return Container(margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16),
      width: 358.w,
      // height: 300.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.borderColor, width: 0.5),
        color: Color(0xffffffff),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 1),
            blurRadius: 2.r,
            color: Color.fromARGB(24, 0, 0, 0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Reel Details', style: AppTextStyle.poppins416blueBlack),
          SizedBox(height: 13.h),
          CustomFormWithTitleWidget(
            validation: (value) =>Validator.notNullValidation(value),
            model: title,
            hintForm: 'enter title here',
            title: 'Title ',
            lineNum: 1,
          ),
          SizedBox(height: 16.h),
          CustomFormWithTitleWidget(
            validation:  (value) =>Validator.notNullValidation(value),
            model: descraption,
            hintForm: 'Write a catchy caption for your reel...',
            title: ' Caption',
            lineNum: 2,
          ),
          // Text(
          //   'Add tags for better discovery',
          //   style: AppTextStyle.intel412gray,
          // ),
        ],
      ),
    );
  }
}
