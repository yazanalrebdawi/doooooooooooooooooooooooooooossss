import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/text_styles.dart';
import 'drop_down_field.dart';

class SecondRegisterBodySection extends StatefulWidget {
  const SecondRegisterBodySection({super.key});
  @override
  State<SecondRegisterBodySection> createState() =>
      _SecondRegisterBodySectionState();
}

class _SecondRegisterBodySectionState extends State<SecondRegisterBodySection> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Country", style: AppTextStyles.headLineBoardingBlackS25W700),
          SizedBox(height: 9.h),
          const DropDownField(
            hintText: 'Your Country',
            listOptions: [
              'option 1',
              'option 2',
              'option 3',
              'option 4',
            ],
          ),
          SizedBox(height: 15.h),
          Text("City", style: AppTextStyles.headLineBoardingBlackS25W700),
          SizedBox(height: 5.h),
          const DropDownField( hintText: 'Your City',
            listOptions: [
              'option 1',
              'option 2',
              'option 3',
              'option 4',
            ],),
          SizedBox(height: 15.h),
          Text("Area", style: AppTextStyles.headLineBoardingBlackS25W700),
          SizedBox(height: 5.h),
          const DropDownField(
            hintText: 'Your Area',
            listOptions: [
              'option 1',
              'option 2',
              'option 3',
              'option 4',
            ],),

          SizedBox(height: 15.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {},
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.gray),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  height: 38.h,
                  width: 284.w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Icon(Icons.add), Text("Add More Deatailes")],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 25.h),
          Text("Field", style: AppTextStyles.headLineBoardingBlackS25W700),
          SizedBox(height: 9.h),
          const DropDownField(
            hintText: 'Fields',
            listOptions: [
              'option 1',
              'option 2',
              'option 3',
              'option 4',
            ],),
          // const FieldsDropDownWidget()
        ],
      ),
    );
  }
}
