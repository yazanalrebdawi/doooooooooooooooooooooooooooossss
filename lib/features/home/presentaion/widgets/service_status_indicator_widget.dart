import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/text_styles.dart';

/// A small indicator showing whether a service is open or closed
class ServiceStatusIndicatorWidget extends StatelessWidget {
  final bool isOpen;

  const ServiceStatusIndicatorWidget({
    super.key,
    required this.isOpen,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Status dot
        Container(
          width: 8.w,
          height: 8.h,
          decoration: BoxDecoration(
            color: isOpen ? Colors.green : AppColors.gray,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 4.w),
        // Status text
        Text(
          isOpen ? 'Open' : 'Closed',
          style: AppTextStyles.secondaryS12W400.copyWith(
            color: isOpen ? Colors.green : AppColors.gray,
          ),
        ),
      ],
    );
  }
}
