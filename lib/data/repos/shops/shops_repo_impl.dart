import 'package:perminda/core/api_helpers/api.dart';
import 'package:perminda/core/errors/exception.dart';
import 'package:perminda/core/network/network_info.dart';
import 'package:perminda/data/data_sources/shops/shops_local_source.dart';
import 'package:perminda/data/data_sources/shops/shops_remote_source.dart';
import 'package:perminda/data/db/models/shop/shop_table.dart';
import 'package:perminda/data/remote_models/shops/results.dart';
import 'package:perminda/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:perminda/data/remote_models/shops/shops.dart';
import 'package:perminda/domain/repos/shops_repo.dart';

class ShopsRepoImpl extends ShopsRepo {
  final NetWorkInfo netWorkInfo;
  final ShopsRemoteSource remoteSource;
  final ShopsLocalSource localSource;
  int offset = 0;

  ShopsRepoImpl({this.netWorkInfo, this.remoteSource, this.localSource});

  @override
  Future<Either<Failure, Shops>> getShops() async {
    if (await netWorkInfo.isConnected()) {
      try {
        final result = await remoteSource.getShops(this.offset);

        if (this.offset == 0) localSource.deleteShops();

        await localSource
            .insertShops(ShopTable.fromShopsResult(result.results));

        final offset = API.offsetExtractor(result.nextPage);

        cacheOffset(offset);

        return Right(result);
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

  @override
  Future<Either<Failure, ShopsResult>> getShopById(String id) async {
    if (await netWorkInfo.isConnected()) {
      try {
        final result = await remoteSource.getShopById(id);

        await localSource.insertShops(ShopTable.fromShopsResult([result]));

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
