import 'package:moor_flutter/moor_flutter.dart';

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
}
