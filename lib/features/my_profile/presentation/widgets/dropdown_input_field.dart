import 'package:dooss_business_app/core/style/text_form_field_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dooss_business_app/core/constants/colors.dart';
import 'package:dooss_business_app/core/constants/text_styles.dart';

class DropdownInputField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final List<String> options;
  final double? width;

  const DropdownInputField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.options,
    this.width,
  });

  @override
  State<DropdownInputField> createState() => _DropdownInputFieldState();
}

class _DropdownInputFieldState extends State<DropdownInputField> {
  void _openCityMenu() async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10.r,
                offset: Offset(0, -5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40.w,
                height: 5.h,
                margin: EdgeInsets.symmetric(vertical: 12.h),
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(2.5.r),
                ),
              ),

              ...widget.options.map(
                (option) => ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 24.w),
                  title: Text(
                    option,
                    style: AppTextStyles.s16w400.copyWith(
                      fontFamily: AppTextStyles.fontPoppins,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  trailing:
                      widget.controller.text == option
                          ? Icon(
                            Icons.check,
                            color: AppColors.primary,
                            size: 24.r,
                          )
                          : null,
                  onTap: () => Navigator.pop(context, option),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  hoverColor: AppColors.primary.withOpacity(0.1),
                ),
              ),
              SizedBox(height: 16.h),
            ],
          ),
        );
      },
    );

    if (selected != null) {
      setState(() {
        widget.controller.text = selected;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _openCityMenu,
      child: AbsorbPointer(
        child: SizedBox(
          width: (widget.width ?? 336).w,
          child: TextFormField(
            controller: widget.controller,
            readOnly: true,
            decoration: TextFormFieldStyle.baseForm(
              widget.hintText,
              context,
              AppTextStyles.s14w400.copyWith(color: AppColors.black),
            ).copyWith(
              suffixIcon: Icon(Icons.arrow_drop_down, color: AppColors.rating),
            ),
          ),
        ),
      ),
    );
  }
}
