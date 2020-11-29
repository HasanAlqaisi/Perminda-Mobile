import 'package:flutter_test/flutter_test.dart';
import 'package:moor_ffi/moor_ffi.dart';
import 'package:perminda/data/db/app_database/app_database.dart';
import 'package:perminda/data/remote_models/packages/results.dart';

import '../../dummy_models.dart';

void main() {
  AppDatabase db;

  setUp(() {
    db = AppDatabase(VmDatabase.memory());
  });

  tearDown(() async {
    db.close();
  });

  final List<PackagesResult> packagesResult = [
    PackagesResult(
      '1',
      'dada',
      'kodsk.com',
      ['1', '2'],
      true,
      '2020-10-10',
    ),
    PackagesResult(
      '2',
      'dada',
      'kodsk.com',
      ['3'],
      true,
      '2020-10-10',
    ),
    PackagesResult(
      '3',
      'dada',
      'kodsk.com',
      ['2', '3'],
      true,
      '2020-10-10',
    ),
  ];

  group('watchPackagesWithProducts', () {
    test('should return list of [PackageWithProducts] in a correct way',
        () async {
      await db.brandDao.insertBrands([DummyModels.brand1]);
      await db.userDao.insertUser(DummyModels.user1);
      await db.userDao.insertUser(DummyModels.user2);
      await db.shopDao.insertShops([DummyModels.shop1, DummyModels.shop2]);
      await db.categoryDao.insertCategories([
        DummyModels.category1,
        DummyModels.category2,
        DummyModels.category3
      ]);
      await db.productDao.insertProducts(
          [DummyModels.product1, DummyModels.product2, DummyModels.product3]);
      await db.packageDao.insertPackages([DummyModels.package1]);
      await db.packageDao.insertPackages([DummyModels.package2]);
      await db.packageDao.insertPackages([DummyModels.package3]);

      //Inserting [product1, product2] for package1
      //Inserting [product3] for package2
      //Inserting [product2, product3] for package3
      await db.packageItemDao.insertPackageItems(packagesResult);

      final result = db.packageItemDao.watchPackagesWithProducts();

      final res = await result.first;

      (await res).forEach((element) {
        print('package: ${element.package}');
        print('products: ${element.products.length}\n\n');
      });
    });
  });

  group('watchPackages', () {
    test('should return list of [PackageData] in a correct way', () async {
      await db.brandDao.insertBrands([DummyModels.brand1]);
      await db.userDao.insertUser(DummyModels.user1);
      await db.userDao.insertUser(DummyModels.user2);
      await db.shopDao.insertShops([DummyModels.shop1, DummyModels.shop2]);
      await db.categoryDao.insertCategories([
        DummyModels.category1,
        DummyModels.category2,
        DummyModels.category3
      ]);
      await db.productDao.insertProducts(
          [DummyModels.product1, DummyModels.product2, DummyModels.product3]);
      await db.packageDao.insertPackages([DummyModels.package1]);
      await db.packageDao.insertPackages([DummyModels.package2]);
      await db.packageDao.insertPackages([DummyModels.package3]);

      //Inserting [product1, product2] for package1
      //Inserting [product3] for package2
      //Inserting [product2, product3] for package3
      await db.packageItemDao.insertPackageItems(packagesResult);

      final result = db.packageItemDao.watchPackages();

      final res = await result.first;

      (res).forEach((element) {
        print('package: ${element.toString()}');
      });
    });
  });

  group('watchProductsOfPackage', () {
    test('should return list of [ProductInfo] in a correct way', () async {
      await db.brandDao.insertBrands([DummyModels.brand1]);
      await db.userDao.insertUser(DummyModels.user1);
      await db.userDao.insertUser(DummyModels.user2);
      await db.shopDao.insertShops([DummyModels.shop1, DummyModels.shop2]);
      await db.categoryDao.insertCategories([
        DummyModels.category1,
        DummyModels.category2,
        DummyModels.category3
      ]);
      await db.productDao.insertProducts(
          [DummyModels.product1, DummyModels.product2, DummyModels.product3]);
      await db.packageDao.insertPackages(
          [DummyModels.package1, DummyModels.package2, DummyModels.package3]);

      //Inserting [product1, product2] for package1
      //Inserting [product3] for package2
      //Inserting [product2, product3] for package3
      await db.packageItemDao.insertPackageItems(packagesResult);

      final result = db.packageItemDao
          .watchProductsOfPackage(DummyModels.package2.id.value);

      final res = await result.first;

      (await res).forEach((element) {
        print('package: ${element.toString()}');
      });
    });
  });
}
