import 'package:perminda/core/errors/exception.dart';
import 'package:perminda/core/network/network_info.dart';
import 'package:perminda/data/data_sources/brands/remote_source.dart';
import 'package:perminda/data/remote_models/brands/brand.dart';
import 'package:perminda/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:perminda/domain/repos/brands_repo.dart';

class BrandsRepoImpl extends BrandsRepo {
  final NetWorkInfo netWorkInfo;
  final BrandsRemoteSource remoteSource;

  BrandsRepoImpl({this.netWorkInfo, this.remoteSource});

  @override
  Future<Either<Failure, List<Brand>>> getBrands() async {
    if (await netWorkInfo.isConnected()) {
      try {
        final result = await remoteSource.getBrands();
        return Right(result);
      } on UnknownException {
        return Left(UnknownFailure());
      }
    } else {
      return Left(NoInternetFailure());
    }
  }

  @override
  Future<Either<Failure, Brand>> getBrandById(String id) async {
    if (await netWorkInfo.isConnected()) {
      try {
        final result = await remoteSource.getBrandById(id);
        return Right(result);
      } on ItemNotFoundException {
        return Left(ItemNotFoundFailure());
      } on UnknownException {
        return Left(UnknownFailure());
      }
    } else {
      return Left(NoInternetFailure());
    }
  }
}
