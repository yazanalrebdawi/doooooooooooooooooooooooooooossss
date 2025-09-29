import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SwitchWidget extends StatefulWidget {
  final bool initialValue;
  final ValueChanged<bool>? onChanged;

  const SwitchWidget({super.key, this.initialValue = false, this.onChanged});

  @override
  State<SwitchWidget> createState() => _SwitchWidgetState();
}

class _SwitchWidgetState extends State<SwitchWidget> {
  late bool isOn;

  @override
  void initState() {
    super.initState();
    isOn = widget.initialValue;
  }

  void toggleSwitch() {
    setState(() {
      isOn = !isOn;
      if (widget.onChanged != null) {
        widget.onChanged!(isOn);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: toggleSwitch,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 50.w,
        height: 28.h,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: isOn ? Color(0xFF34C759) : Color(0xFFE5E7EB),
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
                  offset: Offset(0, 2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
