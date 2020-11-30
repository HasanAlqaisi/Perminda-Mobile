import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:perminda/core/errors/failure.dart';
import 'package:perminda/data/remote_models/product_images/product_images.dart';
import 'package:perminda/data/remote_models/product_images/results.dart';

abstract class ProductImageRepo {
  Future<Either<Failure, ImagesResult>> getProductImage(String id);

  Future<Either<Failure, ProductImages>> getImagesOfProducts(String productId);

  Future<Either<Failure, ImagesResult>> addProductImage(
    File image,
    int type,
    String productId,
  );

  Future<Either<Failure, ImagesResult>> editProductImage(
    String id,
    File image,
    int type,
    String productId,
  );

  Future<Either<Failure, bool>> deleteProductImage(String id);
}
