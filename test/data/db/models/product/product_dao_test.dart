import 'package:flutter_test/flutter_test.dart';
import 'package:moor_ffi/moor_ffi.dart';
import 'package:perminda/data/db/app_database/app_database.dart';

import '../../dummy_models.dart';

void main() {
  AppDatabase appDatabase;

  setUp(() {
    appDatabase = AppDatabase(VmDatabase.memory());
  });

  tearDown(() async {
    appDatabase.close();
  });

  group('watchProductsByShopId', () {
    test('should return [ProductAndCategoryAndBrandAndShop] in a correct way',
        () async {
      await appDatabase.brandDao
          .insertBrands([DummyModels.brand1, DummyModels.brand2]);
      await appDatabase.userDao.insertUser(DummyModels.user1);
      await appDatabase.userDao.insertUser(DummyModels.user2);
      await appDatabase.shopDao
          .insertShops([DummyModels.shop1, DummyModels.shop2]);
      await appDatabase.categoryDao.insertCategories([
        DummyModels.category1,
        DummyModels.category2,
        DummyModels.category3
      ]);
      await appDatabase.productDao.insertProducts(
          [DummyModels.product1, DummyModels.product2, DummyModels.product3]);

      final result = appDatabase.productDao.watchProductsByShopId('1');

      (await result.first).forEach((element) {
        print('product: ${element.product}');
        print('shop: ${element.shop}');
        print('category: ${element.category}');
        print('brand: ${element.brand}');
      });
    });
  });

  group('watchProductsByCategoryId', () {
    test('should return [ProductAndCategoryAndBrandAndShop] in a correct way',
        () async {
      await appDatabase.brandDao
          .insertBrands([DummyModels.brand1, DummyModels.brand2]);
      await appDatabase.userDao.insertUser(DummyModels.user1);
      await appDatabase.userDao.insertUser(DummyModels.user2);
      await appDatabase.shopDao
          .insertShops([DummyModels.shop1, DummyModels.shop2]);
      await appDatabase.categoryDao.insertCategories([
        DummyModels.category1,
        DummyModels.category2,
        DummyModels.category3
      ]);
      await appDatabase.productDao.insertProducts(
          [DummyModels.product1, DummyModels.product2, DummyModels.product3]);

      final result =
          appDatabase.productDao.watchProductsWithInfoByCategoryId('2');

      (await result.first).forEach((element) {
        print('product: ${element.product}');
        print('shop: ${element.shop}');
        print('category: ${element.category}');
        print('brand: ${element.brand}');
      });
    });
  });

  group('watchProductsByBrandId', () {
    test('should return [ProductAndCategoryAndBrandAndShop] in a correct way',
        () async {
      await appDatabase.brandDao
          .insertBrands([DummyModels.brand1, DummyModels.brand2]);
      await appDatabase.userDao.insertUser(DummyModels.user1);
      await appDatabase.userDao.insertUser(DummyModels.user2);
      await appDatabase.shopDao
          .insertShops([DummyModels.shop1, DummyModels.shop2]);
      await appDatabase.categoryDao.insertCategories([
        DummyModels.category1,
        DummyModels.category2,
        DummyModels.category3
      ]);
      await appDatabase.productDao.insertProducts(
          [DummyModels.product1, DummyModels.product2, DummyModels.product3]);

      final result = appDatabase.productDao.watchProductsByBrandId('1');

      (await result.first).forEach((element) {
        print('product: ${element.product}');
        print('shop: ${element.shop}');
        print('category: ${element.category}');
        print('brand: ${element.brand}');
      });
    });
  });
}
