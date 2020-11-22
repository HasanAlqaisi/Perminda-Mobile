import 'package:dartz/dartz.dart';
import 'package:perminda/core/errors/failure.dart';
import 'package:perminda/data/remote_models/reviews/results.dart';
import 'package:perminda/data/remote_models/reviews/reviews.dart';

abstract class ReviewsRepo {
  Future<Either<Failure, Reviews>> getReviews(String productId);

  Future<Either<Failure, ReviewsResult>> addReview(
    int rate,
    String message,
    String productId,
  );

  Future<Either<Failure, ReviewsResult>> editReview(
    String reviewId,
    int rate,
    String message,
    String productId,
  );

  Future<Either<Failure, bool>> deleteReview(String reviewId);
}
