import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NoConversationYetWidget extends StatelessWidget {
  const NoConversationYetWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.mail,
            size: 100.w,
            color: Colors.brown.shade700,
          ),
          SizedBox(height: 16.h),
          Text(
            'No Conversation Yet',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'You didn\'t Start New Conversation. Pick\nYour Person To Start Conversation',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
} 