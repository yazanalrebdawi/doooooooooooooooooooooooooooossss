import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/colors.dart';

class ChatsActionsWidget extends StatelessWidget {
  const ChatsActionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    final isDark = Theme.of(context).brightness == Brightness.dark;

=======
>>>>>>> zoz
    return Row(
      children: [
        Icon(
          Icons.search,
<<<<<<< HEAD
          color: isDark ? Colors.white : AppColors.gray,
=======
          color: AppColors.gray,
>>>>>>> zoz
          size: 24.sp,
        ),
        SizedBox(width: 16.w),
        Icon(
          Icons.more_vert,
<<<<<<< HEAD
          color: isDark ? Colors.white : AppColors.gray,
=======
          color: AppColors.gray,
>>>>>>> zoz
          size: 24.sp,
        ),
      ],
    );
  }
}
