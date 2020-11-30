import 'package:dartz/dartz.dart';
import 'package:perminda/core/errors/failure.dart';
import 'package:perminda/data/db/app_database/app_database.dart';
import 'package:perminda/data/remote_models/products/results.dart';

abstract class ProductsRepo {
  Future<Either<Failure, List<ProductsResult>>> getProducts(
    String shopId,
    String categoryId,
    String brandId,
  );

  Stream<List<ProductData>> watchProductsByCategory(String categoryId);
}
