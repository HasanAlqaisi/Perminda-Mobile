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
}
