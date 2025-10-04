// ===============================================================
//  DOOSS BUSINESS APP
//  BULLETPROOF DEPENDENCY INJECTION CONFIGURATION
//  Unified for User + Dealer modules
// ===============================================================

import 'dart:developer';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// ------------------- USER CORE IMPORTS -------------------
import 'package:dooss_business_app/user/core/network/api.dart';
import 'package:dooss_business_app/user/core/network/app_dio.dart';
import 'package:dooss_business_app/user/core/services/network/network_info_service.dart';
import 'package:dooss_business_app/user/core/services/network/network_info_service_impl.dart';
import 'package:dooss_business_app/user/core/services/storage/hivi/hive_service.dart';
import 'package:dooss_business_app/user/core/services/storage/hivi/hive_service_impl.dart';
import 'package:dooss_business_app/user/core/services/storage/secure_storage/secure_storage_service.dart';
import 'package:dooss_business_app/user/core/services/storage/shared_preferances/shared_preferences_service.dart';
import 'package:dooss_business_app/user/core/services/translation/translation_service.dart';
import 'package:dooss_business_app/user/core/services/translation/translation_service_impl.dart';
import 'package:dooss_business_app/user/core/services/image/image_services.dart';
import 'package:dooss_business_app/user/core/services/image/image_services_impl.dart';
import 'package:dooss_business_app/user/core/services/websocket_service.dart';

// ------------------- USER APP MANAGER -------------------
import 'package:dooss_business_app/user/core/app/source/local/app_manager_local_data_source.dart';
import 'package:dooss_business_app/user/core/app/source/local/app_manager_local_data_source_impl.dart';
import 'package:dooss_business_app/user/core/app/source/remote/app_magaer_remote_data_source.dart';
import 'package:dooss_business_app/user/core/app/source/remote/app_magaer_remote_data_source_impl.dart';
import 'package:dooss_business_app/user/core/app/source/repo/app_manager_repository.dart';
import 'package:dooss_business_app/user/core/app/source/repo/app_manager_repository_impl.dart';

// ------------------- USER AUTH -------------------
import 'package:dooss_business_app/user/features/auth/data/source/remote/auth_remote_data_source.dart';
import 'package:dooss_business_app/user/features/auth/data/source/remote/auth_remote_data_source_imp.dart';
import 'package:dooss_business_app/user/features/auth/data/source/repo/auth_repository.dart';
import 'package:dooss_business_app/user/features/auth/data/source/repo/auth_repository_impl.dart';
import 'package:dooss_business_app/user/features/auth/presentation/manager/auth_cubit.dart';

// ------------------- USER PROFILE -------------------
import 'package:dooss_business_app/user/features/my_profile/data/source/local/my_profile_local_data_source.dart';
import 'package:dooss_business_app/user/features/my_profile/data/source/local/my_profile_local_data_source_impl.dart';
import 'package:dooss_business_app/user/features/my_profile/data/source/remote/my_profile_remote_data_source.dart';
import 'package:dooss_business_app/user/features/my_profile/data/source/remote/my_profile_remote_data_source_impl.dart';
import 'package:dooss_business_app/user/features/my_profile/data/source/repo/my_profile_repository.dart';
import 'package:dooss_business_app/user/features/my_profile/data/source/repo/my_profile_repository_impl.dart';

