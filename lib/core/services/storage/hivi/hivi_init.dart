import 'package:dooss_business_app/core/constants/cache_keys.dart';
import 'package:dooss_business_app/features/my_profile/data/models/favorite_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> initHive() async {
  //? ---------------- One Step  -----------------------------------------

  await Hive.initFlutter();

  //?---------------- Register Adapter As Arry true --------------------------

  Hive.registerAdapter(FavoriteModelAdapter());
  Hive.registerAdapter(TargetModelAdapter());

  //?---------------- Open Box  ---------------------------------------

  await Hive.openBox<FavoriteModel>(CacheKeys.favoritesList);

  //?------------------------------------------------------------------
}
