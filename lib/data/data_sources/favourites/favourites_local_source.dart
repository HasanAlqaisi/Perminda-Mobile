import 'package:moor_flutter/moor_flutter.dart';
import 'package:perminda/data/db/app_database/app_database.dart';
import 'package:perminda/data/db/models/favourite_item/favourite_item_dao.dart';
import 'package:perminda/data/db/relations/favourite_item/favourite_item_and_product.dart';

abstract class FavouritesLocalSource {
  Future<int> insertFavouriteItem(FavouriteItemTableCompanion favourite);

  Stream<Future<List<Future<FavouriteItemAndProduct>>>> watchFavouriteItems(
      String userId);
}

class FavouritesLocalSourceImpl extends FavouritesLocalSource {
  final FavouriteItemDao favouriteItemDao;

  FavouritesLocalSourceImpl({this.favouriteItemDao});

  @override
  Future<int> insertFavouriteItem(FavouriteItemTableCompanion favourite) {
    try {
      return favouriteItemDao.insertFavouriteItem(favourite);
    } on InvalidDataException {
      rethrow;
    }
  }

  @override
  Stream<Future<List<Future<FavouriteItemAndProduct>>>> watchFavouriteItems(
      String userId) {
    return favouriteItemDao.watchFavouriteItems(userId);
  }
}
