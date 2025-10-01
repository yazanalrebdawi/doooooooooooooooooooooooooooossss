
import 'package:flutter/material.dart' ;
import 'package:dooss_business_app/dealer/Core/style/app_Colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class selectRangePriceWidget extends StatelessWidget {
  const selectRangePriceWidget({
    super.key,
    required this.minPriceRange,
    required this.maxPriceRange,
  });

  final TextEditingController minPriceRange;
  final TextEditingController maxPriceRange;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              'Price Range ',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14.sp,
                fontFamily: 'poppins',
                color: Color(0xff374151),
              ),
            ),
            Text(' *', style: TextStyle(color: AppColors.silverDark)),
          ],
        ),
        SizedBox(height: 6.h),
        Row(
          children: [
            Expanded(
              child: SizedBox(
                width: 324.w,
                // height: 50.h,
                child: TextFormField(
                  controller: minPriceRange,
                  decoration: InputDecoration(hintText: 'From USD'),
                ),
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: SizedBox(
                width: 324.w,
                // height: 50.h,
                child: TextFormField(
                  controller: maxPriceRange,
                  decoration: InputDecoration(hintText: 'To USD'),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}