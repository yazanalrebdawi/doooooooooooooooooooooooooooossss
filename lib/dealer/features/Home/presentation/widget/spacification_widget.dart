import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../Core/style/app_Colors.dart';
import '../../../../Core/style/app_text_style.dart';
import 'custom_dropdown_list_with_title.dart';

class SpecificationsWidget extends StatefulWidget {
  SpecificationsWidget({
    super.key,
    required this.fuelType,
    required this.Transmission,
    required this.Drivetrain,
    required this.Door,
    required this.seats,
  });
  final Function(String value) fuelType;
  final Function(String value) Transmission;
  final Function(String value) Drivetrain;
  final Function(int value) Door;
  final Function(int value) seats;
  @override
  State<SpecificationsWidget> createState() => _SpecificationsWidgetState();
}

class _SpecificationsWidgetState extends State<SpecificationsWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 358.w,
      // height: 515.h,
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
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.settings, color: AppColors.primary),
                    SizedBox(width: 8.w),
                    Text('Specifications', style: AppTextStyle.poppins718black),
                  ],
                ),
                SizedBox(height: 20.h),
                Row(
                  children: [
                    Expanded(
                      child: CustomDropDownListWithTitleWidget(
                        items: [
                          DropdownMenuItem(
                            child: Text('Petrol'),
                            value: 'Petrol',
                          ),
                          DropdownMenuItem(
                            child: Text('Disel'),
                            value: 'Disel',
                          ),
                        ],
                        CurrentValue: (value) {
                          widget.fuelType(value);
                        },
                        hintForm: 'Petrol',
                        title: 'Fuel Type',
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: CustomDropDownListWithTitleWidget(
                        items: [
                          DropdownMenuItem(
                            child: Text('Automatic'),
                            value: 'Automatic',
                          ),
                          DropdownMenuItem(
                            child: Text('maneual'),
                            value: 'maneual',
                          ),
                        ],
                        hintForm: 'Automatic',
                        title: 'Transmission',
                        CurrentValue: (value) {
                          widget.Transmission(value);
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                Row(
                  children: [
                    Expanded(
                      child: CustomDropDownListWithTitleWidget(
                        items: [
                          DropdownMenuItem(child: Text('FWD'), value: 'FWD'),
                          DropdownMenuItem(child: Text('AWD'), value: 'AWD'),
                          DropdownMenuItem(child: Text('RWD'), value: 'RWD'),
                        ],
                        hintForm: 'FWD',
                        title: 'Drivetrain',
                        CurrentValue: (value) {
                          widget.Drivetrain(value);
                        },
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: CustomDropDownListWithTitleWidget(
                        items: [
                          DropdownMenuItem(child: Text('2'), value: 2),
                          DropdownMenuItem(child: Text('4'), value: 4),
                 
                     
                        ],
                        hintForm: '4',
                        title: 'Doors',
                        CurrentValue: (value) {
                          widget.Door(value);
                        },
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: CustomDropDownListWithTitleWidget(
                        items: [
                          DropdownMenuItem(child: Text('2'), value: 2),
                          DropdownMenuItem(child: Text('4'), value: 4),
                            DropdownMenuItem(child: Text('5'), value: 5),
                          DropdownMenuItem(child: Text('7'), value: 7),
                        ],
                        hintForm: '2',
                        title: 'Seats',
                        CurrentValue: (value) {
                          widget.seats(value);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
