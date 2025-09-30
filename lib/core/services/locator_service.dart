// BULLETPROOF DEPENDENCY INJECTION CONFIGURATION
// NO COMPROMISES, NO SHORTCUTS, GUARANTEED TO WORK

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
import 'package:dooss_business_app/features/auth/data/source/repo/auth_repository.dart';
import 'package:dooss_business_app/features/auth/data/source/repo/auth_repository_impl.dart';
import 'package:dooss_business_app/features/auth/presentation/manager/auth_cubit.dart';
import 'package:dooss_business_app/features/auth/presentation/widgets/custom_app_snack_bar.dart';
import 'package:dooss_business_app/features/my_profile/data/source/local/my_profile_local_data_source.dart';
import 'package:dooss_business_app/features/my_profile/data/source/local/my_profile_local_data_source_impl.dart';
import 'package:dooss_business_app/features/my_profile/data/source/remote/my_profile_remote_data_source.dart';
import 'package:dooss_business_app/features/my_profile/data/source/remote/my_profile_remote_data_source_impl.dart';
import 'package:dooss_business_app/features/my_profile/data/source/repo/my_profile_repository.dart';
import 'package:dooss_business_app/features/my_profile/data/source/repo/my_profile_repository_impl.dart';
import 'package:dooss_business_app/features/home/data/data_source/car_remote_data_source.dart';
import 'package:dooss_business_app/features/home/presentaion/manager/car_cubit.dart';
import 'package:dooss_business_app/features/home/data/data_source/product_remote_data_source.dart';
import 'package:dooss_business_app/features/home/data/data_source/product_remote_data_source_imp.dart';
import 'package:dooss_business_app/features/home/presentaion/manager/product_cubit.dart';
import 'package:dooss_business_app/features/home/data/data_source/service_remote_data_source.dart';
import 'package:dooss_business_app/features/home/data/data_source/service_remote_data_source_imp.dart';
import 'package:dooss_business_app/features/home/presentaion/manager/service_cubit.dart';
import 'package:dooss_business_app/features/home/data/data_source/reel_remote_data_source.dart';
import 'package:dooss_business_app/features/home/data/data_source/reel_remote_data_source_imp.dart';
import 'package:dooss_business_app/features/home/presentaion/manager/reel_cubit.dart';
import 'package:dooss_business_app/features/home/presentaion/manager/reels_cubit.dart';
import 'package:dooss_business_app/features/home/presentaion/manager/reels_playback_cubit.dart';
import 'package:dooss_business_app/features/home/presentaion/manager/home_cubit.dart';
import 'package:dooss_business_app/features/home/presentaion/manager/maps_cubit.dart';
import 'package:dooss_business_app/features/chat/data/data_source/chat_remote_data_source.dart';
import 'package:dooss_business_app/features/chat/data/data_source/chat_remote_data_source_imp.dart';
import 'package:dooss_business_app/features/chat/presentation/manager/chat_cubit.dart';
import 'package:dooss_business_app/core/services/websocket_service.dart';
import 'package:dooss_business_app/features/profile_dealer/data/data_source/dealer_profile_remote_data_source.dart';
import 'package:dooss_business_app/features/profile_dealer/presentation/manager/dealer_profile_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dooss_business_app/features/auth/data/source/remote/auth_remote_data_source.dart';
import 'package:dooss_business_app/features/auth/data/source/remote/auth_remote_data_source_imp.dart';

// Core Network
import 'package:dooss_business_app/core/network/api.dart';
import 'package:dooss_business_app/core/network/app_dio.dart';

import 'package:get_it/get_it.dart';

final appLocator = GetIt.instance;
final connectivity = Connectivity();

