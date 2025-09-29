import 'package:dooss_business_app/core/localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:dooss_business_app/core/constants/text_styles.dart';

class InputLabelWidget extends StatelessWidget {
  final String label;

  const InputLabelWidget({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      AppLocalizations.of(context)?.translate(label) ?? label,
      style: AppTextStyles.s14w500.copyWith(color: const Color(0xff374151)),
    );
  }
}
