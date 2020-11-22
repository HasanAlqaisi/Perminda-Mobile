import 'package:dartz/dartz.dart';
import 'package:perminda/core/errors/failure.dart';
import 'package:perminda/data/remote_models/brands/brands.dart';
import 'package:perminda/data/remote_models/brands/results.dart';

abstract class BrandsRepo {
  Future<Either<Failure, Brands>> getBrands();

  Future<Either<Failure, BrandsResult>> getBrandById(String id);
}