import 'dart:convert';

import 'package:perminda/core/api_helpers/api.dart';
import 'package:perminda/core/constants/sensetive_constants.dart';
import 'package:perminda/core/errors/exception.dart';
import 'package:perminda/core/network/network_info.dart';
import 'package:perminda/data/data_sources/cart_items/cart_items_local_source.dart';
import 'package:perminda/data/data_sources/cart_items/cart_items_remote_source.dart';
import 'package:perminda/data/db/models/cart_item/cart_item_table.dart';
import 'package:perminda/data/remote_models/cart_items/results.dart';
import 'package:perminda/data/remote_models/cart_items/cart_items.dart';
import 'package:perminda/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:perminda/domain/repos/cart_items_repo.dart';

class CartItemsRepoImpl extends CartItemsRepo {
  final NetWorkInfo netWorkInfo;
  final CartItemsRemoteSource remoteSource;
  final CartItemsLocalSource localSource;
  int offset = 0;

  CartItemsRepoImpl({this.netWorkInfo, this.remoteSource, this.localSource});

  @override
  Future<Either<Failure, CartItemsResult>> addCartItem(
      String productId, int quantity) async {
    if (await netWorkInfo.isConnected()) {
      try {
        final result = await remoteSource.addCartItem(productId, quantity);

        await localSource
            .insertCartItems(CartItemTable.fromCartItemsResult([result]));

        return Right(result);
      } on UnauthorizedTokenException {
        return Left(UnauthorizedTokenFailure());
      } on FieldsException catch (error) {
        return Left(
          CartItemsFieldsFailure.fromFieldsException(json.decode(error.body)),
        );
      } on UnknownException {
        return Left(UnknownFailure());
      }
    } else {
      return Left(NoInternetFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> deleteCartItem(String id) async {
    if (await netWorkInfo.isConnected()) {
      try {
        final result = await remoteSource.deleteCartItem(id);

        await localSource.deleteCartItemById(id);

        return Right(result);
      } on UnauthorizedTokenException {
        return Left(UnauthorizedTokenFailure());
      } on ItemNotFoundException {
        return Left(ItemNotFoundFailure());
      } on UnknownException {
        return Left(UnknownFailure());
      }
    } else {
      return Left(NoInternetFailure());
    }
  }

  @override
  Future<Either<Failure, CartItemsResult>> editCartItem(
      String id, String productId, int quantity) async {
    if (await netWorkInfo.isConnected()) {
      try {
        final result = await remoteSource.editCartItem(id, productId, quantity);

        await localSource
            .insertCartItems(CartItemTable.fromCartItemsResult([result]));

        return Right(result);
      } on UnauthorizedTokenException {
        return Left(UnauthorizedTokenFailure());
      } on FieldsException catch (error) {
        return Left(
          CartItemsFieldsFailure.fromFieldsException(json.decode(error.body)),
        );
      } on ItemNotFoundException {
        return Left(ItemNotFoundFailure());
      } on UnknownException {
        return Left(UnknownFailure());
      }
    } else {
      return Left(NoInternetFailure());
    }
  }

  @override
  Future<Either<Failure, CartItems>> getCartItems() async {
    if (await netWorkInfo.isConnected()) {
      try {
        final result = await remoteSource.getCartItems(this.offset);

        if (this.offset == 0) await localSource.deleteCartItems(userId);

        await localSource
            .insertCartItems(CartItemTable.fromCartItemsResult(result.results));

        final offset = API.offsetExtractor(result.nextPage);

        cacheOffset(offset);

        return Right(result);
      } on UnauthorizedTokenException {
        return Left(UnauthorizedTokenFailure());
      } on UnknownException {
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
