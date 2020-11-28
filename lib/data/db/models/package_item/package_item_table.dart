import 'package:moor_flutter/moor_flutter.dart';

@DataClassName('PackageItemData')
class PackageItemTable extends Table {
  TextColumn get package =>
      text().customConstraint('REFERENCES package_table(id)')();
  TextColumn get product =>
      text().customConstraint('REFERENCES product_table(id)')();

  @override
  String get tableName => 'package_item_table';

  @override
  Set<Column> get primaryKey => {package, product};
}
