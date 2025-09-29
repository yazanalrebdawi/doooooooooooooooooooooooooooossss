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
                style: AppTextStyles.s18w700,
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
                    style: AppTextStyles.s14w400.copyWith(color: AppColors.gray),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 16.h),
          
          // Reviews List
          ...reviews.take(2).map((review) => _buildReviewItem(review)),
          
          // See all reviews button
          if (reviewsCount > 2)
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(top: 16.h),
              child: ElevatedButton(
                onPressed: () {
                  
                  print('See all reviews');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.gray.withOpacity(0.1),
                  foregroundColor: AppColors.black,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                child: Text(
                  'See all reviews',
                  style: AppTextStyles.s14w500,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildReviewItem(Map<String, dynamic> review) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Reviewer Avatar
          CircleAvatar(
            radius: 20.r,
            backgroundColor: AppColors.gray.withOpacity(0.2),
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
                    color: AppColors.gray,
                    size: 20.sp,
                  ),
          ),
          SizedBox(width: 12.w),
          
          // Review Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                                 Text(
                   review['name'] ?? 'Anonymous',
                   style: AppTextStyles.s14w500,
                 ),
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
                  style: AppTextStyles.s14w400.copyWith(color: AppColors.gray),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
