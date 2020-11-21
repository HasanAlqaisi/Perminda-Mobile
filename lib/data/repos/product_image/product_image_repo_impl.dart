import 'dart:convert';

import 'package:perminda/core/errors/exception.dart';
import 'package:perminda/core/network/network_info.dart';
import 'package:perminda/data/data_sources/product_image/remote_source.dart';
import 'package:perminda/data/remote_models/product_image/product_image.dart';
import 'package:perminda/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import 'dart:io';

import 'package:perminda/domain/repos/product_image_repo.dart';

class ProductImageRepoImpl extends ProductImageRepo {
  final NetWorkInfo netWorkInfo;
  final ProductImageRemoteSource remoteSource;

  ProductImageRepoImpl({this.netWorkInfo, this.remoteSource});

  @override
  Future<Either<Failure, ProductImage>> addProductImage(
      File image, int type, String productId) async {
    if (await netWorkInfo.isConnected()) {
      try {
        final result =
            await remoteSource.addProductImage(image, type, productId);
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
  Future<Either<Failure, ProductImage>> editProductImage(
      String id, File image, int type, String productId) async {
    if (await netWorkInfo.isConnected()) {
      try {
        final result =
            await remoteSource.editProductImage(id, image, type, productId);
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
  Future<Either<Failure, ProductImage>> getProductImage(String id) async {
    if (await netWorkInfo.isConnected()) {
      try {
        final result = await remoteSource.getProductImage(id);
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
}
