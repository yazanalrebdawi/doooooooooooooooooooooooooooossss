import 'package:flutter/material.dart';
import '../../../../core/constants/text_styles.dart';

class HeadOfCategoriesHomeScreen extends StatelessWidget {
  final String topicText;
  final String actionText;
  final void Function()? onPressedActionText;

  const HeadOfCategoriesHomeScreen({
    super.key,
    required this.topicText,
    required this.actionText,
    required this.onPressedActionText
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(topicText, style: AppTextStyles.blackS20W500),
        TextButton(
          onPressed:onPressedActionText,
          child: Text(
            actionText,
            style: AppTextStyles.headCategoriesTextStyleS16W500.withThemeColor(context),
          ),
        ),
      ],
    );
  }
}
