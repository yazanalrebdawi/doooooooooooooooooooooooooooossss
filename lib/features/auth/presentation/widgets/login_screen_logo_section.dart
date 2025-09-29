import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginScreen2LogoSection extends StatelessWidget {
  const LoginScreen2LogoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 40.h),
        // Logo
        Center(
          child: Image.asset(
            'assets/images/logo_app_type_screen.png',
            height: 90.h,
          ),
        ),
        SizedBox(height: 32.h),
      ],
    );
  }
} 