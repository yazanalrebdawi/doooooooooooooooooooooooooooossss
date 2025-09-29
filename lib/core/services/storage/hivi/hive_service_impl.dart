import 'package:dooss_business_app/core/constants/cache_keys.dart';
import 'package:dooss_business_app/core/services/storage/hivi/hive_service.dart';
import 'package:dooss_business_app/features/my_profile/data/models/favorite_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveServiceImpl implements HiveService {
  //! Clear All
  @override
  Future<void> clearAllInCache() async {
    await Hive.deleteFromDisk();
  }

  //?-------  Box   ---------------------------------------------------------------

  //* Car Favorites List
  Box<FavoriteModel> get _carBox =>
      Hive.box<FavoriteModel>(CacheKeys.favoritesList);

  //?-----   Car List Favorites  -------------------------------------------------------------
  @override
  List<FavoriteModel> getListFavoritesInCache() {
    return _carBox.values.toList();
  }

  @override
  Future<void> saveListFavoriteInCache(List<FavoriteModel> favorites) async {
    await _carBox.clear();
    await _carBox.addAll(favorites);
  }

  //?-------------------------------------------------------------------------------------
}
