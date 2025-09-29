import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/text_styles.dart';
import '../../data/models/reel_model.dart';

class ReelCard extends StatelessWidget {
  final ReelModel reel;
  final VoidCallback? onTap;

  const ReelCard({
    Key? key, 
    required this.reel,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 200.w,
        margin: EdgeInsets.only(right: 16.w),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Reel Image
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.r),
                topRight: Radius.circular(16.r),
              ),
              child: Container(
                width: double.infinity,
                height: 120.h,
                color: AppColors.gray.withOpacity(0.2),
                child: reel.thumbnail.isNotEmpty
                    ? Image.network(
                        reel.thumbnail,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Center(
                            child: Icon(
                              Icons.video_library,
                              color: AppColors.gray,
                              size: 48.sp,
                            ),
                          );
                        },
                      )
                    : Center(
                        child: Icon(
                          Icons.video_library,
                          color: AppColors.gray,
                          size: 48.sp,
                        ),
                      ),
              ),
            ),
            // Reel Details
            Padding(
              padding: EdgeInsets.all(12.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    reel.title,
                    style: isDark 
                        ? AppTextStyles.whiteS16W600 
                        : AppTextStyles.blackS16W600,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Icon(Icons.person, color: AppColors.gray, size: 16.r),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Text(
                          reel.dealerUsername ?? 'Unknown',
                          style: AppTextStyles.s14w400.copyWith(color: AppColors.gray),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Icon(Icons.favorite, color: Colors.red, size: 16.r),
                      SizedBox(width: 4.w),
                      Text(
                        reel.likesCount.toString(),
                        style: AppTextStyles.s14w400.copyWith(color: AppColors.gray),
                      ),
                      SizedBox(width: 16.w),
                      Icon(Icons.visibility, color: AppColors.gray, size: 16.r),
                      SizedBox(width: 4.w),
                      Text(
                        reel.viewsCount.toString(),
                        style: AppTextStyles.s14w400.copyWith(color: AppColors.gray),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
