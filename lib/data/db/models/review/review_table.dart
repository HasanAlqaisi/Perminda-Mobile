import 'package:moor_flutter/moor_flutter.dart';
import 'package:perminda/data/db/app_database/app_database.dart';
import 'package:perminda/data/remote_models/reviews/results.dart';

@DataClassName('ReviewData')
class ReviewTable extends Table {
  TextColumn get id => text()();
  TextColumn get user => text().customConstraint('REFERENCES user_table(id)')();
  TextColumn get product =>
      text().customConstraint('REFERENCES product_table(id)')();
  IntColumn get rate => integer()();
  TextColumn get message => text().nullable()();
  DateTimeColumn get dateWrote => dateTime()();
  DateTimeColumn get lastUpdate => dateTime()();

  @override
  String get tableName => 'review_table';

  @override
  Set<Column> get primaryKey => {id};

  static List<ReviewTableCompanion> fromReviewsResult(
      List<ReviewsResult> reviewsResult) {
    return reviewsResult
        .map(
          (reviewsResult) => ReviewTableCompanion(
            id: Value(reviewsResult.id),
            user: Value(reviewsResult.userId),
            rate: Value(reviewsResult.rate),
            product: Value(reviewsResult.productId),
            message: Value(reviewsResult.message),
            dateWrote: Value(DateTime.tryParse(reviewsResult.dateWrote)),
            lastUpdate: Value(DateTime.tryParse(reviewsResult.lastUpdate)),
          ),
        )
        .toList();
  }
}
