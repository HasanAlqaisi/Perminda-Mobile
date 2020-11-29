import 'package:moor_flutter/moor_flutter.dart';
import 'package:perminda/data/db/app_database/app_database.dart';
import 'package:perminda/data/remote_models/favourites/results.dart';

@DataClassName('FavouriteItemData')
class FavouriteItemTable extends Table {
  TextColumn get id => text()();
  TextColumn get user => text().customConstraint('REFERENCES user_table(id)')();
  TextColumn get product =>
      text().customConstraint('REFERENCES product_table(id)')();

  @override
  String get tableName => 'favourite_item_table';

  @override
  Set<Column> get primaryKey => {id, user, product};

  static List<FavouriteItemTableCompanion> fromFavouritesResult(
      List<FavouritesResult> favouritesResult) {
    return favouritesResult
        .map(
          (result) => FavouriteItemTableCompanion(
            id: Value(result.id),
            user: Value(result.userId),
            product: Value(result.productId),
          ),
        )
        .toList();
  }
}
