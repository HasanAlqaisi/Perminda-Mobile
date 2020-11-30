import 'package:perminda/core/api_helpers/api.dart';
import 'package:perminda/core/errors/exception.dart';
import 'package:perminda/core/network/network_info.dart';
import 'package:perminda/data/data_sources/brands/local_source.dart';
import 'package:perminda/data/data_sources/brands/remote_source.dart';
import 'package:perminda/data/db/models/brand/brand_table.dart';
import 'package:perminda/data/remote_models/brands/brands.dart';
import 'package:perminda/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:perminda/data/remote_models/brands/results.dart';
import 'package:perminda/domain/repos/brands_repo.dart';

class BrandsRepoImpl extends BrandsRepo {
  final NetWorkInfo netWorkInfo;
  final BrandsRemoteSource remoteSource;
  final BrandLocalSource localSource;
  int offset = 0;

  BrandsRepoImpl({this.netWorkInfo, this.remoteSource, this.localSource});

  @override
  Future<Either<Failure, Brands>> getBrands() async {
    if (await netWorkInfo.isConnected()) {
      try {
        final result = await remoteSource.getBrands(this.offset);

        if (this.offset == 0) await localSource.deleteBrands();

        await localSource
            .insertBrands(BrandTable.fromBrandsResult(result.results));

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
  Future<Either<Failure, BrandsResult>> getBrandById(String id) async {
    if (await netWorkInfo.isConnected()) {
      try {
        final result = await remoteSource.getBrandById(id);

        await localSource.insertBrands(BrandTable.fromBrandsResult([result]));

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
