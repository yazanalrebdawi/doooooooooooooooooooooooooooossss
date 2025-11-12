import 'dart:async';
import 'dart:developer';
import 'package:dooss_business_app/user/core/app/manager/app_manager_cubit.dart';
import 'package:dooss_business_app/user/core/constants/colors.dart';
import 'package:dooss_business_app/user/core/network/app_dio.dart';
import 'package:dooss_business_app/user/core/routes/route_names.dart';
import 'package:dooss_business_app/user/core/services/locator_service.dart';
import 'package:dooss_business_app/user/core/services/token_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dooss_business_app/user/core/services/storage/secure_storage/secure_storage_service.dart';
import 'package:dooss_business_app/user/core/services/storage/shared_preferances/shared_preferences_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  final SharedPreferencesService? sharedPreferences;

  const SplashScreen({super.key, this.sharedPreferences});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _scale = Tween<double>(
      begin: 0.85,
      end: 1.02,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutBack));
    _fade = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeIn));

    _ctrl.forward();

    _startChecks();
  }

  Future<void> _startChecks() async {
    final secureStorage1 = appLocator<SecureStorageService>();
    // final dealer = await secureStorage1.getDealerAuthData();
    final dealer =
        await appLocator<SharedPreferencesService>().getDealerAuthData();
    final flag = await secureStorage1.getIsDealer();
    final token = await TokenService.getAccessToken();
    log(token.toString());
    log("📦 Dealer just saved: data=${dealer?.toMap()}, flag=$flag");
    final secureStorage = appLocator<SecureStorageService>();
    // final checkDealer = await secureStorage.getDealerAuthData();
    final checkDealer =
        await appLocator<SharedPreferencesService>().getDealerAuthData();
    final checkFlag = await secureStorage.getIsDealer();
    log("📦 Saved dealer flag: $checkFlag");
    log("📦 Saved dealer data: ${checkDealer?.toMap()}");
    const minDisplay = Duration(milliseconds: 1000);
    await Future.delayed(minDisplay);

    bool isAuthenticated = false;
    bool isDealer = false;

    try {
      final storage = appLocator<SecureStorageService>();
      final appDio = appLocator<AppDio>();
      final appManagerCubit = context.read<AppManagerCubit>();

      // 🔹 جلب بيانات Dealer
      // final dealer = await storage.getDealerAuthData();
      // final dealer =
      //     await appLocator<SharedPreferencesService>().getDealerAuthData();
      // final dealerFlag = await storage.getIsDealer();

      if (checkDealer != null) {
        // ✅ Dealer موجود
        appDio.addTokenToHeader(checkDealer.access);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          appManagerCubit.saveDealerData(checkDealer);
        });

        isAuthenticated = true;
        isDealer = true;
        log("✅ Dealer authenticated successfully");
      } else {
        // 🔹 جلب بيانات المستخدم العادي
        final auth = await storage.getAuthModel();

        if (auth != null &&
            auth.token.isNotEmpty &&
            auth.expiry != null &&
            DateTime.now().isBefore(auth.expiry!)) {
          appDio.addTokenToHeader(auth.token);
          WidgetsBinding.instance.addPostFrameCallback((_) {
            appManagerCubit.saveUserData(auth.user);
          });

          isAuthenticated = true;
          isDealer = false;
          log("✅ Regular user authenticated successfully");
        } else {
          log("⚠️ No user or dealer data found");
        }
      }
    } catch (e) {
      log("❌ Error in _startChecks: $e");
      isAuthenticated = false;
    }

    // 🚀 التوجيه حسب الحالة
    if (!mounted) return;

    await Future.delayed(const Duration(milliseconds: 200));

    if (isAuthenticated) {
      if (isDealer) {
        context.go(RouteNames.navigatorPage);

        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(builder: (_) => NavigatorPage()),
        // );
      } else {
        context.go(RouteNames.homeScreen);
      }
    } else {
      context.go(RouteNames.onBoardingScreen);
    }
  }

  // Future<void> _startChecks() async {
  //   const minDisplay = Duration(milliseconds: 1200);
  //   final timer = Future.delayed(minDisplay);

  //   bool isAuthenticated = false;
  //   UserModel? cachedUser;

  //   try {
  //     isAuthenticated = await TokenService.hasToken();
  //     log("[Token check] Token exists? $isAuthenticated");

  //     if (!isAuthenticated &&
  //         widget.secureStorage != null &&
  //         widget.sharedPreferences != null) {
  //       final sensitive = await widget.secureStorage!.getSensitiveData();
  //       if (sensitive != null) {
  //         final expiryStr = sensitive['expiry'] as String?;
  //         if (expiryStr != null && expiryStr.isNotEmpty) {
  //           final expiry = DateTime.tryParse(expiryStr);
  //           if (expiry != null && expiry.isAfter(DateTime.now())) {
  //             final token = sensitive['token'] as String?;
  //             if (token != null && token.isNotEmpty) isAuthenticated = true;
  //           }
  //         }
  //       }

  //       // جلب كامل بيانات اليوزر
  //       final userStorage = UserStorageService(
  //         secureStorage: widget.secureStorage!,
  //         sharedPreference: widget.sharedPreferences!,
  //       );

  //       cachedUser = await userStorage.getUserModel();
  //       final cachedToken = await userStorage.getToken();

  //       if (cachedToken != null) {
  //         appLocator<AppDio>().addTokenToHeader(cachedToken);
  //         log("Token added to Dio header");
  //       }

  //       // خزّن البيانات بالـ Cubit
  //       if (cachedUser != null) {
  //         final appManagerCubit = context.read<AppManagerCubit>();
  //         appManagerCubit.saveUserData(cachedUser);
  //         log("User data saved in Cubit");
  //       }
  //     }
  //   } catch (e) {
  //     log("Error in _startChecks: $e");
  //     isAuthenticated = false;
  //   }

  //   await timer;

  //   if (!mounted) return;

  //   if (isAuthenticated) {
  //     log("Go to Home Screen");
  //     context.go(RouteNames.homeScreen);
  //   } else {
  //     log("Go to OnBoarding Screen");
  //     context.go(RouteNames.onBoardingScreen);
  //   }
  // }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenHeight < 600;
    final isLargeScreen = screenWidth > 600;

    // Responsive logo size based on screen dimensions
    final logoSize = isSmallScreen
        ? screenWidth * 0.25
        : isLargeScreen
            ? screenWidth * 0.15
            : screenWidth * 0.3;

    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primary, AppColors.lightGreen],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isSmallScreen ? 20.w : 24.w,
                  vertical: isSmallScreen ? 12.h : 16.h,
                ),
                child: Center(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: FadeTransition(
                      opacity: _fade,
                      child: ScaleTransition(
                        scale: _scale,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Logo with responsive sizing
                            Container(
                              width: logoSize.clamp(70.0, 150.0),
                              height: logoSize.clamp(70.0, 150.0),
                              constraints: BoxConstraints(
                                maxWidth: isLargeScreen ? 150.w : 120.w,
                                maxHeight: isLargeScreen ? 150.h : 120.h,
                                minWidth: isSmallScreen ? 70.w : 80.w,
                                minHeight: isSmallScreen ? 70.h : 80.h,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: isSmallScreen ? 8.r : 12.r,
                                    offset:
                                        Offset(0, isSmallScreen ? 4.h : 6.h),
                                  ),
                                ],
                              ),
                              child: ClipOval(
                                child: Image.asset(
                                  "assets/icons/applogo.jpg",
                                  fit: BoxFit.contain,
                                  width: double.infinity,
                                  height: double.infinity,
                                ),
                              ),
                            ),
                            SizedBox(height: isSmallScreen ? 16.h : 20.h),
                            // Welcome text with responsive sizing
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: isSmallScreen ? 12.w : 16.w,
                              ),
                              child: Text(
                                'Welcome To Dooss',
                                textAlign: TextAlign.center,
                                style: theme.textTheme.titleLarge?.copyWith(
                                  color: AppColors.white,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: isSmallScreen ? 0.4 : 0.6,
                                  fontSize: isSmallScreen
                                      ? 20.sp
                                      : isLargeScreen
                                          ? 28.sp
                                          : 24.sp,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(height: isSmallScreen ? 6.h : 8.h),
                            // Verifying text with responsive sizing
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: isSmallScreen ? 12.w : 16.w,
                              ),
                              child: Text(
                                'Verifying account...',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: isSmallScreen
                                      ? 12.sp
                                      : isLargeScreen
                                          ? 16.sp
                                          : 14.sp,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
