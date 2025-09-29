import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomSwitchWidget extends StatefulWidget {
  final bool initialValue;
  final ValueChanged<bool>? onChanged;
  final double width;
  final double height;
  final Duration duration;
  final Color activeColor;
  final Color inactiveColor;
  final Color thumbColor;

  const CustomSwitchWidget({
    super.key,
    this.initialValue = false,
    this.onChanged,
    this.width = 50,
    this.height = 28,
    this.duration = const Duration(milliseconds: 200),
    this.activeColor = const Color(0xFF34C759),
    this.inactiveColor = const Color(0xFFE5E7EB),
    this.thumbColor = Colors.white,
  });

  @override
  State<CustomSwitchWidget> createState() => _CustomSwitchWidgetState();
}

class _CustomSwitchWidgetState extends State<CustomSwitchWidget> {
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
    return GestureDetector(
      onTap: toggleSwitch,
      child: AnimatedContainer(
        duration: widget.duration,
        width: widget.width.w,
        height: widget.height.h,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: isOn ? widget.activeColor : widget.inactiveColor,
          borderRadius: BorderRadius.circular(widget.height.r),
        ),
        child: AnimatedAlign(
          duration: widget.duration,
          alignment: isOn ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: (widget.height - 8).w,
            height: (widget.height - 8).h,
            decoration: BoxDecoration(
              color: widget.thumbColor,
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
    );
  }
}
