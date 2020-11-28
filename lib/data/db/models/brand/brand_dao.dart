import 'package:moor_flutter/moor_flutter.dart';
import 'package:perminda/data/db/app_database/app_database.dart';
import 'package:perminda/data/db/models/brand/brand_table.dart';

part 'brand_dao.g.dart';

@UseDao(tables: [BrandTable])
class BrandDao extends DatabaseAccessor<AppDatabase> with _$BrandDaoMixin {
  BrandDao(AppDatabase db) : super(db);

  Future<int> insertBrand(BrandTableCompanion brand) =>
      into(brandTable).insert(brand, mode: InsertMode.insertOrReplace);

  Future<List<BrandData>> getBrands() => select(brandTable).get();

  Stream<List<BrandData>> watchBrands() => select(brandTable).watch();

  Future<BrandData> getBrandById(String brandId) =>
      (select(brandTable)..where((tbl) => brandTable.id.equals(brandId)))
          .getSingle();
}
