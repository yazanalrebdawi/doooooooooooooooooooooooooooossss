import 'package:dooss_business_app/dealer/features/Home/presentation/widget/year_drop_down.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../Core/style/app_text_style.dart';

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
                  isExpanded: true,
                  icon: Icon(Icons.keyboard_arrow_down, color: Colors.black),
                  hint: Text(
                    ' Select Brand',
                    style: AppTextStyle.poppinsw416black,
                    textAlign: TextAlign.center,
                  ),
                  items: [
                    DropdownMenuItem<String>(child: Text('BMW'), value: 'BMW'),
                    DropdownMenuItem<String>(
                        child: Text(
                          'Mercedes-banz',
                          overflow: TextOverflow.ellipsis,
                        ),
                        value: 'Mercedes-banz'),
                    DropdownMenuItem<String>(child: Text('KIA'), value: 'KIA'),
                    DropdownMenuItem<String>(
                        child: Text('Audi'), value: 'Audi'),
                    DropdownMenuItem<String>(
                        child: Text('Range Rover',
                            overflow: TextOverflow.ellipsis),
                        value: 'Range Rover'),
                    DropdownMenuItem<String>(
                        child: Text('Hyundai', overflow: TextOverflow.ellipsis),
                        value: 'Hyundai'),
                    DropdownMenuItem<String>(
                        child: Text('Toyota'), value: 'Toyota'),
                    DropdownMenuItem<String>(
                        child: Text('Nissan'), value: 'Nissan'),
                    DropdownMenuItem<String>(
                        child:
                            Text('VolksWagen', overflow: TextOverflow.ellipsis),
                        value: 'VolksWagen'),
                    DropdownMenuItem<String>(
                        child: Text('Honda'), value: 'Honda'),
                    DropdownMenuItem<String>(
                        child: Text('Chevrolet'), value: 'Chevrolet'),
                    DropdownMenuItem<String>(
                        child: Text('Genesis'), value: 'Genesis'),
                    DropdownMenuItem<String>(
                        child: Text('Ford'), value: 'Ford'),
                    DropdownMenuItem<String>(
                        child:
                            Text('Mitsubishi', overflow: TextOverflow.ellipsis),
                        value: 'Mitsubishi'),
                    DropdownMenuItem<String>(
                        child: Text('Peugeot'), value: 'Peugeot'),
                    DropdownMenuItem<String>(
                        child: Text('Mazda'), value: 'Mazda'),
                    DropdownMenuItem<String>(
                        child: Text('Dodge'), value: 'Dodge'),
                    DropdownMenuItem<String>(
                        child: Text('Infiniti'), value: 'Infiniti'),
                    DropdownMenuItem<String>(
                        child: Text('Skoda'), value: 'Skoda'),
                    DropdownMenuItem<String>(
                        child: Text('Porshe'), value: 'Porshe'),
                    DropdownMenuItem<String>(
                        child: Text('Cadillac'), value: 'Cadillac'),
                    DropdownMenuItem<String>(
                        child: Text('lexus'), value: 'lexus'),
                    DropdownMenuItem<String>(
                        child: Text('Opel'), value: 'Opel'),
                    DropdownMenuItem<String>(
                        child: Text('Jeep'), value: 'Jeep'),
                    DropdownMenuItem<String>(
                        child: Text('Volvo'), value: 'Volvo'),
                    DropdownMenuItem<String>(
                        child: Text('mini'), value: 'mini'),
                    DropdownMenuItem<String>(
                        child: Text('jaguor'), value: 'jaguor'),
                    DropdownMenuItem<String>(child: Text('BYD'), value: 'BYD'),
                    DropdownMenuItem<String>(
                        child: Text('Renault'), value: 'Renault'),
                    DropdownMenuItem<String>(
                        child: Text('Alfa Romeo'), value: 'Alfa Romeo'),
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
