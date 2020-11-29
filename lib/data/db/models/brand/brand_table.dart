import 'package:moor_flutter/moor_flutter.dart';
import 'package:perminda/data/db/app_database/app_database.dart';
import 'package:perminda/data/remote_models/brands/results.dart';

@DataClassName('BrandData')
class BrandTable extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get logo => text().nullable()();

  @override
  String get tableName => 'brand_table';

  @override
  Set<Column> get primaryKey => {id};

  static List<BrandTableCompanion> fromBrandsResult(
      List<BrandsResult> brandsResult) {
    return brandsResult
        .map(
          (result) => BrandTableCompanion(
            id: Value(result.id),
            name: Value(result.name),
            logo: Value(result.imageUrl),
          ),
        )
        .toList();
  }
}
