import 'package:flutter/material.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/localization/app_localizations.dart';

class ChatsTitleWidget extends StatelessWidget {
  const ChatsTitleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Text(
      AppLocalizations.of(context)?.translate('chats') ?? 'Chats',
      style: AppTextStyles.s18w700.copyWith(
        color: isDark ? Colors.white : Colors.black,
      ),
    );
  }
}
