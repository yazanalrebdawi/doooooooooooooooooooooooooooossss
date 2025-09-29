// BULLETPROOF DEPENDENCY INJECTION CONFIGURATION
// NO COMPROMISES, NO SHORTCUTS, GUARANTEED TO WORK

<<<<<<< HEAD
// ignore_for_file: avoid_print

import 'package:dooss_business_app/features/auth/presentation/widgets/custom_app_snack_bar.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
=======
import 'dart:developer';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dooss_business_app/core/app/source/local/app_manager_local_data_source.dart';
import 'package:dooss_business_app/core/app/source/local/app_manager_local_data_source_impl.dart';
import 'package:dooss_business_app/core/app/source/remote/app_magaer_remote_data_source.dart';
import 'package:dooss_business_app/core/app/source/remote/app_magaer_remote_data_source_impl.dart';
import 'package:dooss_business_app/core/app/source/repo/app_manager_repository.dart';
import 'package:dooss_business_app/core/app/source/repo/app_manager_repository_impl.dart';
import 'package:dooss_business_app/core/services/image/image_services.dart';
import 'package:dooss_business_app/core/services/image/image_services_impl.dart';
import 'package:dooss_business_app/core/services/network/network_info_service.dart';
import 'package:dooss_business_app/core/services/network/network_info_service_impl.dart';
import 'package:dooss_business_app/core/services/storage/hivi/hive_service.dart';
import 'package:dooss_business_app/core/services/storage/hivi/hive_service_impl.dart';
import 'package:dooss_business_app/core/services/storage/secure_storage/secure_storage_service.dart';
import 'package:dooss_business_app/core/services/storage/shared_preferances/shared_preferences_service.dart';
import 'package:dooss_business_app/core/services/translation/translation_service.dart';
import 'package:dooss_business_app/core/services/translation/translation_service_impl.dart';
import 'package:dooss_business_app/features/auth/data/source/remote/auth_remote_data_source.dart';
import 'package:dooss_business_app/features/auth/data/source/repo/auth_repository.dart';
import 'package:dooss_business_app/features/auth/data/source/repo/auth_repository_impl.dart';
import 'package:dooss_business_app/features/my_profile/data/source/local/my_profile_local_data_source.dart';
import 'package:dooss_business_app/features/my_profile/data/source/local/my_profile_local_data_source_impl.dart';
import 'package:dooss_business_app/features/my_profile/data/source/remote/my_profile_remote_data_source.dart';
import 'package:dooss_business_app/features/my_profile/data/source/remote/my_profile_remote_data_source_impl.dart';
import 'package:dooss_business_app/features/my_profile/data/source/repo/my_profile_repository.dart';
import 'package:dooss_business_app/features/my_profile/data/source/repo/my_profile_repository_impl.dart';
import 'package:get_it/get_it.dart';
>>>>>>> zoz
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Core Network
import 'package:dooss_business_app/core/network/api.dart';
import 'package:dooss_business_app/core/network/app_dio.dart';

// Auth
<<<<<<< HEAD
import 'package:dooss_business_app/features/auth/data/data_source/auth_remote_data_source_imp.dart';
=======
import 'package:dooss_business_app/features/auth/data/source/remote/auth_remote_data_source_imp.dart';
>>>>>>> zoz
import 'package:dooss_business_app/features/auth/presentation/manager/auth_cubit.dart';

// Cars
import 'package:dooss_business_app/features/home/data/data_source/car_remote_data_source.dart';
import 'package:dooss_business_app/features/home/presentaion/manager/car_cubit.dart';

// Products
import 'package:dooss_business_app/features/home/data/data_source/product_remote_data_source.dart';
import 'package:dooss_business_app/features/home/data/data_source/product_remote_data_source_imp.dart';
import 'package:dooss_business_app/features/home/presentaion/manager/product_cubit.dart';

