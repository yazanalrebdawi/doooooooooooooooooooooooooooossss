import 'package:flutter/material.dart';
import '../../../../core/constants/text_styles.dart';

class ChatsTitleWidget extends StatelessWidget {
  const ChatsTitleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Chats',
      style: AppTextStyles.s18w700,
    );
  }
}
