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
<<<<<<< HEAD
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final backgroundColor = isDark ? Colors.grey[900]! : AppColors.white;
    final cardColor = isDark ? Colors.grey[800]! : AppColors.white;
    final textColor = isDark ? Colors.white : AppColors.black;
    final secondaryTextColor = isDark ? Colors.white70 : AppColors.gray;
    final iconColor = AppColors.primary;

    return Container(
      padding: EdgeInsets.all(20.w),
      color: backgroundColor,
=======
    return Container(
      padding: EdgeInsets.all(20.w),
      color: AppColors.white,
>>>>>>> zoz
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          Text(
            'Seller Information',
<<<<<<< HEAD
            style: AppTextStyles.s18w700.copyWith(color: textColor),
=======
            style: AppTextStyles.s18w700.copyWith(
              color: AppColors.black,
            ),
>>>>>>> zoz
          ),
          SizedBox(height: 16.h),
          
          // Seller Info Card
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
<<<<<<< HEAD
              color: cardColor,
=======
              color: AppColors.white,
>>>>>>> zoz
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: AppColors.gray.withOpacity(0.2),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
<<<<<<< HEAD
                  color: isDark
                      ? Colors.black.withOpacity(0.5)
                      : Colors.black.withOpacity(0.05),
=======
                  color: Colors.black.withOpacity(0.05),
>>>>>>> zoz
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
<<<<<<< HEAD
                        color: iconColor.withOpacity(0.1),
=======
                        color: AppColors.primary.withOpacity(0.1),
>>>>>>> zoz
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
<<<<<<< HEAD
                                    color: iconColor,
=======
                                    color: AppColors.primary,
>>>>>>> zoz
                                  );
                                },
                              ),
                            )
                          : Icon(
                              Icons.person,
                              size: 30.sp,
<<<<<<< HEAD
                              color: iconColor,
=======
                              color: AppColors.primary,
>>>>>>> zoz
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
<<<<<<< HEAD
                              color: textColor,
=======
                              color: AppColors.black,
>>>>>>> zoz
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            sellerType,
                            style: AppTextStyles.s14w400.copyWith(
<<<<<<< HEAD
                              color: secondaryTextColor,
=======
                              color: AppColors.gray,
>>>>>>> zoz
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
