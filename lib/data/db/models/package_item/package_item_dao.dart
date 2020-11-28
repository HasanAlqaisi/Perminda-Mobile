import 'package:moor_flutter/moor_flutter.dart';
import 'package:perminda/data/db/app_database/app_database.dart';
import 'package:perminda/data/db/models/package/package_table.dart';
import 'package:perminda/data/db/models/package_item/package_item_table.dart';
import 'package:perminda/data/db/models/product/product_table.dart';
import 'package:perminda/data/db/relations/package_item/package_with_products.dart';
import 'package:perminda/data/db/relations/order_item/product_info.dart';
import 'package:rxdart/rxdart.dart';

part 'package_item_dao.g.dart';

@UseDao(tables: [PackageItemTable, ProductTable, PackageTable])
class PackageItemDao extends DatabaseAccessor<AppDatabase>
    with _$PackageItemDaoMixin {
  PackageItemDao(AppDatabase db) : super(db);

  Future<int> insertPackageItemDao(PackageItemTableCompanion package) =>
      into(packageItemTable).insert(package, mode: InsertMode.insertOrReplace);

  Stream<Future<List<PackageWithProducts>>> watchPackages() {
    final packageStream = select(packageTable).watch();

    return packageStream.switchMap((packages) {
      final idToPackage = {for (var package in packages) package.id: package};
      final ids = idToPackage.keys;

      final entryQuery = select(packageItemTable).join(
        [
          innerJoin(productTable,
              productTable.id.equalsExp(packageItemTable.product)),
        ],
      )..where(packageItemTable.package.isIn(ids));

      return entryQuery.watch().map((rows) async {
        final idToProducts = <String, List<ProductInfo>>{};

        for (var row in rows) {
          final productRow = row.readTable(productTable);

          final product = productRow;
          final id = row.readTable(packageItemTable).package;
          final category =
              await db.categoryDao.getCategoryById(productRow.category);
          final brand = await db.brandDao.getBrandById(productRow.brand);
          final shop = await db.shopDao.getShopById(productRow.shop);

          final productInfo = ProductInfo(
            product: product,
            brand: brand,
            shop: shop,
            category: category,
          );

          idToProducts.putIfAbsent(id, () => []).add(productInfo);
        }

        return [
          for (var id in ids)
            PackageWithProducts(
                package: idToPackage[id], products: idToProducts[id] ?? []),
        ];
      });
    });
  }
}
