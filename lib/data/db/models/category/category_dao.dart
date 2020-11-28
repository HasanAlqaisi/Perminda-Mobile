import 'package:moor_flutter/moor_flutter.dart';
import 'package:perminda/data/db/app_database/app_database.dart';
import 'package:perminda/data/db/models/category/category_table.dart';
import 'package:perminda/data/db/relations/category/category_and_parent.dart';

part 'category_dao.g.dart';

@UseDao(tables: [CategoryTable])
class CategoryDao extends DatabaseAccessor<AppDatabase>
    with _$CategoryDaoMixin {
  CategoryDao(AppDatabase db) : super(db);

  Future<int> insertCategory(CategoryTableCompanion category) =>
      into(categoryTable).insert(category, mode: InsertMode.insertOrReplace);

  Stream<List<CategoryAndParent>> watchCategories() {
    final category = alias(categoryTable, 'c');
    final parentCategory = alias(categoryTable, 'p');

    /// one-to-one [CategoryAndParent]
    return select(category)
        .join([
          leftOuterJoin(
              parentCategory, parentCategory.id.equalsExp(category.parent)),
        ])
        .watch()
        .map((rows) => rows
            .map((row) => CategoryAndParent(
                category: row.readTable(category),
                parent: row.readTable(parentCategory)))
            .toList());
  }

  Stream<CategoryAndParent> watchCategoryById(String categoryId) {
    final category = alias(categoryTable, 'c');
    final parentCategory = alias(categoryTable, 'p');

    return (select(category)..where((tbl) => category.id.equals(categoryId)))
        .join([
          leftOuterJoin(
              parentCategory, parentCategory.id.equalsExp(category.parent)),
        ])
        .watchSingle()
        .map((row) => CategoryAndParent(
            category: row.readTable(category),
            parent: row.readTable(parentCategory)));
  }

  Future<CategoryAndParent> getCategoryById(String categoryId) async {
    final category = alias(categoryTable, 'c');
    final parentCategory = alias(categoryTable, 'p');

    final result = await (select(category)
          ..where((tbl) => category.id.equals(categoryId)))
        .join([
      leftOuterJoin(
          parentCategory, parentCategory.id.equalsExp(category.parent)),
    ]).getSingle();

    return CategoryAndParent(
      category: result.readTable(category),
      parent: result.readTable(parentCategory),
    );
  }
}
