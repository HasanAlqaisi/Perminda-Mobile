import 'package:moor_flutter/moor_flutter.dart';
import 'package:perminda/data/db/app_database/app_database.dart';
import 'package:perminda/data/db/models/package/package_table.dart';

part 'package_dao.g.dart';

@UseDao(tables: [PackageTable])
class PackageDao extends DatabaseAccessor<AppDatabase> with _$PackageDaoMixin {
  PackageDao(AppDatabase db) : super(db);

  Future<void> insertPackages(List<PackageTableCompanion> packages) async {
    await batch((batch) {
      batch.insertAllOnConflictUpdate(packageTable, packages);
    });
  }

  Future<int> deletePackages() => delete(packageTable).go();

  Future<int> deletePackageById(String packageId) =>
      (delete(packageTable)..where((tbl) => tbl.id.equals(packageId))).go();
}
