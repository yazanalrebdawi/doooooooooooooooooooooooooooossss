import 'dart:developer';
import 'package:dooss_business_app/core/localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RowWithSwitchWidget extends StatefulWidget {
  final Color iconBackgroundColor;
  final Color iconColor;
  final IconData iconData;
  final String topRightText;
  final String bottomRightText;
  final bool initialValue;
  final ValueChanged<bool>? onChanged;
  final double iconSize;
  final EdgeInsetsGeometry? padding;

  const RowWithSwitchWidget({
    super.key,
    required this.iconBackgroundColor,
    required this.iconColor,
    required this.iconData,
    required this.topRightText,
    required this.bottomRightText,
    this.initialValue = false,
    this.onChanged,
    this.iconSize = 24,
    this.padding,
  });

  @override
  State<RowWithSwitchWidget> createState() => _RowWithSwitchWidgetState();
}

class _RowWithSwitchWidgetState extends State<RowWithSwitchWidget> {
  late bool isOn;

  @override
  void initState() {
    super.initState();
    isOn = widget.initialValue;
  }

  void toggleSwitch() {
    setState(() {
      isOn = !isOn;
      widget.onChanged?.call(isOn);
      log('Switch value: $isOn');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          widget.padding ??
          EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            spacing: 10.w,
            children: [
              CircleAvatar(
                radius: 20.r,
                backgroundColor: widget.iconBackgroundColor,
                child: Icon(
                  widget.iconData,
                  color: widget.iconColor,
                  size: widget.iconSize.r,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(
                          context,
                        )?.translate(widget.topRightText) ??
                        widget.topRightText,

                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    AppLocalizations.of(
                          context,
                        )?.translate(widget.bottomRightText) ??
                        widget.bottomRightText,
                    style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
          GestureDetector(
            onTap: toggleSwitch,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 50.w,
              height: 28.h,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: isOn ? const Color(0xFF34C759) : const Color(0xFFE5E7EB),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: AnimatedAlign(
                duration: const Duration(milliseconds: 200),
                alignment: isOn ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  width: 20.w,
                  height: 20.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 3.r,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
