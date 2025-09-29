import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/text_styles.dart';
import '../../data/models/message_model.dart';

class MessageBubble extends StatelessWidget {
  final MessageModel message;

  const MessageBubble({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      child: Row(
        mainAxisAlignment: message.isFromMe 
            ? MainAxisAlignment.end 
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Avatar for received messages (left side)
          if (!message.isFromMe) ...[
            Container(
              width: 32.w,
              height: 32.w,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.person,
                size: 16.sp,
                color: AppColors.primary,
              ),
            ),
            SizedBox(width: 8.w),
          ],
          
          // Message Content
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: 0.75 * MediaQuery.of(context).size.width,
              ),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: message.isFromMe 
                    ? AppColors.primary 
                    : AppColors.gray.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20.r).copyWith(
                  bottomLeft: message.isFromMe ? Radius.circular(20.r) : Radius.circular(4.r),
                  bottomRight: message.isFromMe ? Radius.circular(4.r) : Radius.circular(20.r),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.text,
                    style: AppTextStyles.s14w400.copyWith(
                      color: message.isFromMe ? AppColors.white : AppColors.black,
                      height: 1.4,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _formatTimestamp(message.timestamp),
                        style: AppTextStyles.s12w400.copyWith(
                          color: message.isFromMe 
                              ? AppColors.white.withOpacity(0.7) 
                              : AppColors.gray,
                        ),
                      ),
                      if (message.isFromMe) ...[
                        SizedBox(width: 4.w),
                        Icon(
                          _getStatusIcon(message.status),
                          size: 14.sp,
                          color: AppColors.white.withOpacity(0.7),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          // Avatar for sent messages (right side)
          if (message.isFromMe) ...[
            SizedBox(width: 8.w),
            Container(
              width: 32.w,
              height: 32.w,
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.person,
                size: 16.sp,
                color: AppColors.white,
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatTimestamp(String timestamp) {
    try {
      final date = DateTime.parse(timestamp);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays > 0) {
        return '${date.day}/${date.month} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
      } else if (difference.inHours > 0) {
        return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
      } else if (difference.inMinutes > 0) {
        return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
      } else {
        return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
      }
    } catch (e) {
      return timestamp;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'sent':
        return Icons.done;
      case 'delivered':
        return Icons.done_all;
      case 'read':
        return Icons.done_all;
      default:
        return Icons.schedule;
    }
  }
}
