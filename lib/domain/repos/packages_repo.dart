import 'package:dartz/dartz.dart';
import 'package:perminda/core/errors/failure.dart';
import 'package:perminda/data/remote_models/packages/packages.dart';

abstract class PackagesRepo {
  Future<Either<Failure, Packages>> getPackages();
}
