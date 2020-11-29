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

  group('getProductImages', () {
    test('should return list of [ProductImageData] in a correct way', () async {
      await db.userDao.insertUser(DummyModels.user1);
      await db.userDao.insertUser(DummyModels.user2);
      await db.shopDao.insertShops([DummyModels.shop1, DummyModels.shop2]);
      await db.categoryDao.insertCategories([
        DummyModels.category1,
        DummyModels.category2,
      ]);
      await db.productDao.insertProducts([
        DummyModels.product1,
        DummyModels.product2,
      ]);
      await db.productImageDao
          .insertProductImages([DummyModels.product1Images[0]]);
      await db.productImageDao
          .insertProductImages([DummyModels.product1Images[1]]);
      await db.productImageDao
          .insertProductImages([DummyModels.product2Images[0]]);
      await db.productImageDao
          .insertProductImages([DummyModels.product2Images[1]]);

      final result = await db.productImageDao
          .getProductImages(DummyModels.product2.id.value);

      result.forEach((image) {
        print('image ${image.toString()}');
      });
    });
  });
}
