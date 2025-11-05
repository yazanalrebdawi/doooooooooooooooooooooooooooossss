import 'dart:developer';
import 'package:dooss_business_app/dealer/Core/services/notification_service.dart';
import 'package:dooss_business_app/dealer/features/auth/data/dealers_auth_remoute_data_Source.dart';
import 'package:dooss_business_app/dealer/features/auth/presentation/manager/auth_Cubit_dealers.dart';
import 'package:dooss_business_app/user/core/app/manager/app_manager_cubit.dart';
import 'package:dooss_business_app/user/core/app/manager/app_manager_state.dart';
import 'package:dooss_business_app/user/core/models/enums/app_them_enum.dart';
import 'package:dooss_business_app/user/core/network/app_dio.dart';
import 'package:dooss_business_app/user/core/services/image/image_services.dart';
import 'package:dooss_business_app/user/core/services/locator_service.dart';
import 'package:dooss_business_app/user/core/services/storage/hivi/hive_service.dart';
import 'package:dooss_business_app/user/core/services/storage/hivi/hivi_init.dart';
import 'package:dooss_business_app/user/core/services/storage/secure_storage/secure_storage_service.dart';
import 'package:dooss_business_app/user/core/services/storage/shared_preferances/shared_preferences_service.dart';
import 'package:dooss_business_app/user/core/services/translation/translation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';
import 'user/core/services/locator_service.dart' as di;
import 'user/core/utils/performance_monitor.dart';
import 'user/core/style/app_theme.dart';
import 'user/core/routes/app_router.dart';
import 'user/core/localization/app_localizations.dart';

Future<void> main() async {
  log('🚀 MAIN: Starting app initialization...');
  // setUpDealer();
  //* 1. Ensure binding is initialized
  WidgetsFlutterBinding.ensureInitialized();
  log('✅ MAIN: Flutter binding initialized');
await LocalNotificationService.instance.initialize();

  // await Firebase.initializeApp(
   
  // );

  // 3. Initialize EasyLocalization

  // 4. Initialize Notification Service
  // await NotificationService.instance.initialize();



  //* 2. 🔥 Reset GetIt to clear any stale state
  log('🔥 MAIN: Resetting GetIt to clear stale state...');
  await GetIt.instance.reset();
  log('✅ MAIN: GetIt reset complete');

  //* 3. Re-initialize all dependencies
  log('🔧 MAIN: Initializing dependencies...');
  await di.init();
  log('✅ MAIN: Dependencies initialized');
  log('🎯 DI: ALL (User + Dealer) dependencies initialized');

  //* 4. Initialize performance monitoring
  PerformanceMonitor().init();
  log('✅ MAIN: Performance monitoring initialized');

  //* 5. Set up error handling
  FlutterError.onError = (FlutterErrorDetails details) {
    log('❌ FLUTTER ERROR: ${details.exception}');
    FlutterError.presentError(details);
  };
  log('✅ MAIN: Error handling configured');

  //* 6. Initialize Hive Cache
  await initHive();

  //* 7. Run the app
  log('🎬 MAIN: Launching SimpleReelsApp...');

  final isLight =
      await appLocator<SharedPreferencesService>().getThemeModeFromCache();
  final initialTheme = isLight == null
      ? AppThemeEnum.light
      : (isLight ? AppThemeEnum.light : AppThemeEnum.dark);
  runApp(
    ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return SimpleReelsApp(initialTheme: initialTheme);
      },
    ),
  );
}

class SimpleReelsApp extends StatelessWidget {
  final AppThemeEnum initialTheme;
  const SimpleReelsApp({super.key, required this.initialTheme});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cubit = AppManagerCubit(
          hive: di.appLocator<HiveService>(),
          secureStorage: appLocator<SecureStorageService>(),
          sharedPreference: appLocator<SharedPreferencesService>(),
          imageServices: appLocator<ImageServices>(),
          translationService: appLocator<TranslationService>(),
        );
        cubit.setTheme(initialTheme);
        cubit.getSavedLocale();
        return cubit;
      },
      child: BlocBuilder<AppManagerCubit, AppManagerState>(
        builder: (context, state) {
          return BlocProvider(
            create: (context) => AuthCubitDealers(DealersAuthRemouteDataSource(
                dio: AppDio().dio,
                secureStorage: appLocator<SecureStorageService>())),
            child: MaterialApp.router(
              debugShowCheckedModeBanner: false,
              theme: AppThemes.lightTheme,
              darkTheme: AppThemes.darkTheme,
              themeMode: state.themeMode == AppThemeEnum.light
                  ? ThemeMode.light
                  : ThemeMode.dark,
              routerConfig: AppRouter.router,
              locale: state.locale,
              supportedLocales: const [Locale('en'), Locale('ar')],
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
            ),
          );
        },
      ),
    );
  }
}
