import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CarTagChip extends StatelessWidget {
  final String tag;

  const CarTagChip({
    Key? key,
    required this.tag,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Original colors
    const lightTextColor = Color(0xFF863E32);
    const lightBackgroundColor = Color(0x1A863E32);

    // Dark-mode colors
    final darkTextColor = Colors.orange.shade200;
    final darkBackgroundColor = Colors.orange.withOpacity(0.1);

    return SizedBox(
      width: 90.w,
      height: 24.h,
      child: Chip(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
        label: Text(
          tag,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isDark ? darkTextColor : lightTextColor,
            fontSize: 12,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        backgroundColor: isDark ? darkBackgroundColor : lightBackgroundColor,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
      ),
    );
  }
}
