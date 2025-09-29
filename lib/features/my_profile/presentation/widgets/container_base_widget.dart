import 'package:dooss_business_app/core/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ContainerBaseWidget extends StatelessWidget {
  const ContainerBaseWidget({
    super.key,
    required this.height,
    required this.child,
    this.width,
    this.margin,
    this.padding,
  });

  final double height;
  final double? width;
  final Widget child;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? EdgeInsets.only(top: 20.h),
      padding: padding,
      width: width?.w,
      height: height.h,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(0, 4),
            blurRadius: 8.r,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            offset: const Offset(2, 0),
            blurRadius: 4.r,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            offset: const Offset(-2, 0),
            blurRadius: 4.r,
          ),
        ],
      ),
      child: child,
    );
  }
}
