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
<<<<<<< HEAD
    final isDark = Theme.of(context).brightness == Brightness.dark;

=======
>>>>>>> zoz
    return Container(
      width: double.infinity,
      height: 300.h,
      decoration: BoxDecoration(
<<<<<<< HEAD
        color: isDark ? const Color(0xFF2A2A2A) : const Color(0xFFF5F5F5),
=======
        color: const Color(0xFFF5F5F5), // Light grey background
>>>>>>> zoz
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
<<<<<<< HEAD
                    return _buildPlaceholderImage(isDark);
                  },
                )
              : _buildPlaceholderImage(isDark),

=======
                    return _buildPlaceholderImage();
                  },
                )
              : _buildPlaceholderImage(),
          
>>>>>>> zoz
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

<<<<<<< HEAD
  Widget _buildPlaceholderImage(bool isDark) {
=======
  Widget _buildPlaceholderImage() {
>>>>>>> zoz
    return Container(
      width: double.infinity,
      height: 300.h,
      decoration: BoxDecoration(
<<<<<<< HEAD
        color: isDark ? Colors.white12 : AppColors.gray.withOpacity(0.1),
=======
        color: AppColors.gray.withOpacity(0.1),
>>>>>>> zoz
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
<<<<<<< HEAD
              color: isDark ? Colors.white70 : AppColors.gray,
=======
              color: AppColors.gray,
>>>>>>> zoz
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
