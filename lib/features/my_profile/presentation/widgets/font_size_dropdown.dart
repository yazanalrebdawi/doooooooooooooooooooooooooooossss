import 'package:dooss_business_app/core/constants/colors.dart';
import 'package:dooss_business_app/core/constants/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FontSizeDropdown extends StatefulWidget {
  final String initialValue;
  final List<String> options = ["Small", "Medium", "Large"];
  final ValueChanged<String>? onChanged;

  FontSizeDropdown({super.key, required this.initialValue, this.onChanged});

  @override
  State<FontSizeDropdown> createState() => _FontSizeDropdownState();
}

class _FontSizeDropdownState extends State<FontSizeDropdown> {
  late String selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 98.w,
      height: 36.h,
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedValue,
          icon: Icon(Icons.arrow_drop_down, size: 20.sp),
          isExpanded: true,
          dropdownColor: AppColors.white,
          onChanged: (value) {
            if (value != null) {
              setState(() => selectedValue = value);
              if (widget.onChanged != null) widget.onChanged!(value);
            }
          },
          items:
              widget.options.map((option) {
                return DropdownMenuItem(
                  value: option,
                  child: Text(
                    option,
                    style: AppTextStyles.s14w400.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                );
              }).toList(),
        ),
      ),
    );
  }
}
