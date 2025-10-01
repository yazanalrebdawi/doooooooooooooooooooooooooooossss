import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplitShieldIconWidget extends StatelessWidget {
  const SplitShieldIconWidget({super.key, this.size = 28});

  final double size;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return LinearGradient(
          colors: [Color(0xff2563EB), Color(0xFFBFDBFE)],
          stops: [0.5, 0.5],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ).createShader(bounds);
      },
      child: Icon(Icons.shield, color: Colors.white, size: size.sp),
    );
  }
}
