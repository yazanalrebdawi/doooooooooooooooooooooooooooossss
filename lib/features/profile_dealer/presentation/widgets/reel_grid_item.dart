import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/routes/route_names.dart';
import '../../data/models/reel_model.dart';

class ReelGridItem extends StatelessWidget {
  final ReelModel reel;

  const ReelGridItem({
    super.key,
    required this.reel,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgGray = isDark ? Colors.grey[800]! : AppColors.gray.withOpacity(0.1);
    final iconGray = isDark ? Colors.white70 : AppColors.gray;

    return GestureDetector(
      onTap: () {
        context.go('${RouteNames.reelsWithId.replaceAll(':id', reel.id.toString())}');
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          color: bgGray,
        ),
        child: Stack(
          children: [
            // Thumbnail Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: reel.thumbnailUrl.isNotEmpty
                  ? Image.network(
                      reel.thumbnailUrl,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: bgGray,
                          child: Icon(
                            Icons.play_circle_outline,
                            size: 32.sp,
                            color: iconGray,
                          ),
                        );
                      },
                    )
                  : Container(
                      color: bgGray,
                      child: Icon(
                        Icons.play_circle_outline,
                        size: 32.sp,
                        color: iconGray,
                      ),
                    ),
            ),
            // Play Button Overlay
            Center(
              child: Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.play_arrow,
                  color: AppColors.white,
                  size: 24.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
