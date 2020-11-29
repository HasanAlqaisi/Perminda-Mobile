import 'package:moor_flutter/moor_flutter.dart';

@DataClassName('ProductImageData')
class ProductImageTable extends Table {
  TextColumn get id => text()();
  TextColumn get image => text()();
  TextColumn get product => text().customConstraint('REFERENCES product_table(id)')();
  IntColumn get type => integer()();

  @override
  String get tableName => 'product_image_table';

  @override
  Set<Column> get primaryKey => {id};

  //   static List<ProductImageTableCompanion> fromProductImagesResult(
  //     List<ProductImagesResult> packagesResult) {
  //   return packagesResult
  //       .map(
  //         (result) => PackageTableCompanion(
  //           id: Value(result.id),
  //           title: Value(result.title),
  //           image: Value(result.image),
  //           active: Value(result.active),
  //           dateCreated: Value(DateTime.tryParse(result.dateCreated)),
  //         ),
  //       )
  //       .toList();
  // }
}