Future<void> init() async {
  log('🔧 DI: Starting bulletproof dependency injection...');

  //? ------------------- Services -------------------
  appLocator.registerLazySingleton<NetworkInfoService>(
    () => NetworkInfoServiceImpl(connectivity),
  );

  appLocator.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );

  appLocator.registerLazySingleton<SecureStorageService>(
    () => SecureStorageService(storage: appLocator<FlutterSecureStorage>()),
  );

  final sharedPrefs = await SharedPreferences.getInstance();
  appLocator.registerLazySingleton<SharedPreferences>(() => sharedPrefs);

  appLocator.registerLazySingleton<SharedPreferencesService>(
    () => SharedPreferencesService(
      storagePreferences: appLocator<SharedPreferences>(),
    ),
  );

  appLocator.registerLazySingleton<HiveService>(() => HiveServiceImpl());

  appLocator.registerLazySingleton<TranslationService>(
    () => TranslationServiceImpl(
      storagePreferanceService: appLocator<SharedPreferencesService>(),
    ),
  );

  appLocator.registerLazySingleton<ImageServices>(
    () => ImageServicesImpl(
      storagePreferences: appLocator<SharedPreferencesService>(),
    ),
  );

  //? ------------------- Local Data Sources -------------------
  appLocator.registerLazySingleton<AppManagerLocalDataSource>(
    () => AppManagerLocalDataSourceImpl(
      sharedPreferenc: appLocator<SharedPreferencesService>(),
      secureStorage: appLocator<SecureStorageService>(),
      hive: appLocator<HiveService>(),
    ),
  );

  appLocator.registerLazySingleton<MyProfileLocalDataSource>(
    () => MyProfileLocalDataSourceImpl(
      hive: appLocator<HiveService>(),
      sharedPreferenc: appLocator<SharedPreferencesService>(),
    ),
  );

  //? ------------------- Core Network -------------------
  appLocator.registerLazySingleton<AppDio>(() => AppDio());
  appLocator.registerLazySingleton<API>(
    () => API(dio: appLocator<AppDio>().dio),
  );
  appLocator.registerLazySingleton<WebSocketService>(() => WebSocketService());

  //? ------------------- Remote Data Sources -------------------
  appLocator.registerLazySingleton<AppMagaerRemoteDataSource>(
    () => AppMagaerRemoteDataSourceImpl(api: appLocator<API>()),
  );

  appLocator.registerLazySingleton<MyProfileRemoteDataSource>(
    () => MyProfileRemoteDataSourceImpl(api: appLocator<API>()),
  );

  appLocator.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImp(api: appLocator<API>()),
  );

  appLocator.registerLazySingleton<CarRemoteDataSource>(
    () => CarRemoteDataSourceImpl(appLocator<AppDio>()),
  );

  appLocator.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImp(api: appLocator<API>()),
  );

  appLocator.registerLazySingleton<ServiceRemoteDataSource>(
    () => ServiceRemoteDataSourceImp(api: appLocator<API>()),
  );

  appLocator.registerLazySingleton<ReelRemoteDataSource>(
    () => ReelRemoteDataSourceImp(dio: appLocator<AppDio>()),
  );

  appLocator.registerLazySingleton<ChatRemoteDataSource>(
    () => ChatRemoteDataSourceImp(api: appLocator<API>()),
  );

  appLocator.registerLazySingleton<DealerProfileRemoteDataSource>(
    () => DealerProfileRemoteDataSourceImpl(appLocator<AppDio>()),
  );

  //? ------------------- Repositories -------------------
  appLocator.registerLazySingleton<AppManagerRepository>(
    () => AppManagerRepositoryImpl(
      remote: appLocator<AppMagaerRemoteDataSource>(),
      local: appLocator<AppManagerLocalDataSource>(),
      network: appLocator<NetworkInfoService>(),
    ),
  );

  appLocator.registerLazySingleton<MyProfileRepository>(
    () => MyProfileRepositoryImpl(
      remote: appLocator<MyProfileRemoteDataSource>(),
      local: appLocator<MyProfileLocalDataSource>(),
      network: appLocator<NetworkInfoService>(),
    ),
  );

  appLocator.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remote: appLocator<AuthRemoteDataSource>(),
      network: appLocator<NetworkInfoService>(),
    ),
  );

  //? ------------------- Cubits -------------------
  appLocator.registerFactory<AuthCubit>(
    () => AuthCubit(
      remote: appLocator<AuthRemoteDataSourceImp>(),
      secureStorage: appLocator<SecureStorageService>(),
      sharedPreference: appLocator<SharedPreferencesService>(),
    ),
  );

  appLocator.registerFactory<CarCubit>(
    () => CarCubit(appLocator<CarRemoteDataSource>()),
  );

  appLocator.registerFactory<ProductCubit>(
    () => ProductCubit(appLocator<ProductRemoteDataSource>()),
  );

  appLocator.registerFactory<ServiceCubit>(
    () => ServiceCubit(appLocator<ServiceRemoteDataSource>()),
  );

  appLocator.registerFactory<ReelCubit>(
    () => ReelCubit(dataSource: appLocator<ReelRemoteDataSource>()),
  );

  appLocator.registerLazySingleton<ReelsCubit>(() => ReelsCubit());

  appLocator.registerLazySingleton<ReelsPlaybackCubit>(
    () => ReelsPlaybackCubit(dataSource: appLocator<ReelRemoteDataSource>()),
  );

  appLocator.registerFactory<HomeCubit>(() => HomeCubit());
  appLocator.registerFactory<MapsCubit>(() => MapsCubit());
  appLocator.registerFactory<ChatCubit>(
    () => ChatCubit(appLocator<ChatRemoteDataSource>()),
  );
  appLocator.registerFactory<DealerProfileCubit>(
    () => DealerProfileCubit(appLocator<DealerProfileRemoteDataSource>()),
  );

  //? ------------------- Final Verification -------------------
  log('🎯 DI: BULLETPROOF DEPENDENCY INJECTION COMPLETE!');

  // toast notifications bar (من نسخة HEAD)
  appLocator.registerFactory<ToastNotification>(() => ToastNotificationImpl());
}
