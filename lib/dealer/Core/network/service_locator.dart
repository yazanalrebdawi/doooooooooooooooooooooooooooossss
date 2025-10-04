// import 'package:dio/dio.dart';
// import 'package:dooss_business_app/dealer/Core/network/dealers_App_dio.dart';
// import 'package:dooss_business_app/dealer/features/Home/data/remouteData/remoute_dealer_data_source.dart';
// import 'package:dooss_business_app/dealer/features/reels/data/remoute_data_reels_source.dart';
// import 'package:get_it/get_it.dart';

// final getIt = GetIt.instance;

// void setUpDealer() {
//   getIt.registerLazySingleton<DealersAppDio>(() => DealersAppDio());
//   getIt.registerLazySingleton<Dio>(() => getIt<DealersAppDio>().dio);

//   getIt.registerLazySingleton<remouteDataReelsSource>(
//     () => remouteDataReelsSource(dio: getIt<Dio>()),
//   );
//   getIt.registerLazySingleton<RemouteDealerDataSource>(
//       () => RemouteDealerDataSource(
//             dio: getIt<Dio>(),
//           ));
// }
