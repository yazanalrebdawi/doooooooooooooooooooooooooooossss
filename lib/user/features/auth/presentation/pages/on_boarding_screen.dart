import 'dart:developer';

import 'package:dooss_business_app/dealer/features/Home/presentation/page/navigotorPage.dart';
import 'package:dooss_business_app/user/core/app/manager/app_manager_cubit.dart';
import 'package:dooss_business_app/user/core/services/locator_service.dart';
import 'package:dooss_business_app/user/core/services/storage/secure_storage/secure_storage_service.dart';
import 'package:dooss_business_app/user/core/services/storage/shared_preferances/shared_preferences_service.dart';
import 'package:dooss_business_app/user/core/services/token_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/routes/route_names.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenHeight < 700;
    final isLargeScreen = screenWidth > 600;
    
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/on_boarding.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.3),
                Colors.black.withOpacity(0.7),
              ],
            ),
          ),
          child: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isSmallScreen ? 20.w : 24.w,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: isSmallScreen ? 60.h : 142.h),

                              // Welcome Text
                              Text(
                                'Lets Start\nA New Experience\nWith Dooss.',
                                style: AppTextStyles.whiteS32W700.copyWith(
                                  fontSize: isSmallScreen
                                      ? 24.sp
                                      : isLargeScreen
                                          ? 36.sp
                                          : 32.sp,
                                ),
                              ),
                              SizedBox(height: isSmallScreen ? 120.h : 240.h),
                              Text(
                                'Discover your next ride with Dooss. we\'re here to make browsing and buying cars easy and enjoyable. Let\'s get started on your journey.',
                                style: AppTextStyles.whiteS16W400.copyWith(
                                  height: 1.5,
                                  fontSize: isSmallScreen
                                      ? 14.sp
                                      : isLargeScreen
                                          ? 18.sp
                                          : 16.sp,
                                ),
                              ),

                              SizedBox(height: isSmallScreen ? 16.h : 20.h),

                              // Page Indicators
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: isSmallScreen ? 28.w : 32.w,
                                    height: isSmallScreen ? 5.h : 6.h,
                                    decoration: BoxDecoration(
                                      color: AppColors.white,
                                      borderRadius: BorderRadius.circular(3.r),
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                  Container(
                                    width: isSmallScreen ? 14.w : 16.w,
                                    height: isSmallScreen ? 5.h : 6.h,
                                    decoration: BoxDecoration(
                                      color: AppColors.white.withOpacity(0.5),
                                      borderRadius: BorderRadius.circular(3.r),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: isSmallScreen ? 20.h : 40.h),

                      // Get Started Button - Made fully responsive
                      SizedBox(
                        width: double.infinity,
                        height: isSmallScreen ? 50.h : isLargeScreen ? 60.h : 56.h,
                        child: ElevatedButton(
                          onPressed: () async {
                            // final isDealer =
                            //     context.read<AppManagerCubit>().state.isDealer;
                            // final token = context
                            //     .read<AppManagerCubit>()
                            //     .state
                            //     .dealer
                            //     ?.access;
                            final secureStorage =
                                appLocator<SecureStorageService>();
                            final dealer = await secureStorage.getDealerAuthData();
                            final flag = await secureStorage.getIsDealer();
                            log("📦 Dealer just saved: data=${dealer?.toMap()}, flag=$flag");

                            final bool isDealer =
                                await appLocator<SecureStorageService>()
                                    .getIsDealer();

                            final data = await appLocator<SecureStorageService>()
                                .getDealerAuthData();
                            log(isDealer.toString());
                            if (isDealer && data != null) {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => NavigatorPage()));
                            } else {
                              context.go(RouteNames.loginScreen);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.onboardingButtonColor,
                            foregroundColor: AppColors.white,
                            padding: EdgeInsets.symmetric(
                              vertical: isSmallScreen ? 12.h : 16.h,
                              horizontal: 24.w,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                isSmallScreen ? 50.r : 62.r,
                              ),
                            ),
                            elevation: 0,
                            minimumSize: Size(
                              double.infinity,
                              isSmallScreen ? 50.h : isLargeScreen ? 60.h : 56.h,
                            ),
                          ),
                          child: Text(
                            'Get Started',
                            style: AppTextStyles.whiteS16W600.copyWith(
                              fontSize: isSmallScreen
                                  ? 14.sp
                                  : isLargeScreen
                                      ? 18.sp
                                      : 16.sp,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: isSmallScreen ? 24.h : 32.h),

                      // Home Indicator (for iPhone)
                      SizedBox(height: 8.h),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
