import 'package:moor_flutter/moor_flutter.dart';
import 'package:perminda/data/db/app_database/app_database.dart';
import 'package:perminda/data/db/models/favourite_item/favourite_item_table.dart';
import 'package:perminda/data/db/models/product/product_table.dart';
import 'package:perminda/data/db/relations/favourite_item/favourite_item_and_product.dart';

part 'favourite_item_dao.g.dart';

@UseDao(tables: [FavouriteItemTable, ProductTable])
class FavouriteItemDao extends DatabaseAccessor<AppDatabase>
    with _$FavouriteItemDaoMixin {
  FavouriteItemDao(AppDatabase db) : super(db);

  Future<void> insertFavouriteItems(
      List<FavouriteItemTableCompanion> favourites) async {
    await batch((batch) {
      batch.insertAllOnConflictUpdate(favouriteItemTable, favourites);
    });
  }

  Stream<Future<List<Future<FavouriteItemAndProduct>>>> watchFavouriteItems(
      String userId) {
    return (select(favouriteItemTable)
          ..where(
              (favouriteItemTable) => favouriteItemTable.user.equals(userId)))
        .join([
          innerJoin(productTable,
              productTable.id.equalsExp(favouriteItemTable.product)),
        ])
        .watch()
        .map((rows) async => rows.map((row) async {
              final productRow = row.readTable(productTable);
              return FavouriteItemAndProduct(
                favouriteItem: row.readTable(favouriteItemTable),
                product: productRow,
                category:
                    await db.categoryDao.getCategoryById(productRow.category),
                brand: await db.brandDao.getBrandById(productRow.brand),
                shop: await db.shopDao.getShopById(productRow.shop),
              );
            }).toList());
  }

  Future<int> deleteFavouriteItems(String userId) =>
      (delete(favouriteItemTable)..where((tbl) => tbl.user.equals(userId)))
          .go();

  Future<int> deleteFavouriteItemById(String favouriteItemId) =>
      (delete(favouriteItemTable)
            ..where((tbl) => tbl.id.equals(favouriteItemId)))
          .go();
}
