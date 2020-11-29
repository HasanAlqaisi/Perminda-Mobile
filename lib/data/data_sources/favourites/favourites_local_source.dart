import 'package:moor_flutter/moor_flutter.dart';
import 'package:perminda/data/db/app_database/app_database.dart';
import 'package:perminda/data/db/models/favourite_item/favourite_item_dao.dart';
import 'package:perminda/data/db/relations/favourite_item/favourite_item_and_product.dart';

abstract class FavouritesLocalSource {
  Future<void> insertFavouriteItems(
      List<FavouriteItemTableCompanion> favourites);

  Stream<Future<List<Future<FavouriteItemAndProduct>>>> watchFavouriteItems(
      String userId);

  Future<int> deleteFavouriteItemById(String favouriteItemId);
}

class FavouritesLocalSourceImpl extends FavouritesLocalSource {
  final FavouriteItemDao favouriteItemDao;

  FavouritesLocalSourceImpl({this.favouriteItemDao});

  @override
  Future<void> insertFavouriteItems(
      List<FavouriteItemTableCompanion> favourites) {
    try {
      return favouriteItemDao.insertFavouriteItems(favourites);
    } on InvalidDataException {
      rethrow;
    }
  }

  @override
  Stream<Future<List<Future<FavouriteItemAndProduct>>>> watchFavouriteItems(
      String userId) {
    return favouriteItemDao.watchFavouriteItems(userId);
  }

  @override
  Future<int> deleteFavouriteItemById(String favouriteItemId) {
    return favouriteItemDao.deleteFavouriteItemById(favouriteItemId);
  }
}
