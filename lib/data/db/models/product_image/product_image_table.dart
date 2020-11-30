import 'package:moor_flutter/moor_flutter.dart';
import 'package:perminda/data/db/app_database/app_database.dart';
import 'package:perminda/data/remote_models/product_images/results.dart';

@DataClassName('ProductImageData')
class ProductImageTable extends Table {
  TextColumn get id => text()();
  TextColumn get image => text()();
  TextColumn get product =>
      text().customConstraint('REFERENCES product_table(id)')();
  IntColumn get type => integer()();

  @override
  String get tableName => 'product_image_table';

  @override
  Set<Column> get primaryKey => {id};

  static List<ProductImageTableCompanion> fromImagesResult(
      List<ImagesResult> imagesResult) {
    return imagesResult
        .map(
          (result) => ProductImageTableCompanion(
            id: Value(result.id),
            image: Value(result.imageUrl),
            product: Value(result.productId),
            type: Value(result.type),
          ),
        )
        .toList();
  }
}
