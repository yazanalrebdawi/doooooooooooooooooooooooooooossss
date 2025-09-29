import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/colors.dart';

class CarImageSection extends StatelessWidget {
  final String imageUrl;
  final String carName;

  const CarImageSection({
    super.key,
    required this.imageUrl,
    required this.carName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 300.h,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5), // Light grey background
      ),
      child: Stack(
        children: [
          // Car Image - Full width and height
          imageUrl.isNotEmpty
              ? Image.network(
                  imageUrl,
                  width: double.infinity,
                  height: 300.h,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return _buildPlaceholderImage();
                  },
                )
              : _buildPlaceholderImage(),
          
          // Car Name Overlay
          Positioned(
            bottom: 20.h,
            left: 20.w,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Text(
                carName,
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      width: double.infinity,
      height: 300.h,
      decoration: BoxDecoration(
        color: AppColors.gray.withOpacity(0.1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.car_repair,
            size: 60.sp,
            color: AppColors.primary,
          ),
          SizedBox(height: 12.h),
          Text(
            carName,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.gray,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
