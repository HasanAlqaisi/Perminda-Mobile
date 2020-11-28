import 'package:moor_flutter/moor_flutter.dart';
import 'package:perminda/data/db/app_database/app_database.dart';
import 'package:perminda/data/db/models/package/package_table.dart';

part 'package_dao.g.dart';

@UseDao(tables: [PackageTable])
class PackageDao extends DatabaseAccessor<AppDatabase> with _$PackageDaoMixin {
  PackageDao(AppDatabase db) : super(db);

  Future<int> insertPackage(PackageTableCompanion package) =>
      into(packageTable).insert(package, mode: InsertMode.insertOrReplace);
}
