import 'package:dio/dio.dart';
import 'package:dooss_business_app/dealer/Core/network/App_dio.dart';
import 'package:dooss_business_app/dealer/features/Home/data/remouteData/remoute_dealer_data_source.dart';
import 'package:dooss_business_app/dealer/features/reels/data/remoute_data_reels_source.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setUp() {
  getIt.registerLazySingleton<Dio>(() => AppDio(Dio()).dio);
  getIt.registerLazySingleton<AppDio>(() => AppDio(getIt<Dio>()));
  getIt.registerLazySingleton<remouteDataReelsSource>(
    () => remouteDataReelsSource(dio: getIt<Dio>()),
  );
  getIt.registerLazySingleton<RemouteDealerDataSource>(
    () => RemouteDealerDataSource(),
  );
}
