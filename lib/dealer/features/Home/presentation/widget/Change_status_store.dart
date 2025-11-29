import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../Core/style/app_Colors.dart';
import '../../../../Core/style/app_text_style.dart';
import '../../../reels/presentation/widget/time_picker.dart';

// ignore: camel_case_types
class changeStatusStoreWidget extends StatefulWidget {
  const changeStatusStoreWidget({
    super.key,
    required this.openungTime,
    required this.closeTime,
    required this.day, 
    required this.days,
    this.initialOpeningTime,
    this.initialClosingTime,
  });
  final Function(String value) openungTime;
  final Function(String value) closeTime;
  final Function(List<String> daysSelected) day;
  final List<String> days;
  final String? initialOpeningTime;
  final String? initialClosingTime;

  @override
  State<changeStatusStoreWidget> createState() => _changeStatusStoreWidgetState();
}

class _changeStatusStoreWidgetState extends State<changeStatusStoreWidget> {
  /// Parse time string (HH:mm format) to TimeOfDay
  TimeOfDay _parseTimeString(String timeString) {
    try {
      final parts = timeString.split(':');
      if (parts.length >= 2) {
        final hour = int.parse(parts[0]);
        final minute = int.parse(parts[1]);
        return TimeOfDay(hour: hour, minute: minute);
      }
    } catch (e) {
      print('Error parsing time string: $timeString - $e');
    }
    // Default to 9:00 AM if parsing fails
    return TimeOfDay(hour: 9, minute: 0);
  }

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

    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 400;
    
    return LayoutBuilder(
      builder: (context, constraints) {
        // Use responsive width - full width minus padding, max 600px
        final containerWidth = constraints.maxWidth > 0 
            ? constraints.maxWidth 
            : (isSmallScreen ? screenWidth - 32.w : 358.w);
        
        return Container(
          margin: EdgeInsets.symmetric(vertical: 16.h),
          width: containerWidth,
          constraints: BoxConstraints(maxWidth: 600),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('working Day', style: AppTextStyle.poppins414BlueDark),
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (_) {
                      List<String> selected = widget.days;
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
                              widget.day(widget.days);
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Container(
                  alignment: Alignment.center,
                  constraints: BoxConstraints(minWidth: 120.w, maxWidth: 200.w),
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  height: 50.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.borderColor),
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'Select Day working',
                      style: AppTextStyle.poppins414BD,
                    ),
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
                      initialTime: widget.initialOpeningTime != null
                          ? _parseTimeString(widget.initialOpeningTime!)
                          : null,
                      editDateValue: (value) {
                        widget.openungTime(
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
                      initialTime: widget.initialClosingTime != null
                          ? _parseTimeString(widget.initialClosingTime!)
                          : null,
                      editDateValue: (value) {
                        widget.closeTime(
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
      },
    );
  }
}

class selectStoreStatus extends StatefulWidget {
  selectStoreStatus({
    super.key, 
    required this.toggleStatus,
    required this.initialStatus,
  });
  final bool initialStatus;
  final Function(bool value) toggleStatus;

  @override
  State<selectStoreStatus> createState() => _selectStoreStatusState();
}

class _selectStoreStatusState extends State<selectStoreStatus> {
  late bool _isOpen;

  @override
  void initState() {
    super.initState();
    _isOpen = widget.initialStatus;
  }

  @override
  void didUpdateWidget(selectStoreStatus oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialStatus != widget.initialStatus) {
      _isOpen = widget.initialStatus;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 400;
    
    return LayoutBuilder(
      builder: (context, constraints) {
        final containerWidth = constraints.maxWidth > 0 
            ? constraints.maxWidth 
            : (isSmallScreen ? screenWidth - 32.w : 358.w);
        
        return Container(
          margin: EdgeInsets.only(top: 16.h, bottom: 1.h),
          width: containerWidth,
          constraints: BoxConstraints(maxWidth: 600),
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
                    SizedBox(width: 8.w),
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
                        color: _isOpen ? Color(0xff4B5563) : AppColors.primary,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Transform.scale(
                      scale: 0.8,
                      child: Switch(
                        value: _isOpen,
                        onChanged: (value) {
                          setState(() {
                            _isOpen = value;
                          });
                          widget.toggleStatus(value);
                        },
                        activeTrackColor: AppColors.primary,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'open',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14.sp,
                        color: _isOpen ? AppColors.primary : Color(0xff4B5563),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