// ------------------- USER HOME -------------------
import 'package:dooss_business_app/user/features/home/data/data_source/car_remote_data_source.dart';
import 'package:dooss_business_app/user/features/home/data/data_source/product_remote_data_source.dart';
import 'package:dooss_business_app/user/features/home/data/data_source/product_remote_data_source_imp.dart';
import 'package:dooss_business_app/user/features/home/data/data_source/service_remote_data_source.dart';
import 'package:dooss_business_app/user/features/home/data/data_source/service_remote_data_source_imp.dart';
import 'package:dooss_business_app/user/features/home/data/data_source/reel_remote_data_source.dart';
import 'package:dooss_business_app/user/features/home/data/data_source/reel_remote_data_source_imp.dart';
import 'package:dooss_business_app/user/features/home/presentaion/manager/car_cubit.dart';
import 'package:dooss_business_app/user/features/home/presentaion/manager/product_cubit.dart';
import 'package:dooss_business_app/user/features/home/presentaion/manager/service_cubit.dart';
import 'package:dooss_business_app/user/features/home/presentaion/manager/reel_cubit.dart';
import 'package:dooss_business_app/user/features/home/presentaion/manager/reels_cubit.dart';
import 'package:dooss_business_app/user/features/home/presentaion/manager/reels_playback_cubit.dart';
import 'package:dooss_business_app/user/features/home/presentaion/manager/home_cubit.dart';
import 'package:dooss_business_app/user/features/home/presentaion/manager/maps_cubit.dart';

// ------------------- USER CHAT -------------------
import 'package:dooss_business_app/user/features/chat/data/data_source/chat_remote_data_source.dart';
import 'package:dooss_business_app/user/features/chat/data/data_source/chat_remote_data_source_imp.dart';
import 'package:dooss_business_app/user/features/chat/presentation/manager/chat_cubit.dart';

// ------------------- USER DEALER PROFILE -------------------
import 'package:dooss_business_app/user/features/profile_dealer/data/data_source/dealer_profile_remote_data_source.dart';
import 'package:dooss_business_app/user/features/profile_dealer/presentation/manager/dealer_profile_cubit.dart';

// ------------------- DEALER CORE IMPORTS -------------------
import 'package:dooss_business_app/dealer/Core/network/dealers_App_dio.dart';
import 'package:dooss_business_app/dealer/features/Home/data/remouteData/remoute_dealer_data_source.dart';
import 'package:dooss_business_app/dealer/features/reels/data/remoute_data_reels_source.dart';

// ===============================================================
// 🧠 GLOBAL LOCATOR
// ===============================================================
final appLocator = GetIt.instance;
final connectivity = Connectivity();

