import 'package:flutter_test/flutter_test.dart';
import 'package:moor_ffi/moor_ffi.dart';
import 'package:moor_flutter/moor_flutter.dart';
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
      await appDatabase.brandDao.insertBrand(DummyModels.brand1);
      await appDatabase.brandDao.insertBrand(DummyModels.brand2);
      await appDatabase.userDao.insertUser(DummyModels.user1);
      await appDatabase.userDao.insertUser(DummyModels.user2);
      await appDatabase.shopDao.insertShop(DummyModels.shop1);
      await appDatabase.shopDao.insertShop(DummyModels.shop2);
      await appDatabase.categoryDao.insertCategory(DummyModels.category1);
      await appDatabase.categoryDao.insertCategory(DummyModels.category2);
      await appDatabase.categoryDao.insertCategory(DummyModels.category3);
      await appDatabase.productDao.insertProduct(DummyModels.product1);
      await appDatabase.productDao.insertProduct(DummyModels.product2);
      await appDatabase.productDao.insertProduct(DummyModels.product3);

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
      await appDatabase.brandDao.insertBrand(DummyModels.brand1);
      await appDatabase.brandDao.insertBrand(DummyModels.brand2);
      await appDatabase.userDao.insertUser(DummyModels.user1);
      await appDatabase.userDao.insertUser(DummyModels.user2);
      await appDatabase.shopDao.insertShop(DummyModels.shop1);
      await appDatabase.shopDao.insertShop(DummyModels.shop2);
      await appDatabase.categoryDao.insertCategory(DummyModels.category1);
      await appDatabase.categoryDao.insertCategory(DummyModels.category2);
      await appDatabase.categoryDao.insertCategory(DummyModels.category3);
      await appDatabase.productDao.insertProduct(DummyModels.product1);
      await appDatabase.productDao.insertProduct(DummyModels.product2);
      await appDatabase.productDao.insertProduct(DummyModels.product3);

      final result = appDatabase.productDao.watchProductsByCategoryId('2');

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
      await appDatabase.brandDao.insertBrand(DummyModels.brand1);
      await appDatabase.brandDao.insertBrand(DummyModels.brand2);
      await appDatabase.userDao.insertUser(DummyModels.user1);
      await appDatabase.userDao.insertUser(DummyModels.user2);
      await appDatabase.shopDao.insertShop(DummyModels.shop1);
      await appDatabase.shopDao.insertShop(DummyModels.shop2);
      await appDatabase.categoryDao.insertCategory(DummyModels.category1);
      await appDatabase.categoryDao.insertCategory(DummyModels.category2);
      await appDatabase.categoryDao.insertCategory(DummyModels.category3);
      await appDatabase.productDao.insertProduct(DummyModels.product1);
      await appDatabase.productDao.insertProduct(DummyModels.product2);
      await appDatabase.productDao.insertProduct(DummyModels.product3);

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
