import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../Core/style/app_text_style.dart';
import 'video_player_edit_reel.dart';

class currentReelEditWidget extends StatelessWidget {
  const currentReelEditWidget({super.key, required this.link});
  final String link;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Current Reel', style: AppTextStyle.poppins514),
        SizedBox(height: 12.2.w),
        Container(
          alignment: Alignment(0, 10),
          child: Center(child: VideoPlayerEditReelWidget(videoUrl: link)),
          height: 282.h, // طول الـ Container
          width: 158.w, // إذا تريد أن يعرض كامل الشاشة
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 9, 9, 9), // لون الخلفية
            borderRadius: BorderRadius.circular(12), // حواف مدورة (اختياري)
          ),
        ),
      ],
    );
  }
}
