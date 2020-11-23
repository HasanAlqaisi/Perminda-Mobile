import 'dart:convert';

import 'package:perminda/core/api_helpers/api.dart';
import 'package:perminda/core/errors/exception.dart';
import 'package:perminda/core/network/network_info.dart';
import 'package:perminda/data/data_sources/orders/orders_remote_source.dart';
import 'package:perminda/data/remote_models/orders/results.dart';
import 'package:perminda/data/remote_models/orders/order_params.dart';
import 'package:perminda/data/remote_models/orders/orders.dart';
import 'package:perminda/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:perminda/domain/repos/orders_repo.dart';

class OrdersRepoImpl extends OrdersRepo {
  final NetWorkInfo netWorkInfo;
  final OrdersRemoteSource remoteSource;
  int offset = 0;

  OrdersRepoImpl({this.netWorkInfo, this.remoteSource});

  @override
  Future<Either<Failure, OrdersResult>> addOrder(
    String address,
    List<OrderParams> orderParams,
  ) async {
    if (await netWorkInfo.isConnected()) {
      try {
        final result = await remoteSource.addOrder(address, orderParams);
        return Right(result);
      } on UnauthorizedTokenException {
        return Left(UnauthorizedTokenFailure());
      } on FieldsException catch (error) {
        return Left(
            OrdersFieldsFailure.fromFieldsException(json.decode(error.body)));
      } on UnknownException {
        return Left(UnknownFailure());
      }
    } else {
      return Left(NoInternetFailure());
    }
  }

  @override
  Future<Either<Failure, OrdersResult>> editOrder(
      String id, String address) async {
    if (await netWorkInfo.isConnected()) {
      try {
        final result = await remoteSource.editOrder(id, address);
        return Right(result);
      } on UnauthorizedTokenException {
        return Left(UnauthorizedTokenFailure());
      } on FieldsException catch (error) {
        return Left(
            OrdersFieldsFailure.fromFieldsException(json.decode(error.body)));
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
  Future<Either<Failure, Orders>> getOrders() async {
    if (await netWorkInfo.isConnected()) {
      try {
        final result = await remoteSource.getOrders(this.offset);

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