// Services
import 'package:dooss_business_app/features/home/data/data_source/service_remote_data_source.dart';
import 'package:dooss_business_app/features/home/data/data_source/service_remote_data_source_imp.dart';
import 'package:dooss_business_app/features/home/presentaion/manager/service_cubit.dart';

// Reels - THE CRITICAL ONES
import 'package:dooss_business_app/features/home/data/data_source/reel_remote_data_source.dart';
import 'package:dooss_business_app/features/home/data/data_source/reel_remote_data_source_imp.dart';
import 'package:dooss_business_app/features/home/presentaion/manager/reel_cubit.dart';
import 'package:dooss_business_app/features/home/presentaion/manager/reels_cubit.dart';
import 'package:dooss_business_app/features/home/presentaion/manager/reels_playback_cubit.dart';

// Other Cubits
import 'package:dooss_business_app/features/home/presentaion/manager/home_cubit.dart';
import 'package:dooss_business_app/features/home/presentaion/manager/maps_cubit.dart';

// Chat
import 'package:dooss_business_app/features/chat/data/data_source/chat_remote_data_source.dart';
import 'package:dooss_business_app/features/chat/data/data_source/chat_remote_data_source_imp.dart';
import 'package:dooss_business_app/features/chat/presentation/manager/chat_cubit.dart';

// Services
import 'package:dooss_business_app/core/services/websocket_service.dart';

// Dealer Profile
import 'package:dooss_business_app/features/profile_dealer/data/data_source/dealer_profile_remote_data_source.dart';
import 'package:dooss_business_app/features/profile_dealer/presentation/manager/dealer_profile_cubit.dart';

<<<<<<< HEAD
final sl = GetIt.instance; // <-- NO PARENTHESES!

