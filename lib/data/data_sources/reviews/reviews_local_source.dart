import 'package:moor_flutter/moor_flutter.dart';
import 'package:perminda/data/db/app_database/app_database.dart';
import 'package:perminda/data/db/models/review/review_dao.dart';

abstract class ReviewsLocalSource {
  Future<int> insertReview(ReviewTableCompanion review);

  Stream<List<ReviewData>> watchReviews(String productId);
}

class ReviewsLocalSourceImpl extends ReviewsLocalSource {
  final ReviewDao reviewDao;

  ReviewsLocalSourceImpl({this.reviewDao});

  @override
  Future<int> insertReview(ReviewTableCompanion review) {
    try {
      return reviewDao.insertReview(review);
    } on InvalidDataException {
      rethrow;
    }
  }

  @override
  Stream<List<ReviewData>> watchReviews(String productId) {
    return reviewDao.watchReviews(productId);
  }
}
