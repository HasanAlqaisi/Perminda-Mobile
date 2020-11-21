import 'package:dartz/dartz.dart';
import 'package:perminda/core/errors/failure.dart';
import 'package:perminda/data/remote_models/reviews/review.dart';

abstract class ReviewsRepo {
  Future<Either<Failure, List<Review>>> getReviews(String productId);

  Future<Either<Failure, Review>> addReview(
    int rate,
    String message,
    String productId,
  );

  Future<Either<Failure, Review>> editReview(
    String reviewId,
    int rate,
    String message,
    String productId,
  );

  Future<Either<Failure, bool>> deleteReview(String reviewId);
}
