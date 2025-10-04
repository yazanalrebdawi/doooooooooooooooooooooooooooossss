import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../Core/style/app_Colors.dart';
import '../../../../Core/style/app_text_style.dart';
import '../../../reels/presentation/widget/time_picker.dart';

class changeStatusStoreWidget extends StatelessWidget {
  const changeStatusStoreWidget({
    super.key,
    required this.openungTime,
    required this.closeTime,
    required this.day,
  });
  final Function(String value) openungTime;
  final Function(String value) closeTime;
  final Function(List<String> daysSelected) day;
  @override
  Widget build(BuildContext context) {
    final List<String> weekDays = [
      'sunday',
      'monday',
      'tuesday',
      'wednesday',
      'thursday',
      'friday',
      'saturday',
    ];

    List<String> selectedDays = [];
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16.h),
      width: 358.w,
      // height: 177.h,
      padding: EdgeInsets.all(16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.access_time_filled,
                color: AppColors.primary,
                size: 20,
              ),
              Text(' Working Hours', style: AppTextStyle.poppins514black),
            ],
          ),
          SizedBox(height: 12.h),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('working Day', style: AppTextStyle.poppins414BlueDark),
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (_) {
                      List<String> selected = [];
                      return AlertDialog(
                        title: Text('ٍselect day woork'),
                        content: StatefulBuilder(
                          builder: (context, setState) {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: weekDays.map((day) {
                                final isSelected = selected.contains(day);
                                return CheckboxListTile(
                                  value: isSelected,
                                  title: Text(day),
                                  onChanged: (checked) {
                                    setState(() {
                                      checked!
                                          ? selected.add(day)
                                          : selected.remove(day);
                                    });
                                  },
                                );
                              }).toList(),
                            );
                          },
                        ),
                        actions: [
                          TextButton(
                            child: Text('done'),
                            onPressed: () {
                              Navigator.pop(context);
                              print('الأيام المختارة: $selected');
                              day(selected);
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Container(
                  alignment: Alignment.center,
                  width: 150.w,
                  height: 50.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.borderColor),
                  ),
                  child: Text(
                    'Select Day working',
                    style: AppTextStyle.poppins414BD,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Opening Time', style: AppTextStyle.poppins414BD),
                    SizedBox(height: 8.h),
                    TimePickerWidget(
                      editDateValue: (value) {
                        openungTime(
                          '${value.hour.toString().padLeft(2, '0')}:${value.minute.toString().padLeft(2, '0')}',
                        );
                        print(value);
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Closing Time', style: AppTextStyle.poppins414BD),
                    SizedBox(height: 8.h),
                    TimePickerWidget(
                      editDateValue: (value) {
                        closeTime(
                          '${value.hour.toString().padLeft(2, '0')}:${value.minute.toString().padLeft(2, '0')}',
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
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
    );
  }
}

class selectStoreStatus extends StatefulWidget {
  selectStoreStatus({super.key, required this.toggleStatus});
  bool isOPen = true;
  final Function(bool value) toggleStatus;

  @override
  State<selectStoreStatus> createState() => _selectStoreStatusState();
}

class _selectStoreStatusState extends State<selectStoreStatus> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 16.h, bottom: 1.h),
      width: 358.w,
      height: 56.h,
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
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.toggle_on, color: AppColors.primary),
                Text(
                  'Store Status',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: Color(0xff111827),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  'closed',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14.sp,
                    color: Color(0xff4B5563),
                  ),
                ),
                Transform.scale(
                  scale: 0.8,
                  child: Switch(
                    value: widget.isOPen,
                    onChanged: (value) {
                      setState(() {
                        widget.isOPen = value;
                        widget.toggleStatus(value);
                      });
                    },
                    activeTrackColor: AppColors.primary,
                  ),
                ),
                Text(
                  'open',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14.sp,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
