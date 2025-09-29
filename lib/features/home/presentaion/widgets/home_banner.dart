import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeBanner extends StatelessWidget {
  const HomeBanner({super.key});

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    final isDark = Theme.of(context).brightness == Brightness.dark;

=======
>>>>>>> zoz
    return Container(
      height: 180.h,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
<<<<<<< HEAD
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'assets/images/head_image_home_screen.png',
              fit: BoxFit.cover,
            ),
            if (isDark)
              Container(
                color: Colors.black.withOpacity(0.2), // subtle dark overlay
              ),
          ],
=======
        child: Image.asset(
          'assets/images/head_image_home_screen.png', // يمكن تغييرها لصورة البانر المطلوبة
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
>>>>>>> zoz
        ),
      ),
    );
  }
<<<<<<< HEAD
}
=======
} 
>>>>>>> zoz
