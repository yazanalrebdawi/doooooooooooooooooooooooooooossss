import 'dart:developer';
import 'package:dooss_business_app/core/constants/colors.dart';
import 'package:dooss_business_app/core/constants/text_styles.dart';
import 'package:dooss_business_app/core/localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SettingsSwitchRowWidget extends StatefulWidget {
  final Color iconBackgroundColor;
  final Color iconColor;
  final IconData iconData;
  final String text;
  final bool initialValue;
  final ValueChanged<bool>? onChanged;
  final VoidCallback? onTapRow;
  final double iconSize;

  final bool switchEnabled;

  const SettingsSwitchRowWidget({
    super.key,
    required this.iconBackgroundColor,
    required this.iconColor,
    required this.iconData,
    required this.text,
    this.initialValue = false,
    this.onChanged,
    this.onTapRow,
    this.iconSize = 24,
    this.switchEnabled = true, 
  });

  @override
  State<SettingsSwitchRowWidget> createState() =>
      _SettingsSwitchRowWidgetState();
}

class _SettingsSwitchRowWidgetState extends State<SettingsSwitchRowWidget> {
  late bool isOn;

  @override
  void initState() {
    super.initState();
    isOn = widget.initialValue;
  }

  void toggleSwitch() {
    if (!widget.switchEnabled) return;

    setState(() {
      isOn = !isOn;
      if (widget.onChanged != null) {
        widget.onChanged!(isOn);
      }
      log('Switch value: $isOn');
    });
  }

  void onTapRowHandler() {
    if (widget.onTapRow != null) {
      widget.onTapRow!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12.r),
        onTap: onTapRowHandler,
        splashColor: Colors.black.withOpacity(0.05),
        highlightColor: Colors.black.withOpacity(0.02),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          width: 358.w,
          height: 65.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                spacing: 12.w,
                children: [
                  Container(
                    width: 40.w,
                    height: 40.h,
                    decoration: BoxDecoration(
                      color: widget.iconBackgroundColor,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Center(
                      child: Icon(
                        widget.iconData,
                        color: widget.iconColor,
                        size: widget.iconSize.r,
                      ),
                    ),
                  ),
                  Text(
                    AppLocalizations.of(context)?.translate(widget.text) ??
                        widget.text,
                    style: AppTextStyles.s14w400.copyWith(
                      fontFamily: AppTextStyles.fontPoppins,
                      color: AppColors.textPrimary,
                    ),
                    overflow: TextOverflow.ellipsis,
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
                    color:
                        isOn
                            ? const Color(0xFF34C759)
                            : const Color(0xFFD1D5DB),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: AnimatedAlign(
                    duration: const Duration(milliseconds: 200),
                    alignment:
                        isOn ? Alignment.centerRight : Alignment.centerLeft,
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