Future<void> init() async {
  print('🔧 DI: Starting bulletproof dependency injection...');

  // =================================================================
  // PHASE 1: EXTERNAL PACKAGES (Register these FIRST)
  // =================================================================
  print('📦 DI: Registering external packages...');

  // SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  print('✅ DI: SharedPreferences registered');

  // Flutter Secure Storage
  sl.registerLazySingleton(() => const FlutterSecureStorage());
  print('✅ DI: FlutterSecureStorage registered');
=======
final appLocator = GetIt.instance; // <-- NO PARENTHESES!
final connectivity = Connectivity(); //* Handell Connectivity Network

Future<void> init() async {
  log('🔧 DI: Starting bulletproof dependency injection...');
  //?--------------------------------------------------------------------------
  //?----------    Service           ------------------------------------------
  //?--------------------------------------------------------------------------

  //! Network Info
  appLocator.registerLazySingleton<NetworkInfoService>(
    () => NetworkInfoServiceImpl(connectivity),
  );

  //? ----------- Storage -----------------------------------------------------------

  //! Flutter Secure Storage
  appLocator.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );

  //! Secure Storage Service
  appLocator.registerLazySingleton<SecureStorageService>(
    () => SecureStorageService(storage: appLocator<FlutterSecureStorage>()),
  );

  //! Shared Preferences
  final sharedPrefs = await SharedPreferences.getInstance();
  appLocator.registerLazySingleton<SharedPreferences>(() => sharedPrefs);

  //! Shared Preferences Service
  appLocator.registerLazySingleton<SharedPreferencesService>(
    () => SharedPreferencesService(
      storagePreferences: appLocator<SharedPreferences>(),
    ),
  );

  //! Hive Service
  appLocator.registerLazySingleton<HiveService>(() => HiveServiceImpl());

  //! User Storage Service
  // appLocator.registerLazySingleton<UserStorageService>(
  //   () => UserStorageService(
  //     secureStorage: appLocator<SecureStorageService>(),
  //     sharedPreference: appLocator<SharedPreferencesService>(),
  //   ),
  // );

  //? ----------- translation ------------------------------------------------------
  appLocator.registerLazySingleton<TranslationService>(
    () => TranslationServiceImpl(
      storagePreferanceService: appLocator<SharedPreferencesService>(),
    ),
  );

  //? ----------- Image -------------------------------------------------------------
  appLocator.registerLazySingleton<ImageServices>(
    () => ImageServicesImpl(
      storagePreferences: appLocator<SharedPreferencesService>(),
    ),
  );
  //? ----------- Local Data Sources --------------------------------------------------

  //! App Manager Local
  appLocator.registerLazySingleton<AppManagerLocalDataSource>(
    () => AppManagerLocalDataSourceImpl(
      sharedPreferenc: appLocator<SharedPreferencesService>(),
      secureStorage: appLocator<SecureStorageService>(),
      hive: appLocator<HiveService>(),
    ),
  );

  //* My Profile local
  appLocator.registerLazySingleton<MyProfileLocalDataSource>(
    () => MyProfileLocalDataSourceImpl(
      hive: appLocator<HiveService>(),
      sharedPreferenc: appLocator<SharedPreferencesService>(),
    ),
  );

  //? ----------- Remote Data Sources -----------------------------------------------------------

  //! App Manager Remote
  appLocator.registerLazySingleton<AppMagaerRemoteDataSource>(
    () => AppMagaerRemoteDataSourceImpl(api: appLocator<API>()),
  );

  //* Auth Remote
  appLocator.registerLazySingleton<MyProfileRemoteDataSource>(
    () => MyProfileRemoteDataSourceImpl(api: appLocator<API>()),
  );

  //? ----------- Repositories ------------------------------------------------------------------
  //! App Manager Repositories
  appLocator.registerLazySingleton<AppManagerRepository>(
    () => AppManagerRepositoryImpl(
      remote: appLocator<AppMagaerRemoteDataSource>(),
      local: appLocator<AppManagerLocalDataSource>(),
      network: appLocator<NetworkInfoService>(),
    ),
  );

  //* My Profile Repository
  appLocator.registerLazySingleton<MyProfileRepository>(
    () => MyProfileRepositoryImpl(
      remote: appLocator<MyProfileRemoteDataSource>(),
      local: appLocator<MyProfileLocalDataSource>(),
      network: appLocator<NetworkInfoService>(),
    ),
  );

  //* My Profile Repository
  appLocator.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remote: appLocator<AuthRemoteDataSource>(),
      network: appLocator<NetworkInfoService>(),
    ),
  );

  //? --------------------------------------------------------------------------------------------
  //? =================================================================
  //? PHASE 1: EXTERNAL PACKAGES (Register these FIRST)
  //? =================================================================
  // log('📦 DI: Registering external packages...');

  //  SharedPreferences
  // final sharedPreferences = await SharedPreferences.getInstance();
  // appLocator.registerLazySingleton(() => sharedPreferences);
  // log('✅ DI: SharedPreferences registered');

  // Flutter Secure Storage
  // appLocator.registerLazySingleton(() => const FlutterSecureStorage());
  // log('✅ DI: FlutterSecureStorage registered');
>>>>>>> zoz

  // =================================================================
  // PHASE 2: CORE NETWORK LAYER (Foundation)
  // =================================================================
<<<<<<< HEAD
  print('🌐 DI: Registering core network layer...');

  sl.registerLazySingleton<AppDio>(() => AppDio());
  print('✅ DI: AppDio registered');

  sl.registerLazySingleton<API>(() => API(dio: sl<AppDio>().dio));
  print('✅ DI: API registered');

  sl.registerLazySingleton<WebSocketService>(() => WebSocketService());
  print('✅ DI: WebSocketService registered');
=======
  log('🌐 DI: Registering core network layer...');

  appLocator.registerLazySingleton<AppDio>(() => AppDio());
  log('✅ DI: AppDio registered');

  appLocator.registerLazySingleton<API>(
    () => API(dio: appLocator<AppDio>().dio),
  );
  log('✅ DI: API registered');

  appLocator.registerLazySingleton<WebSocketService>(() => WebSocketService());
  log('✅ DI: WebSocketService registered');
>>>>>>> zoz

  // =================================================================
  // PHASE 3: DATA SOURCES (Dependencies for Cubits) - CRITICAL ORDER
  // =================================================================
