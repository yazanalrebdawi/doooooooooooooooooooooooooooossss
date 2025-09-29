import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/colors.dart';

class ProductImageGallery extends StatefulWidget {
  final List<String> images;
  final String mainImage;

  const ProductImageGallery({
    super.key,
    required this.images,
    required this.mainImage,
  });

  @override
  State<ProductImageGallery> createState() => _ProductImageGalleryState();
}

class _ProductImageGalleryState extends State<ProductImageGallery> {
  int selectedImageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final allImages = [widget.mainImage, ...widget.images];
    
    return Column(
      children: [
        // Main Image
        Container(
          width: double.infinity,
          height: 300.h,
          color: AppColors.gray.withOpacity(0.1),
          child: allImages.isNotEmpty
              ? Image.network(
                  allImages[selectedImageIndex],
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.image,
                      color: AppColors.gray,
                      size: 64.sp,
                    );
                  },
                )
              : Icon(
                  Icons.image,
                  color: AppColors.gray,
                  size: 64.sp,
                ),
        ),
        
        // Thumbnail Images
        if (allImages.length > 1)
          Container(
            height: 80.h,
            padding: EdgeInsets.symmetric(vertical: 16.h),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              itemCount: allImages.length,
              itemBuilder: (context, index) {
                final isSelected = index == selectedImageIndex;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedImageIndex = index;
                    });
                  },
                  child: Container(
                    width: 60.w,
                    height: 60.h,
                    margin: EdgeInsets.only(right: 12.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(
                        color: isSelected ? AppColors.primary : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6.r),
                      child: Image.network(
                        allImages[index],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: AppColors.gray.withOpacity(0.2),
                            child: Icon(
                              Icons.image,
                              color: AppColors.gray,
                              size: 24.sp,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}
