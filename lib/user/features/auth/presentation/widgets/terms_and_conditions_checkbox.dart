import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/routes/route_names.dart';

class TermsAndConditionsCheckbox extends StatefulWidget {
  final ValueChanged<bool>? onChanged;
  final bool initialValue;

  const TermsAndConditionsCheckbox({
    super.key,
    this.onChanged,
    this.initialValue = false,
  });

  @override
  State<TermsAndConditionsCheckbox> createState() =>
      _TermsAndConditionsCheckboxState();
}

class _TermsAndConditionsCheckboxState
    extends State<TermsAndConditionsCheckbox> {
  late bool _isAccepted;

  @override
  void initState() {
    super.initState();
    _isAccepted = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Checkbox(
          value: _isAccepted,
          onChanged: (value) {
            setState(() {
              _isAccepted = value ?? false;
            });
            widget.onChanged?.call(_isAccepted);
          },
          activeColor: AppColors.primary,
          checkColor: AppColors.white,
        ),
        Expanded(
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              setState(() {
                _isAccepted = !_isAccepted;
              });
              widget.onChanged?.call(_isAccepted);
            },
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text.rich(
                TextSpan(
                  style: AppTextStyles.s14w400.withThemeColor(context),
                  children: [
                    const TextSpan(text: 'Do you accept our '),
                    TextSpan(
                      text: 'terms and condition',
                      style: AppTextStyles.s14w400
                          .withThemeColor(context)
                          .copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                            decoration: TextDecoration.underline,
                          ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          context.push(RouteNames.privacyPolicy);
                        },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  bool get isAccepted => _isAccepted;
}