<<<<<<< HEAD
  print('📊 DI: Registering data sources...');

  // Auth DataSource
  sl.registerLazySingleton<AuthRemoteDataSourceImp>(
      () => AuthRemoteDataSourceImp(api: sl<API>()));
  print('✅ DI: AuthRemoteDataSourceImp registered');

  // Car DataSource
  sl.registerLazySingleton<CarRemoteDataSource>(
      () => CarRemoteDataSourceImpl(sl<AppDio>()));
  print('✅ DI: CarRemoteDataSource registered');

  // Product DataSource
  sl.registerLazySingleton<ProductRemoteDataSource>(
      () => ProductRemoteDataSourceImp(api: sl<API>()));
  print('✅ DI: ProductRemoteDataSource registered');

  // Service DataSource
  sl.registerLazySingleton<ServiceRemoteDataSource>(
      () => ServiceRemoteDataSourceImp(api: sl<API>()));
  print('✅ DI: ServiceRemoteDataSource registered');

  // 🎬 REELS DATA SOURCE - THE CRITICAL ONE
  print('🎬 DI: About to register ReelRemoteDataSource...');
  print('🔍 DI: Checking AppDio availability: ${sl.isRegistered<AppDio>()}');
  sl.registerLazySingleton<ReelRemoteDataSource>(() {
    print('🏗️ DI: Creating ReelRemoteDataSourceImp instance...');
    final appDio = sl<AppDio>();
    print('✅ DI: AppDio retrieved successfully');
    final instance = ReelRemoteDataSourceImp(dio: appDio);
    print('✅ DI: ReelRemoteDataSourceImp created successfully');
    return instance;
  });
  print('🎯 DI: ReelRemoteDataSource registered successfully');

  // Chat DataSource
  sl.registerLazySingleton<ChatRemoteDataSource>(
      () => ChatRemoteDataSourceImp(api: sl<API>()));
  print('✅ DI: ChatRemoteDataSource registered');

  // Dealer Profile DataSource
  sl.registerLazySingleton<DealerProfileRemoteDataSource>(
      () => DealerProfileRemoteDataSourceImpl(sl<AppDio>()));
  print('✅ DI: DealerProfileRemoteDataSource registered');
=======
  log('📊 DI: Registering data sources...');

  // Auth DataSource
  appLocator.registerLazySingleton<AuthRemoteDataSourceImp>(
    () => AuthRemoteDataSourceImp(api: appLocator<API>()),
  );
  log('✅ DI: AuthRemoteDataSourceImp registered');

  // Car DataSource
  appLocator.registerLazySingleton<CarRemoteDataSource>(
    () => CarRemoteDataSourceImpl(appLocator<AppDio>()),
  );
  log('✅ DI: CarRemoteDataSource registered');

  // Product DataSource
  appLocator.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImp(api: appLocator<API>()),
  );
  log('✅ DI: ProductRemoteDataSource registered');

  // Service DataSource
  appLocator.registerLazySingleton<ServiceRemoteDataSource>(
    () => ServiceRemoteDataSourceImp(api: appLocator<API>()),
  );
  log('✅ DI: ServiceRemoteDataSource registered');

  // 🎬 REELS DATA SOURCE - THE CRITICAL ONE
  log('🎬 DI: About to register ReelRemoteDataSource...');
  log(
    '🔍 DI: Checking AppDio availability: ${appLocator.isRegistered<AppDio>()}',
  );
  appLocator.registerLazySingleton<ReelRemoteDataSource>(() {
    log('🏗️ DI: Creating ReelRemoteDataSourceImp instance...');
    final appDio = appLocator<AppDio>();
    log('✅ DI: AppDio retrieved successfully');
    final instance = ReelRemoteDataSourceImp(dio: appDio);
    log('✅ DI: ReelRemoteDataSourceImp created successfully');
    return instance;
  });
  log('🎯 DI: ReelRemoteDataSource registered successfully');

  // Chat DataSource
  appLocator.registerLazySingleton<ChatRemoteDataSource>(
    () => ChatRemoteDataSourceImp(api: appLocator<API>()),
  );
  log('✅ DI: ChatRemoteDataSource registered');

  // Dealer Profile DataSource
  appLocator.registerLazySingleton<DealerProfileRemoteDataSource>(
    () => DealerProfileRemoteDataSourceImpl(appLocator<AppDio>()),
  );
  log('✅ DI: DealerProfileRemoteDataSource registered');
