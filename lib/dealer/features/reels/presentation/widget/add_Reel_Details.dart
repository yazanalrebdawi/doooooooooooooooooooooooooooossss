import 'package:flutter/material.dart';
import 'package:dooss_business_app/dealer/Core/style/app_Colors.dart';
import 'package:dooss_business_app/dealer/Core/style/app_text_style.dart';
import 'package:dooss_business_app/dealer/features/Home/presentation/page/add_new_car_page.dart';
import 'package:dooss_business_app/dealer/features/Home/presentation/widget/custom_form_with_title.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    return Container(
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
            model: title,
            hintForm: 'Write a catchy caption for your reel...',
            title: 'Title / Caption',
            lineNum: 2,
          ),
          SizedBox(height: 16.h),
          CustomFormWithTitleWidget(
            model: descraption,
            hintForm: '#offers #cleaning #deals',
            title: 'Hashtags',
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
