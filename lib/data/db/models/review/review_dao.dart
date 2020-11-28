import 'package:moor_flutter/moor_flutter.dart';
import 'package:perminda/data/db/app_database/app_database.dart';
import 'package:perminda/data/db/models/product/product_table.dart';
import 'package:perminda/data/db/models/review/review_table.dart';

part 'review_dao.g.dart';

@UseDao(tables: [ReviewTable, ProductTable])
class ReviewDao extends DatabaseAccessor<AppDatabase> with _$ReviewDaoMixin {
  ReviewDao(AppDatabase db) : super(db);

  Future<int> insertReview(ReviewTableCompanion review) =>
      into(reviewTable).insert(review, mode: InsertMode.insertOrReplace);

  /// We only need list of reviews for a product when a user clicks on one of products
  /// So, we could get the product id from there
  Stream<List<ReviewData>> watchReviews(String productId) {
    return (select(reviewTable)
          ..where((reviewTable) => reviewTable.product.equals(productId)))
        .watch();
  }
}