>>>>>>> zoz

  // =================================================================
  // PHASE 4: CUBITS (Now that all dependencies exist)
  // =================================================================
<<<<<<< HEAD
  print('🧠 DI: Registering cubits...');

  // Auth Cubit
  sl.registerFactory<AuthCubit>(() => AuthCubit(sl<AuthRemoteDataSourceImp>()));
  print('✅ DI: AuthCubit registered');

  // Car Cubit
  sl.registerFactory<CarCubit>(() => CarCubit(sl<CarRemoteDataSource>()));
  print('✅ DI: CarCubit registered');

  // Product Cubit
  sl.registerFactory<ProductCubit>(
      () => ProductCubit(sl<ProductRemoteDataSource>()));
  print('✅ DI: ProductCubit registered');

  // Service Cubit
  sl.registerFactory<ServiceCubit>(
      () => ServiceCubit(sl<ServiceRemoteDataSource>()));
  print('✅ DI: ServiceCubit registered');

  // Reel Cubit (Old one for data loading)
  sl.registerFactory<ReelCubit>(
      () => ReelCubit(dataSource: sl<ReelRemoteDataSource>()));
  print('✅ DI: ReelCubit registered');

  // 🎬 NEW LIGHTWEIGHT REELS CUBIT - GLOBAL PLAYBACK STATE
  sl.registerLazySingleton<ReelsCubit>(() => ReelsCubit());
  print('✅ DI: ReelsCubit (lightweight) registered');

  // 🎬 REELS PLAYBACK CUBIT - THE CRITICAL SINGLETON
  print('🎬 DI: About to register ReelsPlaybackCubit...');
  print(
      '🔍 DI: Verifying ReelRemoteDataSource: ${sl.isRegistered<ReelRemoteDataSource>()}');
  sl.registerLazySingleton<ReelsPlaybackCubit>(() {
    print('🏗️ DI: Creating ReelsPlaybackCubit instance...');
    final dataSource = sl<ReelRemoteDataSource>();
    print('✅ DI: ReelRemoteDataSource retrieved successfully');
    final cubit = ReelsPlaybackCubit(dataSource: dataSource);
    print('✅ DI: ReelsPlaybackCubit created successfully');
    return cubit;
  });
  print('🎯 DI: ReelsPlaybackCubit registered successfully');

  // Home Cubit
  sl.registerFactory<HomeCubit>(() => HomeCubit());
  print('✅ DI: HomeCubit registered');

  // Maps Cubit
  sl.registerFactory<MapsCubit>(() => MapsCubit());
  print('✅ DI: MapsCubit registered');

  // Chat Cubit
  sl.registerFactory<ChatCubit>(() => ChatCubit(sl<ChatRemoteDataSource>()));
  print('✅ DI: ChatCubit registered');

  // Dealer Profile Cubit
  sl.registerFactory<DealerProfileCubit>(
      () => DealerProfileCubit(sl<DealerProfileRemoteDataSource>()));
  print('✅ DI: DealerProfileCubit registered');
