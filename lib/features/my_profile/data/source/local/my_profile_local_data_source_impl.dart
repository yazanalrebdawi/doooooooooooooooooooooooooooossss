import 'package:dooss_business_app/core/services/storage/hivi/hive_service.dart';
import 'package:dooss_business_app/core/services/storage/shared_preferances/shared_preferences_service.dart';
import 'package:dooss_business_app/features/my_profile/data/models/favorite_model.dart';
import 'package:dooss_business_app/features/my_profile/data/source/local/my_profile_local_data_source.dart';

class MyProfileLocalDataSourceImpl implements MyProfileLocalDataSource {
  final HiveService hive;
  final SharedPreferencesService sharedPreferenc;

  MyProfileLocalDataSourceImpl({
    required this.hive,
    required this.sharedPreferenc,
  });

  //?----------- Favorites --------------------------------------

  @override
  List<FavoriteModel> getCarsListFavoritesLocal() {
    return hive.getListFavoritesInCache();
  }

  @override
  Future<void> saveCarsListFavoritesLocal(
    List<FavoriteModel> favoritesList,
  ) async {
    await hive.saveListFavoriteInCache(favoritesList);
  }

  //?------------------------------------------------------------------
}
