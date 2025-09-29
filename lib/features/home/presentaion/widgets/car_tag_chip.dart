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
    return SizedBox(
      width: 90.w,
      height: 24.h,
      child: Chip(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
        label: Text(
          tag,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Color(0xFF863E32),
            fontSize: 12,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        backgroundColor: const Color(0x1A863E32),
        padding: EdgeInsets.symmetric(horizontal: 4.w),
      ),
    );
  }
} 