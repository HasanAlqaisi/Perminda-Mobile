import 'dart:convert';

import 'package:perminda/core/errors/exception.dart';
import 'package:perminda/core/network/network_info.dart';
import 'package:perminda/data/data_sources/reviews/reviews_remote_source.dart';
import 'package:perminda/data/remote_models/reviews/review.dart';
import 'package:perminda/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:perminda/domain/repos/reviews_repo.dart';

class ReviewsRepoImpl extends ReviewsRepo {
  final NetWorkInfo netWorkInfo;
  final ReviewsRemoteSource remoteSource;

  ReviewsRepoImpl({this.netWorkInfo, this.remoteSource});

  @override
  Future<Either<Failure, Review>> addReview(
    int rate,
    String message,
    String productId,
  ) async {
    if (await netWorkInfo.isConnected()) {
      try {
        final result = await remoteSource.addReview(rate, message, productId);
        return Right(result);
      } on NotAllowedPermissionException {
        return Left(NotAllowedPermissionFailure());
      } on UnauthorizedTokenException {
        return Left(UnauthorizedTokenFailure());
      } on FieldsException catch (error) {
        return Left(
            ReviewFieldsFailure.fromFieldsException(json.decode(error.body)));
      } on UnknownException catch (error) {
        print(error.message);
        return Left(UnknownFailure());
      }
    } else {
      return Left(NoInternetFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> deleteReview(String reviewId) async {
    if (await netWorkInfo.isConnected()) {
      try {
        final result = await remoteSource.deleteReview(reviewId);
        return Right(result);
      } on UnauthorizedTokenException {
        return Left(UnauthorizedTokenFailure());
      } on ItemNotFoundException {
        return Left(ItemNotFoundFailure());
      } on UnknownException catch (error) {
        print(error.message);
        return Left(UnknownFailure());
      }
    } else {
      return Left(NoInternetFailure());
    }
  }

  @override
  Future<Either<Failure, Review>> editReview(
    String reviewId,
    int rate,
    String message,
    String productId,
  ) async {
    if (await netWorkInfo.isConnected()) {
      try {
        final result =
            await remoteSource.editReview(reviewId, rate, message, productId);
        return Right(result);
      } on UnauthorizedTokenException {
        return Left(UnauthorizedTokenFailure());
      } on ItemNotFoundException {
        return Left(ItemNotFoundFailure());
      } on FieldsException catch (error) {
        return Left(
          ReviewFieldsFailure.fromFieldsException(json.decode(error.body)),
        );
      } on NotAllowedPermissionException {
        return Left(NotAllowedPermissionFailure());
      }
    } else {
      return Left(NoInternetFailure());
    }
  }

  @override
  Future<Either<Failure, List<Review>>> getReviews(String productId) async {
    if (await netWorkInfo.isConnected()) {
      try {
        final result = await remoteSource.getReviews(productId);
        return Right(result);
      } on UnknownException catch (error) {
        print(error.message);
        return Left(UnknownFailure());
      }
    } else {
      return Left(NoInternetFailure());
    }
  }
}
