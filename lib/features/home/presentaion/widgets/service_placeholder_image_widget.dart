import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/colors.dart';

/// Placeholder widget for services without an image
class ServicePlaceholderImageWidget extends StatelessWidget {
  const ServicePlaceholderImageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200.h,
      color: AppColors.gray.withOpacity(0.2),
      child: Center(
        child: Icon(
          Icons.local_gas_station,
          color: AppColors.gray,
          size: 48.sp,
        ),
      ),
    );
  }
}
