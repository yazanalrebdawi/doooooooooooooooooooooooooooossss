import 'package:dooss_business_app/features/my_profile/data/models/favorite_model.dart';

abstract class MyProfileLocalDataSource {
  //?----------------------------------------------------------------------
  //* Car Favorites
  List<FavoriteModel> getCarsListFavoritesLocal();
  Future<void> saveCarsListFavoritesLocal(List<FavoriteModel> favoritesList);

  //?----------------------------------------------------------------------
}
