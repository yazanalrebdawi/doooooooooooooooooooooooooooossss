import 'package:dooss_business_app/core/constants/text_styles.dart';
import 'package:dooss_business_app/core/localization/app_localizations.dart';
import 'package:dooss_business_app/features/my_profile/presentation/widgets/input_label_widget.dart';
import 'package:dooss_business_app/features/my_profile/presentation/widgets/input_passowrd_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NewPasswordFieldWidget extends StatefulWidget {
  final TextEditingController controller;

  const NewPasswordFieldWidget({super.key, required this.controller});

  @override
  State<NewPasswordFieldWidget> createState() => _NewPasswordFieldWidgetState();
}

class _NewPasswordFieldWidgetState extends State<NewPasswordFieldWidget> {
  String strengthLabel = 'Weak';
  Color progressColor = Colors.red;
  double progress = 0.0;

  bool get hasMinLength => widget.controller.text.length >= 8;
  bool get hasUppercase => widget.controller.text.contains(RegExp(r'[A-Z]'));
  bool get hasNumber => widget.controller.text.contains(RegExp(r'[0-9]'));

  void _updateStrength() {
    int passed = [hasMinLength, hasUppercase, hasNumber].where((v) => v).length;
    setState(() {
      progress = (passed / 3) * 319.53125.w;
      if (passed == 1) {
        strengthLabel = 'Weak';
        progressColor = Colors.red;
      } else if (passed == 2) {
        strengthLabel = 'Medium';
        progressColor = Colors.orange;
      } else if (passed == 3) {
        strengthLabel = 'Strong';
        progressColor = Colors.green;
      } else {
        strengthLabel = 'Weak';
        progressColor = Colors.red;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_updateStrength);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_updateStrength);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InputLabelWidget(label: "New Password"),
        SizedBox(height: 5.h),
        InputPassowrdWidget(
          controller: widget.controller,
          hintText: "Enter new password",
        ),
        SizedBox(height: 10.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Container(
                    width: 310.53125.w,
                    height: 8.h,
                    decoration: BoxDecoration(
                      color: Color(0xffEFF6FF),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                  Container(
                    width: progress,
                    height: 8.h,
                    decoration: BoxDecoration(
                      color: progressColor,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                ],
              ),
            ),
            Text(
              AppLocalizations.of(context)?.translate(strengthLabel) ??
                  strengthLabel,
              style: AppTextStyles.s12w400.copyWith(color: progressColor),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _requirementRow('At least 8 characters', hasMinLength),
            _requirementRow('One uppercase letter', hasUppercase),
            _requirementRow('One number', hasNumber),
          ],
        ),
      ],
    );
  }

  Widget _requirementRow(String text, bool passed) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Row(
        children: [
          Container(
            width: 20.w,
            height: 20.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: passed ? Colors.green : Colors.red,
            ),
            child: Center(
              child: Icon(
                passed ? Icons.check : Icons.close,
                size: 14.w,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              AppLocalizations.of(context)?.translate(text) ?? text,
              style: AppTextStyles.s14w400.copyWith(color: Color(0xff1E293B)),
            ),
          ),
        ],
      ),
    );
  }
}
