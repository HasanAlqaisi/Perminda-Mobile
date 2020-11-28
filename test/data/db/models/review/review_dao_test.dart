import 'package:flutter_test/flutter_test.dart';
import 'package:moor_ffi/moor_ffi.dart';
import 'package:perminda/data/db/app_database/app_database.dart';

import '../../dummy_models.dart';

void main() {
  AppDatabase db;

  setUp(() {
    db = AppDatabase(VmDatabase.memory());
  });

  tearDown(() async {
    db.close();
  });
  group('watchReviews', () {
    test('should return list of [ReviewData] in a correct way', () async {
      await db.userDao.insertUser(DummyModels.user1);
      await db.userDao.insertUser(DummyModels.user2);
      await db.shopDao.insertShop(DummyModels.shop1);
      await db.shopDao.insertShop(DummyModels.shop2);
      await db.categoryDao.insertCategory(DummyModels.category1);
      await db.categoryDao.insertCategory(DummyModels.category2);
      await db.productDao.insertProduct(DummyModels.product1);
      await db.productDao.insertProduct(DummyModels.product2);
      await db.reviewDao.insertReview(DummyModels.review1Product1User1);
      await db.reviewDao.insertReview(DummyModels.review2Product1User2);
      await db.reviewDao.insertReview(DummyModels.review3Product2User1);

      final result = db.reviewDao.watchReviews(DummyModels.product2.id.value);

      (await result.first).forEach((review) {
        print('Review ${review.toString()}');
      });
    });
  });
}
