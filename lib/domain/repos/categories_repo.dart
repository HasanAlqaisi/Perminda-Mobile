import 'package:dartz/dartz.dart';
import 'package:perminda/core/errors/failure.dart';
import 'package:perminda/data/remote_models/categories/categories.dart';
import 'package:perminda/data/remote_models/categories/results.dart';

abstract class CategoriesRepo {
  Future<Either<Failure, Categories>> getCategories();
  Future<Either<Failure, CategoriesResult>> getCategoryById(String id);
}
