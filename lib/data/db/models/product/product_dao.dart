import 'package:moor_flutter/moor_flutter.dart';
import 'package:perminda/data/db/app_database/app_database.dart';
import 'package:perminda/data/db/models/brand/brand_table.dart';
import 'package:perminda/data/db/models/category/category_table.dart';
import 'package:perminda/data/db/models/product/product_table.dart';
import 'package:perminda/data/db/models/shop/shop_table.dart';
import 'package:perminda/data/db/relations/product/product_and_category_brand.dart';

part 'product_dao.g.dart';

@UseDao(tables: [ProductTable, ShopTable, CategoryTable, BrandTable])
class ProductDao extends DatabaseAccessor<AppDatabase> with _$ProductDaoMixin {
  ProductDao(AppDatabase db) : super(db);

  Future<void> insertProducts(List<ProductTableCompanion> products) async {
    batch((batch) {
      batch.insertAll(
        productTable,
        products,
        mode: InsertMode.insertOrReplace,
      );
    });
  }

  Stream<List<ProductAndCategoryAndBrandAndShop>> watchProductsByShopId(
      String shopId) {
    ///Every product has one shop, one category, one brand.. one-to-one
    return (select(productTable)
          ..where((productTable) => productTable.shop.equals(shopId)))
        .join([
          innerJoin(shopTable, shopTable.id.equals(shopId)),
          innerJoin(
              categoryTable, categoryTable.id.equalsExp(productTable.category)),
          leftOuterJoin(
              brandTable, brandTable.id.equalsExp(productTable.brand)),
        ])
        .watch()
        .map((rows) => rows
            .map((row) => ProductAndCategoryAndBrandAndShop(
                  product: row.readTable(productTable),
                  shop: row.readTable(shopTable),
                  category: row.readTable(categoryTable),
                  brand: row.readTable(brandTable),
                ))
            .toList());
  }

  Stream<List<ProductData>> watchProductsByCategoryId(String categoryId) {
    return (select(productTable)
          ..where((productTable) => productTable.category.equals(categoryId)))
        .watch();
  }

  Stream<List<ProductAndCategoryAndBrandAndShop>>
      watchProductsWithInfoByCategoryId(String categoryId) {
    ///Every product has one shop, one category, one brand.. one-to-one
    return (select(productTable)
          ..where((productTable) => productTable.category.equals(categoryId)))
        .join([
          innerJoin(categoryTable, categoryTable.id.equals(categoryId)),
          innerJoin(shopTable, shopTable.id.equalsExp(productTable.shop)),
          leftOuterJoin(
              brandTable, brandTable.id.equalsExp(productTable.brand)),
        ])
        .watch()
        .map((rows) => rows
            .map((row) => ProductAndCategoryAndBrandAndShop(
                  product: row.readTable(productTable),
                  shop: row.readTable(shopTable),
                  category: row.readTable(categoryTable),
                  brand: row.readTable(brandTable),
                ))
            .toList());
  }

  Stream<List<ProductAndCategoryAndBrandAndShop>> watchProductsByBrandId(
      String brandId) {
    ///Every product has one shop, one category, one brand.. one-to-one
    return (select(productTable)
          ..where((productTable) => productTable.brand.equals(brandId)))
        .join([
          innerJoin(brandTable, brandTable.id.equals(brandId)),
          innerJoin(shopTable, shopTable.id.equalsExp(productTable.shop)),
          innerJoin(
              categoryTable, categoryTable.id.equalsExp(productTable.category)),
        ])
        .watch()
        .map((rows) => rows
            .map((row) => ProductAndCategoryAndBrandAndShop(
                  product: row.readTable(productTable),
                  shop: row.readTable(shopTable),
                  category: row.readTable(categoryTable),
                  brand: row.readTable(brandTable),
                ))
            .toList());
  }

  Future<int> deleteProducts() => delete(productTable).go();

  Future<int> deleteProductById(String productId) =>
      (delete(productTable)..where((tbl) => tbl.id.equals(productId))).go();

  Future<int> deleteProductByCategoryId(String categoryId) =>
      (delete(productTable)..where((tbl) => tbl.category.equals(categoryId)))
          .go();
}
