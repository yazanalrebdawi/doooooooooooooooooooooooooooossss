import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/text_styles.dart';

class SellerInfoSection extends StatelessWidget {
  final String sellerName;
  final String sellerType;
  final String sellerImage;
  final VoidCallback onCallPressed;
  final VoidCallback onMessagePressed;

  const SellerInfoSection({
    super.key,
    required this.sellerName,
    required this.sellerType,
    required this.sellerImage,
    required this.onCallPressed,
    required this.onMessagePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      color: AppColors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          Text(
            'Seller Information',
            style: AppTextStyles.s18w700.copyWith(
              color: AppColors.black,
            ),
          ),
          SizedBox(height: 16.h),
          
          // Seller Info Card
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: AppColors.gray.withOpacity(0.2),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                // Seller Profile
                Row(
                  children: [
                    // Seller Avatar
                    Container(
                      width: 60.w,
                      height: 60.w,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: sellerImage.isNotEmpty
                          ? ClipOval(
                              child: Image.network(
                                sellerImage,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(
                                    Icons.person,
                                    size: 30.sp,
                                    color: AppColors.primary,
                                  );
                                },
                              ),
                            )
                          : Icon(
                              Icons.person,
                              size: 30.sp,
                              color: AppColors.primary,
                            ),
                    ),
                    SizedBox(width: 16.w),
                    
                    // Seller Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            sellerName,
                            style: AppTextStyles.s16w600.copyWith(
                              color: AppColors.black,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            sellerType,
                            style: AppTextStyles.s14w400.copyWith(
                              color: AppColors.gray,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                
                // Action Buttons
                Row(
                  children: [
                    // Call Button
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: onCallPressed,
                        icon: Icon(
                          Icons.phone,
                          size: 18.sp,
                          color: AppColors.white,
                        ),
                        label: Text(
                          'Call Seller',
                          style: AppTextStyles.s14w500.copyWith(
                            color: AppColors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.white,
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    
                    // Message Button
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: onMessagePressed,
                        icon: Icon(
                          Icons.chat_bubble_outline,
                          size: 18.sp,
                          color: AppColors.primary,
                        ),
                        label: Text(
                          'Message',
                          style: AppTextStyles.s14w500.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          side: BorderSide(
                            color: AppColors.primary,
                            width: 1,
                          ),
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
