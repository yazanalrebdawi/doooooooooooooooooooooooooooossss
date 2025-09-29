import 'dart:async';
import 'dart:developer';
import 'package:dooss_business_app/core/app/manager/app_manager_cubit.dart';
import 'package:dooss_business_app/core/constants/colors.dart';
import 'package:dooss_business_app/core/network/app_dio.dart';
import 'package:dooss_business_app/core/routes/route_names.dart';
import 'package:dooss_business_app/core/services/locator_service.dart';
import 'package:dooss_business_app/features/auth/data/models/auth_response_model.dart';
import 'package:flutter/material.dart';
import 'package:dooss_business_app/core/services/storage/secure_storage/secure_storage_service.dart';
import 'package:dooss_business_app/core/services/storage/shared_preferances/shared_preferences_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  final SecureStorageService? secureStorage;
  final SharedPreferencesService? sharedPreferences;

  const SplashScreen({super.key, this.secureStorage, this.sharedPreferences});

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
      duration: const Duration(milliseconds: 1100),
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
    const minDisplay = Duration(milliseconds: 1200);
    final timer = Future.delayed(minDisplay);

    bool isAuthenticated = false;
    AuthResponceModel? cachedAuth;

    try {
      // ✅ استرجاع كامل بيانات المستخدم من SecureStorage
      if (widget.secureStorage != null) {
        cachedAuth = await widget.secureStorage!.getAuthModel();
        log("[SecureStorage] Auth model loaded? ${cachedAuth != null}");
      }

      if (cachedAuth != null) {
        final token = cachedAuth.token;
        final expiry = cachedAuth.expiry;

        // ✅ التحقق من صلاحية التوكن
        if (token.isNotEmpty &&
            expiry != null &&
            DateTime.now().isBefore(expiry)) {
          isAuthenticated = true;
          appLocator<AppDio>().addTokenToHeader(token);

          log("✅ Token added to Dio header");
        }

        // ✅ خزّن بيانات اليوزر في Cubit بعد الـ build
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final appManagerCubit = context.read<AppManagerCubit>();
          if (cachedAuth?.user != null) {
            appManagerCubit.saveUserData(cachedAuth!.user);
            appLocator<SecureStorageService>().saveAuthModel(cachedAuth);
          }
          log("✅ User data saved in Cubit");
        });
      } else {
        log("⚠️ No cached user found");
      }
    } catch (e) {
      log("❌ Error in _startChecks: $e");
      isAuthenticated = false;
    }

    // ⏳ ضمان عرض السبلاتش للمدة الدنيا
    await timer;

    if (!mounted) return;

    // 🚀 الانتقال للشاشة المناسبة
    if (isAuthenticated) {
      log("➡️ Go to Home Screen");
      context.go(RouteNames.homeScreen);
    } else {
      log("➡️ Go to OnBoarding Screen");
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
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.startGradient, AppColors.endGradient],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: FadeTransition(
            opacity: _fade,
            child: ScaleTransition(
              scale: _scale,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      shape: BoxShape.circle,
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 12,
                          offset: Offset(0, 6),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Dooss Business',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.6,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'جاري التحقق من الحساب...',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