// ===============================================================
// 🚀 BULLETPROOF SINGLE INIT FUNCTION
// ===============================================================
Future<void> init() async {
  log('🔧 DI: Starting unified dependency injection...');

  // ------------------- Shared Services -------------------
  if (!appLocator.isRegistered<NetworkInfoService>()) {
    appLocator.registerLazySingleton<NetworkInfoService>(
      () => NetworkInfoServiceImpl(connectivity),
    );
  }

  if (!appLocator.isRegistered<FlutterSecureStorage>()) {
    appLocator.registerLazySingleton<FlutterSecureStorage>(
      () => const FlutterSecureStorage(),
    );
  }

  if (!appLocator.isRegistered<SecureStorageService>()) {
    appLocator.registerLazySingleton<SecureStorageService>(
      () => SecureStorageService(storage: appLocator<FlutterSecureStorage>()),
    );
  }

  final sharedPrefs = await SharedPreferences.getInstance();
  if (!appLocator.isRegistered<SharedPreferences>()) {
    appLocator.registerLazySingleton<SharedPreferences>(() => sharedPrefs);
  }

  if (!appLocator.isRegistered<SharedPreferencesService>()) {
    appLocator.registerLazySingleton<SharedPreferencesService>(
      () => SharedPreferencesService(
        storagePreferences: appLocator<SharedPreferences>(),
      ),
    );
  }

  if (!appLocator.isRegistered<HiveService>()) {
    appLocator.registerLazySingleton<HiveService>(() => HiveServiceImpl());
  }

  if (!appLocator.isRegistered<TranslationService>()) {
    appLocator.registerLazySingleton<TranslationService>(
      () => TranslationServiceImpl(
        storagePreferanceService: appLocator<SharedPreferencesService>(),
      ),
    );
  }

  if (!appLocator.isRegistered<ImageServices>()) {
    appLocator.registerLazySingleton<ImageServices>(
      () => ImageServicesImpl(
        storagePreferences: appLocator<SharedPreferencesService>(),
      ),
    );
  }

  // ------------------- Core Network -------------------
  if (!appLocator.isRegistered<AppDio>()) {
    appLocator.registerLazySingleton<AppDio>(() => AppDio());
  }

  if (!appLocator.isRegistered<Dio>()) {
    appLocator.registerLazySingleton<Dio>(() => appLocator<AppDio>().dio);
  }

  if (!appLocator.isRegistered<API>()) {
    appLocator.registerLazySingleton<API>(() => API(dio: appLocator<AppDio>().dio));
  }

  if (!appLocator.isRegistered<WebSocketService>()) {
    appLocator.registerLazySingleton<WebSocketService>(() => WebSocketService());
  }

  // ------------------- Local Data Sources -------------------
  if (!appLocator.isRegistered<AppManagerLocalDataSource>()) {
    appLocator.registerLazySingleton<AppManagerLocalDataSource>(
      () => AppManagerLocalDataSourceImpl(
        sharedPreferenc: appLocator<SharedPreferencesService>(),
        secureStorage: appLocator<SecureStorageService>(),
        hive: appLocator<HiveService>(),
      ),
    );
  }

  if (!appLocator.isRegistered<MyProfileLocalDataSource>()) {
    appLocator.registerLazySingleton<MyProfileLocalDataSource>(
      () => MyProfileLocalDataSourceImpl(
        hive: appLocator<HiveService>(),
        sharedPreferenc: appLocator<SharedPreferencesService>(),
      ),
    );
  }

  // ------------------- Remote Data Sources -------------------
  if (!appLocator.isRegistered<AppMagaerRemoteDataSource>()) {
    appLocator.registerLazySingleton<AppMagaerRemoteDataSource>(
      () => AppMagaerRemoteDataSourceImpl(api: appLocator<API>()),
    );
  }

  if (!appLocator.isRegistered<MyProfileRemoteDataSource>()) {
    appLocator.registerLazySingleton<MyProfileRemoteDataSource>(
      () => MyProfileRemoteDataSourceImpl(api: appLocator<API>()),
    );
  }

  // ✅ Register AuthRemoteDataSourceImp explicitly
  if (!appLocator.isRegistered<AuthRemoteDataSourceImp>()) {
    appLocator.registerLazySingleton<AuthRemoteDataSourceImp>(
      () => AuthRemoteDataSourceImp(api: appLocator<API>()),
    );
  }

  // Also register interface pointing to the concrete type
  if (!appLocator.isRegistered<AuthRemoteDataSource>()) {
    appLocator.registerLazySingleton<AuthRemoteDataSource>(
      () => appLocator<AuthRemoteDataSourceImp>(),
    );
  }

  if (!appLocator.isRegistered<CarRemoteDataSource>()) {
    appLocator.registerLazySingleton<CarRemoteDataSource>(
      () => CarRemoteDataSourceImpl(appLocator<AppDio>()),
    );
  }

  if (!appLocator.isRegistered<ProductRemoteDataSource>()) {
    appLocator.registerLazySingleton<ProductRemoteDataSource>(
      () => ProductRemoteDataSourceImp(api: appLocator<API>()),
    );
  }

  if (!appLocator.isRegistered<ServiceRemoteDataSource>()) {
    appLocator.registerLazySingleton<ServiceRemoteDataSource>(
      () => ServiceRemoteDataSourceImp(api: appLocator<API>()),
    );
  }

  if (!appLocator.isRegistered<ReelRemoteDataSource>()) {
    appLocator.registerLazySingleton<ReelRemoteDataSource>(
      () => ReelRemoteDataSourceImp(dio: appLocator<AppDio>()),
    );
  }

  if (!appLocator.isRegistered<ChatRemoteDataSource>()) {
    appLocator.registerLazySingleton<ChatRemoteDataSource>(
      () => ChatRemoteDataSourceImp(api: appLocator<API>()),
    );
  }

  if (!appLocator.isRegistered<DealerProfileRemoteDataSource>()) {
    appLocator.registerLazySingleton<DealerProfileRemoteDataSource>(
      () => DealerProfileRemoteDataSourceImpl(appLocator<AppDio>()),
    );
  }

  // ------------------- Repositories -------------------
  if (!appLocator.isRegistered<AppManagerRepository>()) {
    appLocator.registerLazySingleton<AppManagerRepository>(
      () => AppManagerRepositoryImpl(
        remote: appLocator<AppMagaerRemoteDataSource>(),
        local: appLocator<AppManagerLocalDataSource>(),
        network: appLocator<NetworkInfoService>(),
      ),
    );
  }

  if (!appLocator.isRegistered<MyProfileRepository>()) {
    appLocator.registerLazySingleton<MyProfileRepository>(
      () => MyProfileRepositoryImpl(
        remote: appLocator<MyProfileRemoteDataSource>(),
        local: appLocator<MyProfileLocalDataSource>(),
        network: appLocator<NetworkInfoService>(),
      ),
    );
  }

  if (!appLocator.isRegistered<AuthRepository>()) {
    appLocator.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(
        remote: appLocator<AuthRemoteDataSource>(),
        network: appLocator<NetworkInfoService>(),
      ),
    );
  }

  // ------------------- Cubits -------------------
  if (!appLocator.isRegistered<AuthCubit>()) {
    appLocator.registerFactory<AuthCubit>(
      () => AuthCubit(
        remote: appLocator<AuthRemoteDataSourceImp>(),
        secureStorage: appLocator<SecureStorageService>(),
        sharedPreference: appLocator<SharedPreferencesService>(),
      ),
    );
  }

  if (!appLocator.isRegistered<CarCubit>()) {
    appLocator.registerFactory<CarCubit>(
      () => CarCubit(appLocator<CarRemoteDataSource>()),
    );
  }

  if (!appLocator.isRegistered<ProductCubit>()) {
    appLocator.registerFactory<ProductCubit>(
      () => ProductCubit(appLocator<ProductRemoteDataSource>()),
    );
  }

  if (!appLocator.isRegistered<ServiceCubit>()) {
    appLocator.registerFactory<ServiceCubit>(
      () => ServiceCubit(appLocator<ServiceRemoteDataSource>()),
    );
  }

  if (!appLocator.isRegistered<ReelCubit>()) {
    appLocator.registerFactory<ReelCubit>(
      () => ReelCubit(dataSource: appLocator<ReelRemoteDataSource>()),
    );
  }

  if (!appLocator.isRegistered<ReelsCubit>()) {
    appLocator.registerLazySingleton<ReelsCubit>(() => ReelsCubit());
  }

  if (!appLocator.isRegistered<ReelsPlaybackCubit>()) {
    appLocator.registerLazySingleton<ReelsPlaybackCubit>(
      () => ReelsPlaybackCubit(dataSource: appLocator<ReelRemoteDataSource>()),
    );
  }

  if (!appLocator.isRegistered<HomeCubit>()) {
    appLocator.registerFactory<HomeCubit>(() => HomeCubit());
  }

  if (!appLocator.isRegistered<MapsCubit>()) {
    appLocator.registerFactory<MapsCubit>(() => MapsCubit());
  }

  if (!appLocator.isRegistered<ChatCubit>()) {
    appLocator.registerFactory<ChatCubit>(
      () => ChatCubit(appLocator<ChatRemoteDataSource>()),
    );
  }

  if (!appLocator.isRegistered<DealerProfileCubit>()) {
    appLocator.registerFactory<DealerProfileCubit>(
      () => DealerProfileCubit(appLocator<DealerProfileRemoteDataSource>()),
    );
  }

  // ------------------- Dealer Setup (share Dio) -------------------
  final dio = appLocator<Dio>();

  if (!appLocator.isRegistered<RemouteDealerDataSource>()) {
    appLocator.registerLazySingleton<RemouteDealerDataSource>(
      () => RemouteDealerDataSource(dio: dio),
    );
  }

  if (!appLocator.isRegistered<remouteDataReelsSource>()) {
    appLocator.registerLazySingleton<remouteDataReelsSource>(
      () => remouteDataReelsSource(dio: dio),
    );
  }

  log('🎯 DI: All User + Dealer dependencies registered successfully!');
}
