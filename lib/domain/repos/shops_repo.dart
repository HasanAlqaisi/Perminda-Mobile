import 'package:dartz/dartz.dart';
import 'package:perminda/core/errors/failure.dart';
import 'package:perminda/data/remote_models/shops/shop.dart';

abstract class ShopsRepo {
  Future<Either<Failure, List<Shop>>> getShops();

  Future<Either<Failure, Shop>> getShopById(String id);
}
