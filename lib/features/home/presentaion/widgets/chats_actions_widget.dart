import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/colors.dart';

class ChatsActionsWidget extends StatelessWidget {
  const ChatsActionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.search,
          color: AppColors.gray,
          size: 24.sp,
        ),
        SizedBox(width: 16.w),
        Icon(
          Icons.more_vert,
          color: AppColors.gray,
          size: 24.sp,
        ),
      ],
    );
  }
}
