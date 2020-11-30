import 'package:moor_flutter/moor_flutter.dart';
import 'package:perminda/data/db/app_database/app_database.dart';
import 'package:perminda/data/db/models/product/product_table.dart';
import 'package:perminda/data/db/models/review/review_table.dart';

part 'review_dao.g.dart';

@UseDao(tables: [ReviewTable, ProductTable])
class ReviewDao extends DatabaseAccessor<AppDatabase> with _$ReviewDaoMixin {
  ReviewDao(AppDatabase db) : super(db);

  Future<void> insertReviews(List<ReviewTableCompanion> reviews) async {
    await batch((batch) {
      batch.insertAllOnConflictUpdate(reviewTable, reviews);
    });
  }

  /// We only need list of reviews for a product when a user clicks on one of products
  /// So, we could get the product id from there
  Stream<List<ReviewData>> watchReviews(String productId) {
    return (select(reviewTable)
          ..where((reviewTable) => reviewTable.product.equals(productId)))
        .watch();
  }

  Future<int> deleteReviewsOfProduct(String productId) =>
      (delete(reviewTable)..where((tbl) => tbl.product.equals(productId))).go();

  Future<int> deleteReviewById(String reviewId) =>
      (delete(reviewTable)..where((tbl) => tbl.id.equals(reviewId))).go();
}
