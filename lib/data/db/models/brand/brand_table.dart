import 'package:moor_flutter/moor_flutter.dart';

@DataClassName('BrandData')
class BrandTable extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get logo => text().nullable()();

  @override
  String get tableName => 'brand_table';

  @override
  Set<Column> get primaryKey => {id};
}
