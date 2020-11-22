import 'package:dartz/dartz.dart';
import 'package:perminda/core/errors/failure.dart';
import 'package:perminda/data/remote_models/shops/results.dart';
import 'package:perminda/data/remote_models/shops/shops.dart';

abstract class ShopsRepo {
  Future<Either<Failure, Shops>> getShops();

  Future<Either<Failure, ShopsResult>> getShopById(String id);
}
