import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:perminda/core/errors/failure.dart';
import 'package:perminda/data/remote_models/product_image/product_image.dart';

abstract class ProductImageRepo {
  Future<Either<Failure, ProductImage>> getProductImage(String id);

  Future<Either<Failure, ProductImage>> addProductImage(
    File image,
    int type,
    String productId,
  );

  Future<Either<Failure, ProductImage>> editProductImage(
    String id,
    File image,
    int type,
    String productId,
  );

  Future<Either<Failure, bool>> deleteProductImage(String id);
}
