import 'package:moor_flutter/moor_flutter.dart';
import 'package:perminda/data/db/app_database/app_database.dart';
import 'package:perminda/data/remote_models/packages/results.dart';

@DataClassName('PackageItemData')
class PackageItemTable extends Table {
  TextColumn get id => text()();
  TextColumn get package =>
      text().customConstraint('REFERENCES package_table(id)')();
  TextColumn get product =>
      text().customConstraint('REFERENCES product_table(id)')();

  @override
  String get tableName => 'package_item_table';

  @override
  Set<Column> get primaryKey => {id, package, product};

  static PackageItemTableCompanion fromPackagesResult(
      PackagesResult packagesResult, String product) {
    return PackageItemTableCompanion(
      id: Value(packagesResult.id),
      package: Value(packagesResult.id),
      product: Value(product),
    );
  }
}
