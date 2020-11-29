import 'package:moor_flutter/moor_flutter.dart';
import 'package:perminda/data/db/app_database/app_database.dart';
import 'package:perminda/data/db/models/category/category_dao.dart';
import 'package:perminda/data/db/relations/category/category_and_parent.dart';

abstract class CategoriesLocalSource {
  Future<void> insertCategories(List<CategoryTableCompanion> categories);

  Stream<List<CategoryAndParent>> watchCategories();

  Stream<CategoryAndParent> watchCategoryById(String categoryId);

  Future<CategoryAndParent> getCategoryById(String categoryId);

  Future<int> deleteCategoryById(String categoryId);
}

class CategoriesLocalSourceImpl extends CategoriesLocalSource {
  final CategoryDao categoryDao;

  CategoriesLocalSourceImpl({this.categoryDao});

  @override
  Future<CategoryAndParent> getCategoryById(String categoryId) {
    return categoryDao.getCategoryById(categoryId);
  }

  @override
  Future<void> insertCategories(List<CategoryTableCompanion> categories) {
    try {
      return categoryDao.insertCategories(categories);
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

  @override
  Future<int> deleteCategoryById(String categoryId) {
    return categoryDao.deleteCategoryById(categoryId);
  }
}
