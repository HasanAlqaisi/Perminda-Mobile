import 'package:perminda/core/errors/exception.dart';
import 'package:perminda/core/network/network_info.dart';
import 'package:perminda/data/data_sources/shops/shops_remote_source.dart';
import 'package:perminda/data/remote_models/shops/shop.dart';
import 'package:perminda/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:perminda/domain/repos/shops_repo.dart';

class ShopsRepoImpl extends ShopsRepo {
  final NetWorkInfo netWorkInfo;
  final ShopsRemoteSource remoteSource;

  ShopsRepoImpl({this.netWorkInfo, this.remoteSource});

  @override
  Future<Either<Failure, List<Shop>>> getShops() async {
    if (await netWorkInfo.isConnected()) {
      try {
        final result = await remoteSource.getShops();
        return Right(result);
      } on UnknownException {
        return Left(UnknownFailure());
      }
    } else {
      return Left(NoInternetFailure());
    }
  }

  @override
  Future<Either<Failure, Shop>> getShopById(String id) async {
    if (await netWorkInfo.isConnected()) {
      try {
        final result = await remoteSource.getShopById(id);
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
