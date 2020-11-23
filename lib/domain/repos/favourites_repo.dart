import 'package:dartz/dartz.dart';
import 'package:perminda/core/errors/failure.dart';
import 'package:perminda/data/remote_models/favourites/favourites.dart';
import 'package:perminda/data/remote_models/favourites/results.dart';

abstract class FavouritesRepo {
  Future<Either<Failure, Favourites>> getFavourites(int offset);

  Future<Either<Failure, FavouritesResult>> addFavourite(String productId);

  Future<Either<Failure, bool>> deleteFavourite(String id);
}