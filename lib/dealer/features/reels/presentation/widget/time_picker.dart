import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../Core/style/app_text_style.dart';

class SelectDateWidget extends StatefulWidget {
  final Function(DateTime Data) EditData;

  const SelectDateWidget({super.key, required this.EditData});
  @override
  _SelectDateWidgetState createState() => _SelectDateWidgetState();
}

class _SelectDateWidgetState extends State<SelectDateWidget> {
  DateTime today = DateTime.now();
  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        widget.EditData(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _selectDate(context);
      },
      child: Container(
        width: 175.w,
        height: 60.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Color(0xffE3E3E3)),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${selectedDate.toLocal()}".split(' ')[0],
                  style: AppTextStyle.poppins414BD,
                ),
                SvgPicture.asset('assets/icons/svg/Icondfgddddd.svg'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TimePickerWidget extends StatefulWidget {
  TimePickerWidget({
    super.key, 
    required this.editDateValue,
    this.initialTime,
  });
  final Function(TimeOfDay value) editDateValue;
  final TimeOfDay? initialTime;

  @override
  _TimePickerWidgetState createState() => _TimePickerWidgetState();
}

class _TimePickerWidgetState extends State<TimePickerWidget> {
  late TimeOfDay selectedTime;

  @override
  void initState() {
    super.initState();
    // Use initial time if provided, otherwise default to 9:00 AM
    selectedTime = widget.initialTime ?? TimeOfDay(hour: 9, minute: 0);
  }

  @override
  void didUpdateWidget(TimePickerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update selected time if initial time changed
    // Handle both null and non-null changes
    if (widget.initialTime != oldWidget.initialTime) {
      selectedTime = widget.initialTime ?? TimeOfDay(hour: 9, minute: 0);
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
        widget.editDateValue(selectedTime);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _selectTime(context);
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Color(0xffE3E3E3)),
          borderRadius: BorderRadius.circular(12),
        ),
        width: 150.w,
        height: 60.h,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 35),
              child: Text(
                selectedTime.format(context), // يعطيك مثلا 9:05 AM
                style: AppTextStyle.poppins414BD,
              ),
            ),
            // Container(width: 1, color: Color(0xffC8C8C8)),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: SvgPicture.asset(
            //     'assets/icons/svg/Icondfgddddd.svg',
            //     color: Color(0xffE3E3E3),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
