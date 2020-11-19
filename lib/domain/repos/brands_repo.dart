import 'package:dartz/dartz.dart';
import 'package:perminda/core/errors/failure.dart';
import 'package:perminda/data/remote_models/brands/brand.dart';

abstract class BrandsRepo {
  Future<Either<Failure, List<Brand>>> getBrands();

  Future<Either<Failure, Brand>> getBrandById(String id);
}
