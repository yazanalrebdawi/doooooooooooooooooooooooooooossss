import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../Core/style/app_text_style.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String subtitle;
  final Color backgroundColor;
  final double elevation;
  final Function() ontap;
  const CustomAppBar({
    Key? key,
    required this.title,
    required this.subtitle,
    this.backgroundColor = Colors.blue,
    this.elevation = 8.0,
    required this.ontap,
  }) : super(key: key);

  @override
  Size get preferredSize {
    // Increased responsive height - return max height to accommodate all screen sizes
    // Actual height will be calculated in build method based on screen size
    return Size.fromHeight(130.0);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    // Responsive height: 110 for small screens, 130 for larger screens
    final appBarHeight = screenHeight < 700 ? 110.0 : 130.0;
    final topPadding = MediaQuery.of(context).padding.top;
    
    return Container(
      height: appBarHeight + topPadding,
      padding: EdgeInsets.only(top: topPadding),
      decoration: BoxDecoration(
        color: backgroundColor,
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(
              96,
              0,
              0,
              0,
            ).withOpacity(0.1), // لون الظل
            spreadRadius: 2, // مدى انتشار الظل
            blurRadius: elevation, // نعومة الظل
            offset: Offset(0, 1), // اتجاه الظل
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
          child: Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: const Color.fromARGB(255, 40, 39, 39),
                  size: 24.sp,
                ),
                onPressed: () {
                  ontap();
                  Navigator.pop(context); // وظيفة السهم
                },
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: AppTextStyle.poppins616blueDark.copyWith(
                        fontSize: 18.sp,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      softWrap: false,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: const Color.fromARGB(179, 0, 0, 0),
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'poppins',
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
