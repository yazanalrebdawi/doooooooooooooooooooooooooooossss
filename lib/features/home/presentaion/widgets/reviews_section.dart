import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/text_styles.dart';

class ReviewsSection extends StatelessWidget {
  final double rating;
  final int reviewsCount;
  final List<Map<String, dynamic>> reviews;

  const ReviewsSection({
    super.key,
    required this.rating,
    required this.reviewsCount,
    required this.reviews,
  });

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

=======
>>>>>>> zoz
    return Container(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Reviews',
<<<<<<< HEAD
                style: AppTextStyles.s18w700.copyWith(
                  color: isDark ? Colors.white : Colors.black,
                ),
=======
                style: AppTextStyles.s18w700,
>>>>>>> zoz
              ),
              Row(
                children: [
                  Icon(
                    Icons.star,
                    color: Colors.amber,
                    size: 20.sp,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    '$rating ($reviewsCount reviews)',
<<<<<<< HEAD
                    style: AppTextStyles.s14w400.copyWith(
                      color: isDark ? Colors.white70 : AppColors.gray,
                    ),
=======
                    style: AppTextStyles.s14w400.copyWith(color: AppColors.gray),
>>>>>>> zoz
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 16.h),
          
          // Reviews List
<<<<<<< HEAD
          ...reviews.take(2).map((review) => _buildReviewItem(context, review)),
=======
          ...reviews.take(2).map((review) => _buildReviewItem(review)),
>>>>>>> zoz
          
          // See all reviews button
          if (reviewsCount > 2)
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(top: 16.h),
              child: ElevatedButton(
<<<<<<< HEAD
                onPressed: () => print('See all reviews'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDark 
                      ? Colors.white10 
                      : AppColors.gray.withOpacity(0.1),
                  foregroundColor: isDark ? Colors.white : AppColors.black,
=======
                onPressed: () {
                  
                  print('See all reviews');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.gray.withOpacity(0.1),
                  foregroundColor: AppColors.black,
>>>>>>> zoz
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                child: Text(
                  'See all reviews',
<<<<<<< HEAD
                  style: AppTextStyles.s14w500.copyWith(
                    color: isDark ? Colors.white : AppColors.black,
                  ),
=======
                  style: AppTextStyles.s14w500,
>>>>>>> zoz
                ),
              ),
            ),
        ],
      ),
    );
  }

<<<<<<< HEAD
  Widget _buildReviewItem(BuildContext context, Map<String, dynamic> review) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

=======
  Widget _buildReviewItem(Map<String, dynamic> review) {
>>>>>>> zoz
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Reviewer Avatar
          CircleAvatar(
            radius: 20.r,
<<<<<<< HEAD
            backgroundColor: isDark 
                ? Colors.white12 
                : AppColors.gray.withOpacity(0.2),
=======
            backgroundColor: AppColors.gray.withOpacity(0.2),
>>>>>>> zoz
            child: review['avatar'] != null
                ? ClipOval(
                    child: Image.asset(
                      review['avatar'],
                      width: 40.w,
                      height: 40.h,
                      fit: BoxFit.cover,
                    ),
                  )
                : Icon(
                    Icons.person,
<<<<<<< HEAD
                    color: isDark ? Colors.white70 : AppColors.gray,
=======
                    color: AppColors.gray,
>>>>>>> zoz
                    size: 20.sp,
                  ),
          ),
          SizedBox(width: 12.w),
          
          // Review Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
<<<<<<< HEAD
                Text(
                  review['name'] ?? 'Anonymous',
                  style: AppTextStyles.s14w500.copyWith(
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
=======
                                 Text(
                   review['name'] ?? 'Anonymous',
                   style: AppTextStyles.s14w500,
                 ),
>>>>>>> zoz
                SizedBox(height: 4.h),
                
                // Rating Stars
                Row(
                  children: List.generate(5, (index) {
                    return Icon(
                      index < (review['rating'] ?? 0) 
                          ? Icons.star 
                          : Icons.star_border,
                      color: Colors.amber,
                      size: 14.sp,
                    );
                  }),
                ),
                SizedBox(height: 8.h),
                
                Text(
                  review['comment'] ?? 'Great product!',
<<<<<<< HEAD
                  style: AppTextStyles.s14w400.copyWith(
                    color: isDark ? Colors.white70 : AppColors.gray,
                  ),
=======
                  style: AppTextStyles.s14w400.copyWith(color: AppColors.gray),
>>>>>>> zoz
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
