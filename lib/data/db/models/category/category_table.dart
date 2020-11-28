import 'package:moor_flutter/moor_flutter.dart';

@DataClassName('CategoryData')
class CategoryTable extends Table {
  TextColumn get id => text()();
  TextColumn get parent => text()
      .nullable()
      .customConstraint('NULL REFERENCES category_table(id)')();
  TextColumn get name => text()();

  @override
  String get tableName => 'category_table';

  @override
  Set<Column> get primaryKey => {id};
}
