import 'package:moor_flutter/moor_flutter.dart';
import 'package:perminda/data/db/app_database/app_database.dart';
import 'package:perminda/data/db/models/review/review_dao.dart';

abstract class ReviewsLocalSource {
  Future<void> insertReviews(List<ReviewTableCompanion> reviews);

  Stream<List<ReviewData>> watchReviews(String productId);

  Future<int> deleteReviewById(String reviewId);

  Future<int> deleteReviewsOfProduct(String productId);
}

class ReviewsLocalSourceImpl extends ReviewsLocalSource {
  final ReviewDao reviewDao;

  ReviewsLocalSourceImpl({this.reviewDao});

  @override
  Future<void> insertReviews(List<ReviewTableCompanion> reviews) {
    try {
      return reviewDao.insertReviews(reviews);
    } on InvalidDataException {
      rethrow;
    }
  }

  @override
  Stream<List<ReviewData>> watchReviews(String productId) {
    return reviewDao.watchReviews(productId);
  }

  @override
  Future<int> deleteReviewById(String reviewId) {
    return reviewDao.deleteReviewById(reviewId);
  }

  @override
  Future<int> deleteReviewsOfProduct(String productId) => reviewDao.deleteReviewsOfProduct(productId);
}
