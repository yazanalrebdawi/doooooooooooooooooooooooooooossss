import 'package:flutter/material.dart';
import 'package:dooss_business_app/dealer/Core/style/app_text_style.dart';
import 'package:dooss_business_app/dealer/features/Home/presentation/page/add_new_car_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BrandAndYearSelectorWIdget extends StatelessWidget {
  BrandAndYearSelectorWIdget({
    super.key,
    required this.BrandSelected,
    required this.YearSelected,
  });
  String brand = '';
  String year = '';
  final Function(String value) BrandSelected;
  final Function(int value) YearSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SizedBox(width: 4.w),
                  Text(
                    'Brand',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp,
                      color: Color(0xff374151),
                      fontFamily: 'poppins',
                    ),
                  ),
                ],
              ),
              SizedBox(height: 6.h),
              SizedBox(
                width: 324.w,
                // height: 55.h,
                child: DropdownButtonFormField<String>(
                  icon: Icon(Icons.keyboard_arrow_down, color: Colors.black),
                  hint: Text(
                    ' Select Brand',
                    style: AppTextStyle.poppinsw416black,
                    textAlign: TextAlign.center,
                  ),
                  items: [
                    DropdownMenuItem<String>(child: Text('BMW'), value: 'BMW'),
                  ],
                  onChanged: (value) {
                    brand = value ?? 'BMW';
                    BrandSelected(value!);
                  },
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SizedBox(width: 4.w),
                  Text(
                    'year',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp,
                      color: Color(0xff374151),
                      fontFamily: 'poppins',
                    ),
                  ),
                ],
              ),
              SizedBox(height: 6.h),
              YearDropdown(
                CurrentYear: (value) {
                  YearSelected(value);
                },
              ),
              // SizedBox(
              //   // width: 324.w,
              //   // height: 55.h,
              //   child: DropdownButtonFormField(
              //     icon: Icon(Icons.keyboard_arrow_down, color: Colors.black),
              //     hint: Text(
              //       ' 2024',
              //       style: AppTextStyle.poppinsw416black,
              //       textAlign: TextAlign.center,
              //     ),
              //     items: [
              //       DropdownMenuItem<String>(
              //         child: Text('2024'),
              //         value: '2024',
              //       ),
              //     ],
              //     onChanged: (value) {},
              //   ),
              // ),
            ],
          ),
        ),
      ],
    );
  }
}
