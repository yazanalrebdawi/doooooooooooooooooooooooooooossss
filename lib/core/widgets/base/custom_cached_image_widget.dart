import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dooss_business_app/core/constants/colors.dart';

class CustomCachedImage extends StatelessWidget {
  final String? appImage; // 👈 صار nullable
  final double height;
  final double width;
  final BoxFit fit;
  final Widget? placeholder;
  final Widget? errorWidget;

  const CustomCachedImage({
    super.key,
    required this.appImage,
    required this.height,
    required this.width,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    // ✅ إذا الرابط null أو فاضي نرجع fallback فوري
    if (appImage == null || appImage!.trim().isEmpty) {
      return _fallback();
    }

    return CachedNetworkImage(
      imageUrl: appImage!,
      height: height == double.infinity ? double.infinity : height.h,
      width: width == double.infinity ? double.infinity : width.w,
      fit: fit,
      placeholder:
          (context, url) =>
              placeholder ??
              Container(
                height: height == double.infinity ? double.infinity : height.h,
                width: width == double.infinity ? double.infinity : width.w,
                color: Colors.grey.shade300,
                child: const Center(child: CircularProgressIndicator()),
              ),
      errorWidget: (context, url, error) => errorWidget ?? _fallback(),
    );
  }

  Widget _fallback() {
    return Container(
      height: height == double.infinity ? double.infinity : height.h,
      width: width == double.infinity ? double.infinity : width.w,
      color: AppColors.secondary.withOpacity(0.3),
      alignment: Alignment.center,
      child: Icon(
        Icons.image_not_supported_outlined,
        size: 40.sp,
        color: AppColors.primary.withOpacity(0.7),
      ),
    );
  }
}
