import 'package:flutter_test/flutter_test.dart';
import 'package:moor_ffi/moor_ffi.dart';
import 'package:moor_flutter/moor_flutter.dart';
import 'package:perminda/data/db/app_database/app_database.dart';

void main() {
  AppDatabase db;
  final categoryOne = CategoryTableCompanion(
    id: Value('1'),
    parent: Value(null),
    name: Value('Electronics'),
  );
  final categoryTwo = CategoryTableCompanion(
    id: Value('2'),
    parent: Value('1'),
    name: Value('mobile'),
  );
  final categoryThree = CategoryTableCompanion(
    id: Value('3'),
    parent: Value('2'),
    name: Value('Samsung'),
  );
  final categoryFour = CategoryTableCompanion(
    id: Value('4'),
    parent: Value(null),
    name: Value('categoryNoParent'),
  );

  setUp(() {
    db = AppDatabase(VmDatabase.memory());
  });

  tearDown(() {
    db.close();
  });

  test(
      'should return list of [CategoryAndParent] in a correct way when watching',
      () async {
    await db.categoryDao.insertCategory(categoryOne);
    await db.categoryDao.insertCategory(categoryTwo);
    await db.categoryDao.insertCategory(categoryThree);
    await db.categoryDao.insertCategory(categoryFour);

    final result = db.categoryDao.watchCategories();

    final categoryAndData = (await result.first)[2];
    print('Category: ' + categoryAndData.category.toString());
    print('parent: ' + categoryAndData.parent.toString());
  });

  test('should return [CategoryAndParent] in a correct way when get it',
      () async {
    await db.categoryDao.insertCategory(categoryOne);
    await db.categoryDao.insertCategory(categoryTwo);
    await db.categoryDao.insertCategory(categoryThree);
    await db.categoryDao.insertCategory(categoryFour);

    final result = db.categoryDao.getCategoryById('1');

    final categoryAndData = (await result);
    print('Category: ' + categoryAndData.category.toString());
    print('parent: ' + categoryAndData.parent.toString());
  });

  test('should return [CategoryAndParent] in a correct way when watching it',
      () async {
    await db.categoryDao.insertCategory(categoryOne);
    await db.categoryDao.insertCategory(categoryTwo);
    await db.categoryDao.insertCategory(categoryThree);
    await db.categoryDao.insertCategory(categoryFour);

    final result = db.categoryDao.watchCategoryById('1');

    final categoryAndData = (await result.first);
    print('Category: ' + categoryAndData.category.toString());
    print('parent: ' + categoryAndData.parent.toString());
  });
}
