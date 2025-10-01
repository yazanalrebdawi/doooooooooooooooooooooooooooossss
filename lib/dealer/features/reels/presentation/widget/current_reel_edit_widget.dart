import 'package:flutter/material.dart';
import 'package:dooss_business_app/dealer/Core/style/app_text_style.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class currentReelEditWidget extends StatelessWidget {
  const currentReelEditWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Current Reel', style: AppTextStyle.poppins514),
        SizedBox(height: 12.2.w),
        Container(
          height: 300.h, // طول الـ Container
          width: 168.w, // إذا تريد أن يعرض كامل الشاشة
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 9, 9, 9), // لون الخلفية
            borderRadius: BorderRadius.circular(12), // حواف مدورة (اختياري)
          ),
        ),
      ],
    );
  }
}
