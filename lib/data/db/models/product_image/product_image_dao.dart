import 'package:moor_flutter/moor_flutter.dart';
import 'package:perminda/data/db/app_database/app_database.dart';
import 'package:perminda/data/db/models/brand/brand_table.dart';
import 'package:perminda/data/db/models/category/category_table.dart';
import 'package:perminda/data/db/models/product_image/product_image_table.dart';
import 'package:perminda/data/db/models/shop/shop_table.dart';

part 'product_image_dao.g.dart';

@UseDao(tables: [ProductImageTable])
class ProductImageDao extends DatabaseAccessor<AppDatabase>
    with _$ProductImageDaoMixin {
  ProductImageDao(AppDatabase db) : super(db);

  Future<int> insertProductImage(ProductImageTableCompanion productImage) =>
      into(productImageTable)
          .insert(productImage, mode: InsertMode.insertOrReplace);

  Future<List<ProductImageData>> getProductImages(String productId) {
    return (select(productImageTable)
          ..where((productImageTable) =>
              productImageTable.product.equals(productId)))
        .get();
  }
}
