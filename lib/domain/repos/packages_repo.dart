import 'package:dartz/dartz.dart';
import 'package:perminda/core/errors/failure.dart';
import 'package:perminda/data/db/app_database/app_database.dart';
import 'package:perminda/data/db/relations/order_item/product_info.dart';
import 'package:perminda/data/remote_models/packages/packages.dart';

abstract class PackagesRepo {
  Future<Either<Failure, Packages>> getPackages();

  Stream<List<PackageData>> watchPackages();

  Stream<Future<List<ProductInfo>>> watchProductsOfPackage(String packageId);
}
