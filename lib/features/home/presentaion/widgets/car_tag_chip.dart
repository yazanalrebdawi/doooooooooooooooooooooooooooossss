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
<<<<<<< HEAD
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Original colors
    const lightTextColor = Color(0xFF863E32);
    const lightBackgroundColor = Color(0x1A863E32);

    // Dark-mode colors
    final darkTextColor = Colors.orange.shade200;
    final darkBackgroundColor = Colors.orange.withOpacity(0.1);

=======
>>>>>>> zoz
    return SizedBox(
      width: 90.w,
      height: 24.h,
      child: Chip(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
        label: Text(
          tag,
          textAlign: TextAlign.center,
<<<<<<< HEAD
          style: TextStyle(
            color: isDark ? darkTextColor : lightTextColor,
=======
          style: const TextStyle(
            color: Color(0xFF863E32),
>>>>>>> zoz
            fontSize: 12,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
<<<<<<< HEAD
        backgroundColor: isDark ? darkBackgroundColor : lightBackgroundColor,
=======
        backgroundColor: const Color(0x1A863E32),
>>>>>>> zoz
        padding: EdgeInsets.symmetric(horizontal: 4.w),
      ),
    );
  }
<<<<<<< HEAD
}
=======
} 
>>>>>>> zoz
