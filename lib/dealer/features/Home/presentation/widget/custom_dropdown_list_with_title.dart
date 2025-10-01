import 'package:flutter/material.dart';
import 'package:dooss_business_app/dealer/Core/style/app_text_style.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomDropDownListWithTitleWidget extends StatelessWidget {
  const CustomDropDownListWithTitleWidget({
    super.key,
    required this.CurrentValue,
    required this.hintForm,
    required this.title,
    required this.items,
  });

  final String hintForm;
  final String title;
  final Function(dynamic value) CurrentValue;
  final List<DropdownMenuItem> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14.sp,
                fontFamily: 'poppins',
                color: Color(0xff374151),
              ),
            ),
            // Text('*', style: TextStyle(color: Colors.redAccent)),
          ],
        ),
        SizedBox(height: 6.h),
        SizedBox(
          width: 324.w,
          // height: 55.h,
          child: DropdownButtonFormField(
            icon: Icon(Icons.keyboard_arrow_down, color: Colors.black),
            hint: Text(
              hintForm,
              style: AppTextStyle.poppinsw416black,
              textAlign: TextAlign.center,
            ),
            items: items,
            onChanged: (value) {
              CurrentValue(value);
            },
          ),
        ),
      ],
    );
  }
}
