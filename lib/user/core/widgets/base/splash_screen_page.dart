import 'dart:async';
import 'dart:developer';
import 'package:dooss_business_app/dealer/features/Home/presentation/page/navigotorPage.dart';
import 'package:dooss_business_app/user/core/app/manager/app_manager_cubit.dart';
import 'package:dooss_business_app/user/core/constants/colors.dart';
import 'package:dooss_business_app/user/core/network/app_dio.dart';
import 'package:dooss_business_app/user/core/routes/route_names.dart';
import 'package:dooss_business_app/user/core/services/locator_service.dart';
import 'package:dooss_business_app/user/core/services/token_service.dart';
import 'package:flutter/material.dart';
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
      final dealer =
          await appLocator<SharedPreferencesService>().getDealerAuthData();
      final dealerFlag = await storage.getIsDealer();

      if (checkDealer != null ) {
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
