import 'dart:convert';

import 'package:perminda/core/api_helpers/api.dart';
import 'package:perminda/core/errors/exception.dart';
import 'package:perminda/core/network/network_info.dart';
import 'package:perminda/data/data_sources/favourites/favourites_remote_source.dart';
import 'package:perminda/data/remote_models/favourites/results.dart';
import 'package:perminda/data/remote_models/favourites/favourites.dart';
import 'package:perminda/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:perminda/domain/repos/favourites_repo.dart';

class FavouritesRepoImpl extends FavouritesRepo {
  final NetWorkInfo netWorkInfo;
  final FavouritesRemoteSource remoteSource;
  int offset = 0;

  FavouritesRepoImpl({this.netWorkInfo, this.remoteSource});

  @override
  Future<Either<Failure, FavouritesResult>> addFavourite(
      String productId) async {
    if (await netWorkInfo.isConnected()) {
      try {
        final result = await remoteSource.addFavourite(productId);
        return Right(result);
      } on FieldsException catch (error) {
        return Left(
          FavouritesFieldsFailure.fromFieldsException(json.decode(error.body)),
        );
      } on UnauthorizedTokenException {
        return Left(UnauthorizedTokenFailure());
      } on UnknownException {
        return Left(UnknownFailure());
      }
    } else {
      return Left(NoInternetFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> deleteFavourite(String id) async {
    if (await netWorkInfo.isConnected()) {
      try {
        final result = await remoteSource.deleteFavourite(id);
        return Right(result);
      } on ItemNotFoundException {
        return Left(ItemNotFoundFailure());
      } on UnauthorizedTokenException {
        return Left(UnauthorizedTokenFailure());
      } on UnknownException {
        return Left(UnknownFailure());
      }
    } else {
      return Left(NoInternetFailure());
    }
  }

  @override
  Future<Either<Failure, Favourites>> getFavourites(int offset) async {
    if (await netWorkInfo.isConnected()) {
      try {
        final result = await remoteSource.getFavourites(this.offset);

        final offset = API.offsetExtractor(result.nextPage);

        cacheOffset(offset);

        return Right(result);
      } on UnauthorizedTokenException {
        return Left(UnauthorizedTokenFailure());
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
}
