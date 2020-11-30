import 'dart:convert';

import 'package:perminda/core/api_helpers/api.dart';
import 'package:perminda/core/errors/exception.dart';
import 'package:perminda/core/network/network_info.dart';
import 'package:perminda/data/data_sources/product_image/local_source.dart';
import 'package:perminda/data/data_sources/product_image/remote_source.dart';
import 'package:perminda/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:perminda/data/db/models/product_image/product_image_table.dart';
import 'package:perminda/data/remote_models/product_images/product_images.dart';
import 'package:perminda/data/remote_models/product_images/results.dart';
import 'dart:io';

import 'package:perminda/domain/repos/product_image_repo.dart';

class ProductImageRepoImpl extends ProductImageRepo {
  final NetWorkInfo netWorkInfo;
  final ProductImageRemoteSource remoteSource;
  final ProductImageLocalSource localSource;
  int offset = 0;

  ProductImageRepoImpl({this.netWorkInfo, this.remoteSource, this.localSource});

  @override
  Future<Either<Failure, ImagesResult>> addProductImage(
      File image, int type, String productId) async {
    if (await netWorkInfo.isConnected()) {
      try {
        final result =
            await remoteSource.addProductImage(image, type, productId);

        await localSource
            .insertProductImages(ProductImageTable.fromImagesResult([result]));

        return Right(result);
      } on UnauthorizedTokenException {
        return Left(UnauthorizedTokenFailure());
      } on NotAllowedPermissionException {
        return Left(NotAllowedPermissionFailure());
      } on FieldsException catch (error) {
        return Left(
          ProductImageFieldsFailure.fromFieldsException(
            json.decode(error.body),
          ),
        );
      } on UnknownException catch (error) {
        print(error.message);
        return Left(UnknownFailure());
      }
    } else {
      return Left(NoInternetFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> deleteProductImage(String id) async {
    if (await netWorkInfo.isConnected()) {
      try {
        final result = await remoteSource.deleteProductImage(id);

        await localSource.deleteProductImageById(id);

        return Right(result);
      } on UnauthorizedTokenException {
        return Left(UnauthorizedTokenFailure());
      } on NotAllowedPermissionException {
        return Left(NotAllowedPermissionFailure());
      } on ItemNotFoundException {
        return Left(ItemNotFoundFailure());
      } on UnknownException catch (error) {
        print(error.message);
        return Left(UnknownFailure());
      }
    } else {
      return Left(NoInternetFailure());
    }
  }

  @override
  Future<Either<Failure, ImagesResult>> editProductImage(
      String id, File image, int type, String productId) async {
    if (await netWorkInfo.isConnected()) {
      try {
        final result =
            await remoteSource.editProductImage(id, image, type, productId);

        await localSource
            .insertProductImages(ProductImageTable.fromImagesResult([result]));

        return Right(result);
      } on UnauthorizedTokenException {
        return Left(UnauthorizedTokenFailure());
      } on NotAllowedPermissionException {
        return Left(NotAllowedPermissionFailure());
      } on ItemNotFoundException {
        return Left(ItemNotFoundFailure());
      } on FieldsException catch (error) {
        return Left(
          ProductImageFieldsFailure.fromFieldsException(
            json.decode(error.body),
          ),
        );
      } on UnknownException catch (error) {
        print(error.message);
        return Left(UnknownFailure());
      }
    } else {
      return Left(NoInternetFailure());
    }
  }

  @override
  Future<Either<Failure, ImagesResult>> getProductImage(String id) async {
    if (await netWorkInfo.isConnected()) {
      try {
        final result = await remoteSource.getProductImage(id);

        await localSource
            .insertProductImages(ProductImageTable.fromImagesResult([result]));

        return Right(result);
      } on ItemNotFoundException {
        return Left(ItemNotFoundFailure());
      } on UnknownException catch (error) {
        print(error.message);
        return Left(UnknownFailure());
      }
    } else {
      return Left(NoInternetFailure());
    }
  }

  @override
  Future<Either<Failure, ProductImages>> getImagesOfProduct(
      String productId) async {
    if (await netWorkInfo.isConnected()) {
      try {
        final result =
            await remoteSource.getImagesOfProduct(productId, this.offset);

        if (this.offset == 0) localSource.deleteImagesOfProduct(productId);

        await localSource.insertProductImages(
            ProductImageTable.fromImagesResult(result.results));

        final offset = API.offsetExtractor(result.nextPage);

        cacheOffset(offset);

        return Right(result);
      } on UnknownException catch (error) {
        print(error.message);
        return Left(UnknownFailure());
      }
    } else {
      return Left(NoInternetFailure());
    }
  }

  void cacheOffset(int offset) {
    this.offset = offset;
  }
}
