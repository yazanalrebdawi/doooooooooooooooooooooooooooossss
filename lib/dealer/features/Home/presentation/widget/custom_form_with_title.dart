import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../Core/style/app_text_style.dart';

class CustomFormWithTitleWidget extends StatelessWidget {
  const CustomFormWithTitleWidget({
    super.key,
    required this.model,
    required this.hintForm,
    required this.title,
    this.lineNum = 1,
    this.isImportant = false,
    this.isOption = false,
    this.wid,
    required this.validation,
     this.isNum,
  });
  final bool? isImportant;
  final TextEditingController model;
  final String hintForm;
  final String title;
  final int? lineNum;
  final bool isOption;
  final double? wid;
  final bool? isNum;

 
  final Function(String? value) validation;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 14.sp,
                fontFamily: 'poppins',
                color: Color(0xff374151),
              ),
            ),
            Text(
              isImportant == true ? '*' : '',
              style: TextStyle(color: Color(0xff374151)),
            ),
            Text(isOption ? '(Option)' : '', style: AppTextStyle.primaryFont),
          ],
        ),
        SizedBox(height: 6.h),
        SizedBox(
          width: wid == null ? 324.w : wid,
          // height: 50.h,
          child: TextFormField(keyboardType: isNum==true? TextInputType.numberWithOptions():null,
            validator: (value) => validation(value),
            maxLines: lineNum,
            controller: model,
            decoration: InputDecoration(hintText: hintForm),
          ),
        ),
      ],
    );
  }
}