=======
  log('🧠 DI: Registering cubits...');

  // Auth Cubit
  appLocator.registerFactory<AuthCubit>(
    () => AuthCubit(
      remote: appLocator<AuthRemoteDataSourceImp>(),
      secureStorage: appLocator<SecureStorageService>(),
      sharedPreference: appLocator<SharedPreferencesService>(),
    ),
  );
  log('✅ DI: AuthCubit registered');

  // Car Cubit
  appLocator.registerFactory<CarCubit>(
    () => CarCubit(appLocator<CarRemoteDataSource>()),
  );
  log('✅ DI: CarCubit registered');

  // Product Cubit
  appLocator.registerFactory<ProductCubit>(
    () => ProductCubit(appLocator<ProductRemoteDataSource>()),
  );
  log('✅ DI: ProductCubit registered');

  // Service Cubit
  appLocator.registerFactory<ServiceCubit>(
    () => ServiceCubit(appLocator<ServiceRemoteDataSource>()),
  );
  log('✅ DI: ServiceCubit registered');

  // Reel Cubit (Old one for data loading)
  appLocator.registerFactory<ReelCubit>(
    () => ReelCubit(dataSource: appLocator<ReelRemoteDataSource>()),
  );
  log('✅ DI: ReelCubit registered');

  // 🎬 NEW LIGHTWEIGHT REELS CUBIT - GLOBAL PLAYBACK STATE
  appLocator.registerLazySingleton<ReelsCubit>(() => ReelsCubit());
  log('✅ DI: ReelsCubit (lightweight) registered');

  // 🎬 REELS PLAYBACK CUBIT - THE CRITICAL SINGLETON
  log('🎬 DI: About to register ReelsPlaybackCubit...');
  log(
    '🔍 DI: Verifying ReelRemoteDataSource: ${appLocator.isRegistered<ReelRemoteDataSource>()}',
  );
  appLocator.registerLazySingleton<ReelsPlaybackCubit>(() {
    log('🏗️ DI: Creating ReelsPlaybackCubit instance...');
    final dataSource = appLocator<ReelRemoteDataSource>();
    log('✅ DI: ReelRemoteDataSource retrieved successfully');
    final cubit = ReelsPlaybackCubit(dataSource: dataSource);
    log('✅ DI: ReelsPlaybackCubit created successfully');
    return cubit;
  });
  log('🎯 DI: ReelsPlaybackCubit registered successfully');

  // Home Cubit
  appLocator.registerFactory<HomeCubit>(() => HomeCubit());
  log('✅ DI: HomeCubit registered');

  // Maps Cubit
  appLocator.registerFactory<MapsCubit>(() => MapsCubit());
  log('✅ DI: MapsCubit registered');

  // Chat Cubit
  appLocator.registerFactory<ChatCubit>(
    () => ChatCubit(appLocator<ChatRemoteDataSource>()),
  );
  log('✅ DI: ChatCubit registered');

  // Dealer Profile Cubit
  appLocator.registerFactory<DealerProfileCubit>(
    () => DealerProfileCubit(appLocator<DealerProfileRemoteDataSource>()),
  );
  log('✅ DI: DealerProfileCubit registered');
>>>>>>> zoz

  // =================================================================
  // FINAL VERIFICATION
  // =================================================================
<<<<<<< HEAD
  print('🔍 DI: Final verification...');
  print('📊 DI: Total registered services: ${sl.allReady()}');
  print(
      '🎬 DI: ReelRemoteDataSource registered: ${sl.isRegistered<ReelRemoteDataSource>()}');
  print(
      '🎬 DI: ReelsPlaybackCubit registered: ${sl.isRegistered<ReelsPlaybackCubit>()}');

  print('🎯 DI: BULLETPROOF DEPENDENCY INJECTION COMPLETE!');

  // toast notifications bar
  sl.registerFactory<ToastNotification>(() => ToastNotificationImp());
=======
  log('🔍 DI: Final verification...');
  // log('📊 DI: Total registered services: ${appLocator.allReady()}');
  log(
    '🎬 DI: ReelRemoteDataSource registered: ${appLocator.isRegistered<ReelRemoteDataSource>()}',
  );
  log(
    '🎬 DI: ReelsPlaybackCubit registered: ${appLocator.isRegistered<ReelsPlaybackCubit>()}',
  );
  log('🎯 DI: BULLETPROOF DEPENDENCY INJECTION COMPLETE!');
>>>>>>> zoz
}
