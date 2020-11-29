import 'package:moor_flutter/moor_flutter.dart';
import 'package:perminda/data/db/app_database/app_database.dart';
import 'package:perminda/data/remote_models/categories/results.dart';

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

  static List<CategoryTableCompanion> fromCategoriesResult(
      List<CategoriesResult> categoriesResult) {
    return categoriesResult
        .map(
          (result) => CategoryTableCompanion(
            id: Value(result.id),
            parent: Value(result.parentId),
            name: Value(result.name),
          ),
        )
        .toList();
  }
}
