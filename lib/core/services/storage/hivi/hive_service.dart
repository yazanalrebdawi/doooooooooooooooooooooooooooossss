import 'package:dooss_business_app/features/my_profile/data/models/favorite_model.dart';

abstract class HiveService {
  //! Clear LogOut
  Future<void> clearAllInCache();

  //?---- Box --------------------------------------------

  //* Favoriets
  Future<void> saveListFavoriteInCache(List<FavoriteModel> favoritesList);
  List<FavoriteModel> getListFavoritesInCache();

  //?------------------------------------------------------------------
}
