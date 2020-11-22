import 'package:perminda/core/api_helpers/api.dart';
import 'package:perminda/core/errors/exception.dart';
import 'package:perminda/core/network/network_info.dart';
import 'package:perminda/data/data_sources/categories/remote_soruce.dart';
import 'package:perminda/data/remote_models/categories/categories.dart';
import 'package:perminda/data/remote_models/categories/results.dart';
import 'package:perminda/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:perminda/domain/repos/categories_repo.dart';

class CategoriesRepoImpl extends CategoriesRepo {
  final NetWorkInfo netWorkInfo;
  final CategoriesRemoteSource remoteSource;
  int offset = 0;

  CategoriesRepoImpl({this.netWorkInfo, this.remoteSource});

  @override
  Future<Either<Failure, Categories>> getCategories() async {
    if (await netWorkInfo.isConnected()) {
      try {
        final result = await remoteSource.getCategories(this.offset);

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
  Future<Either<Failure, CategoriesResult>> getCategoryById(String id) async {
    if (await netWorkInfo.isConnected()) {
      try {
        final result = await remoteSource.getCategoryById(id);
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
