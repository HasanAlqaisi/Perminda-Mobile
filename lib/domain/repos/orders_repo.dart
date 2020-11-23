import 'package:dartz/dartz.dart';
import 'package:perminda/core/errors/failure.dart';
import 'package:perminda/data/remote_models/orders/orders.dart';
import 'package:perminda/data/remote_models/orders/order_params.dart';
import 'package:perminda/data/remote_models/orders/results.dart';

abstract class OrdersRepo {
  Future<Either<Failure, Orders>> getOrders();

  Future<Either<Failure, OrdersResult>> addOrder(
    String address,
    List<OrderParams> orderParams,
  );

  Future<Either<Failure, OrdersResult>> editOrder(String id, String address);
}
