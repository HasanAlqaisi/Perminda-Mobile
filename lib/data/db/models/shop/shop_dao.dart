import 'package:moor_flutter/moor_flutter.dart';
import 'package:perminda/data/db/app_database/app_database.dart';
import 'package:perminda/data/db/models/shop/shop_table.dart';

part 'shop_dao.g.dart';

@UseDao(tables: [ShopTable])
class ShopDao extends DatabaseAccessor<AppDatabase> with _$ShopDaoMixin {
  ShopDao(AppDatabase db) : super(db);

  Future<int> insertShop(ShopTableCompanion shop) =>
      into(shopTable).insert(shop, mode: InsertMode.insertOrReplace);

  Future<ShopData> getShopById(String shopId) =>
      (select(shopTable)..where((shopTable) => shopTable.id.equals(shopId)))
          .getSingle();

  Stream<ShopData> watchShopById(String shopId) =>
      (select(shopTable)..where((shopTable) => shopTable.id.equals(shopId)))
          .watchSingle();

  /// There's a relation between user and shop [one-to-many]
  /// But we don't need a specific shop or shops for a user
  /// It really didn't depend on the user info
  /// We only need one shop by its id, or all shops
  /// because this is user side app, not the seller
  Stream<List<ShopData>> watchShops() => select(shopTable).watch();
}
