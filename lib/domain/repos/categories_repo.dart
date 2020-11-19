import 'package:dartz/dartz.dart';
import 'package:perminda/core/errors/failure.dart';
import 'package:perminda/data/remote_models/categories/category.dart';

abstract class CategoriesRepo {
  Future<Either<Failure, List<Category>>> getCategories();
  Future<Either<Failure, Category>> getCategoryById(String id);
}
