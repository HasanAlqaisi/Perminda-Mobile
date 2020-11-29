import 'package:moor_flutter/moor_flutter.dart';
import 'package:perminda/data/db/app_database/app_database.dart';
import 'package:perminda/data/remote_models/packages/results.dart';

@DataClassName('PackageData')
class PackageTable extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get image => text()();
  BoolColumn get active => boolean().withDefault(Constant(false))();
  DateTimeColumn get dateCreated => dateTime()();

  @override
  String get tableName => 'package_table';

  @override
  Set<Column> get primaryKey => {id};

  static List<PackageTableCompanion> fromPackagesResult(
      List<PackagesResult> packagesResult) {
    return packagesResult
        .map(
          (result) => PackageTableCompanion(
            id: Value(result.id),
            title: Value(result.title),
            image: Value(result.image),
            active: Value(result.active),
            dateCreated: Value(DateTime.tryParse(result.dateCreated)),
          ),
        )
        .toList();
  }
}
