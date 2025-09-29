import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/text_styles.dart';
import '../../data/models/content_type.dart';

class EmptyContentWidget extends StatelessWidget {
  final ContentType contentType;

  const EmptyContentWidget({
    super.key,
    required this.contentType,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconColor = isDark ? Colors.grey[400]! : AppColors.gray;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _getEmptyIcon(),
            size: 64.sp,
            color: iconColor,
          ),
          SizedBox(height: 16.h),
          Text(
            _getEmptyMessage(),
            style: AppTextStyles.s16w500.copyWith(color: iconColor),
          ),
        ],
      ),
    );
  }

  IconData _getEmptyIcon() {
    switch (contentType) {
      case ContentType.reels:
        return Icons.play_circle_outline;
      case ContentType.cars:
        return Icons.directions_car_outlined;
      case ContentType.services:
        return Icons.build_outlined;
    }
  }

  String _getEmptyMessage() {
    switch (contentType) {
      case ContentType.reels:
        return 'No reels yet';
      case ContentType.cars:
        return 'No cars listed';
      case ContentType.services:
        return 'No services available';
    }
  }
}
