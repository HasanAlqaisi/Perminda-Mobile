import 'package:moor_flutter/moor_flutter.dart';
import 'package:perminda/data/db/app_database/app_database.dart';
import 'package:perminda/data/db/models/product_image/product_image_table.dart';

part 'product_image_dao.g.dart';

@UseDao(tables: [ProductImageTable])
class ProductImageDao extends DatabaseAccessor<AppDatabase>
    with _$ProductImageDaoMixin {
  ProductImageDao(AppDatabase db) : super(db);

  Future<void> insertProductImages(
      List<ProductImageTableCompanion> productImages) async {
    await batch((batch) {
      batch.insertAll(
        productImageTable,
        productImages,
        mode: InsertMode.insertOrReplace,
      );
    });
  }

  Future<List<ProductImageData>> getProductImages(String productId) {
    return (select(productImageTable)
          ..where((productImageTable) =>
              productImageTable.product.equals(productId)))
        .get();
  }

  Future<int> deleteProductImages(String productId) =>
      (delete(productImageTable)..where((tbl) => tbl.product.equals(productId)))
          .go();

  Future<int> deleteProductImageById(String productImageId) =>
      (delete(productImageTable)..where((tbl) => tbl.id.equals(productImageId)))
          .go();
}
