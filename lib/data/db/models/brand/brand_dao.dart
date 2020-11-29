import 'package:moor_flutter/moor_flutter.dart';
import 'package:perminda/data/db/app_database/app_database.dart';
import 'package:perminda/data/db/models/brand/brand_table.dart';

part 'brand_dao.g.dart';

@UseDao(tables: [BrandTable])
class BrandDao extends DatabaseAccessor<AppDatabase> with _$BrandDaoMixin {
  BrandDao(AppDatabase db) : super(db);

  Future<void> insertBrands(List<BrandTableCompanion> brands) async {
    await batch((batch) {
      batch.insertAllOnConflictUpdate(brandTable, brands);
    });
  }

  Future<List<BrandData>> getBrands() => select(brandTable).get();

  Stream<List<BrandData>> watchBrands() => select(brandTable).watch();

  Future<BrandData> getBrandById(String brandId) =>
      (select(brandTable)..where((tbl) => brandTable.id.equals(brandId)))
          .getSingle();

  Future<int> deleteBrands() => delete(brandTable).go();

  Future<int> deleteBrandById(String brandId) =>
      (delete(brandTable)..where((tbl) => tbl.id.equals(brandId))).go();
}
