import 'package:flutter/material.dart';
import 'package:dooss_business_app/dealer/Core/style/app_Colors.dart';
import 'package:dooss_business_app/dealer/Core/style/app_text_style.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Uploadvidoewidget extends StatefulWidget {
  const Uploadvidoewidget({super.key});

  @override
  State<Uploadvidoewidget> createState() => _UploadvidoewidgetState();
}

class _UploadvidoewidgetState extends State<Uploadvidoewidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 16.h),
        Text('intro video (Optional)', style: AppTextStyle.poppins514BlueDark),
        SizedBox(height: 8.h),
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(vertical: 26.h),
          width: 326.w,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.borderColor),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(Icons.videocam, color: AppColors.silverDark, size: 38),
              Text(
                'MP4 • Max 30MB • 30 seconds max',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  color: AppColors.silverDark,
                  fontFamily: 'poppins',
                ),
              ),
              SizedBox(height: 8.h),
              Text('Add Video', style: AppTextStyle.poppins514primaryColor),
            ],
          ),
        ),
      ],
    );
  }
}
