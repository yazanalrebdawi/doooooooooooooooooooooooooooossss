import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/colors.dart';

class ProfileAvatarHomeScreen extends StatelessWidget {
  final bool isOnline;
  final VoidCallback? onPressed;
  final double size;

  const ProfileAvatarHomeScreen({
    super.key,
    required this.isOnline,
    this.onPressed,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          GestureDetector(
            onTap: onPressed,
            child: Container(
              width: size.w,
              height: size.h,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.primary, width: 2),
                borderRadius: BorderRadius.circular(100),
              ),
              child: CircleAvatar(
                radius: size.r / 2,
                backgroundImage: AssetImage(AppAssets.fakeImg),
              ),
            ),
          ),

          // Online Indicator
          if (isOnline)
            Positioned(
              right: -2,
              bottom: -2,
              child: Container(
                width: 14.w,
                height: 14.h,
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981),
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.white, width: 2.0),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
