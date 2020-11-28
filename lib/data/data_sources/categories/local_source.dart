import 'package:moor_flutter/moor_flutter.dart';
import 'package:perminda/data/db/app_database/app_database.dart';
import 'package:perminda/data/db/models/category/category_dao.dart';
import 'package:perminda/data/db/relations/category/category_and_parent.dart';

abstract class CategoriesLocalSource {
  Future<int> insertCategory(CategoryTableCompanion category);

  Stream<List<CategoryAndParent>> watchCategories();

  Stream<CategoryAndParent> watchCategoryById(String categoryId);

  Future<CategoryAndParent> getCategoryById(String categoryId);
}

class CategoriesLocalSourceImpl extends CategoriesLocalSource {
  final CategoryDao categoryDao;

  CategoriesLocalSourceImpl({this.categoryDao});

  @override
  Future<CategoryAndParent> getCategoryById(String categoryId) {
    return categoryDao.getCategoryById(categoryId);
  }

  @override
  Future<int> insertCategory(CategoryTableCompanion category) {
    try {
      return categoryDao.insertCategory(category);
    } on InvalidDataException {
      rethrow;
    }
  }

  @override
  Stream<List<CategoryAndParent>> watchCategories() {
    return categoryDao.watchCategories();
  }

  @override
  Stream<CategoryAndParent> watchCategoryById(String categoryId) {
    return categoryDao.watchCategoryById(categoryId);
  }
}
