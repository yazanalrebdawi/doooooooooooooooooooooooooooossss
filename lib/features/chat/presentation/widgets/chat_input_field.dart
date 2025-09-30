import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/text_styles.dart';

class ChatInputField extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onSendMessage;

  const ChatInputField({
    super.key,
    required this.controller,
    required this.onSendMessage,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? Color(0xFF2A2A2A) : AppColors.white,
        border: Border(
          top: BorderSide(
            color: AppColors.gray.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Attachment Button
            // IconButton(
            //   onPressed: () {
            //     // TODO: Implement attachment functionality
            //   },
            //   icon: Icon(
            //     Icons.attach_file,
            //     color: isDark ? Colors.white : AppColors.gray,
            //     size: 24.sp,
            //   ),
            // ),

            // Text Field
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.gray.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(24.r),
                ),
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    fillColor: Colors.transparent,
                    hintText: 'Type a message...',
                    hintStyle: AppTextStyles.s14w400.copyWith(
                      color: isDark ? Colors.white : AppColors.gray,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 12.h,
                    ),
                  ),
                  maxLines: null,
                  textCapitalization: TextCapitalization.sentences,
                  onSubmitted: (value) {
                    if (value.trim().isNotEmpty) {
                      onSendMessage(value.trim());
                      controller.clear();
                    }
                  },
                ),
              ),
            ),

            // SizedBox(width: 8.w),

            // // Voice Button
            // IconButton(
            //   onPressed: () {
            //     // TODO: Implement voice message functionality
            //   },
            //   icon: Icon(
            //     Icons.mic,
            //     color: isDark ? Colors.white : AppColors.gray,
            //     size: 24.sp,
            //   ),
            // ),

            SizedBox(width: 8.w),

            // Send Button
            ValueListenableBuilder<TextEditingValue>(
              valueListenable: controller,
              builder: (context, value, child) {
                final hasText = value.text.trim().isNotEmpty;
                return Container(
                  width: 40.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                    color: hasText
                        ? AppColors.primary
                        : AppColors.gray.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: hasText
                        ? () {
                            if (controller.text.trim().isNotEmpty) {
                              onSendMessage(controller.text.trim());
                              controller.clear();
                            }
                          }
                        : null,
                    icon: Icon(
                      Icons.send,
                      color: hasText ? AppColors.white : AppColors.gray,
                      size: 18.sp,
                    ),
                    padding: EdgeInsets.zero,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
