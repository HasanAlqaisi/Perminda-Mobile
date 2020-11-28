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

  group('watchPackages', () {
    test('should return list of [PackageWithProducts] in a correct way',
        () async {
      await db.brandDao.insertBrand(DummyModels.brand1);
      await db.userDao.insertUser(DummyModels.user1);
      await db.userDao.insertUser(DummyModels.user2);
      await db.shopDao.insertShop(DummyModels.shop1);
      await db.shopDao.insertShop(DummyModels.shop2);
      await db.categoryDao.insertCategory(DummyModels.category1);
      await db.categoryDao.insertCategory(DummyModels.category2);
      await db.categoryDao.insertCategory(DummyModels.category3);
      await db.productDao.insertProduct(DummyModels.product1);
      await db.productDao.insertProduct(DummyModels.product2);
      await db.productDao.insertProduct(DummyModels.product3);
      await db.packageDao.insertPackage(DummyModels.package1);
      //Inserting [product1, product2] for package1
      await db.packageItemDao.insertPackageItemDao(PackageItemTableCompanion(
          package: DummyModels.package1.id, product: DummyModels.product1.id));
      await db.packageItemDao.insertPackageItemDao(PackageItemTableCompanion(
          package: DummyModels.order1.id, product: DummyModels.product2.id));

      await db.packageDao.insertPackage(DummyModels.package2);
      //Inserting [product3] for package2
      await db.packageItemDao.insertPackageItemDao(PackageItemTableCompanion(
          package: DummyModels.package2.id, product: DummyModels.product3.id));

      await db.packageDao.insertPackage(DummyModels.package3);
      //Inserting [product2, product3] for package3
      await db.packageItemDao.insertPackageItemDao(PackageItemTableCompanion(
          package: DummyModels.package3.id, product: DummyModels.product2.id));
      await db.packageItemDao.insertPackageItemDao(PackageItemTableCompanion(
          package: DummyModels.package3.id, product: DummyModels.product3.id));

      final result = db.packageItemDao.watchPackages();

      final res = await result.first;

      (await res).forEach((element) {
        print('package: ${element.package}');
        print('products: ${element.products.length}\n\n');
      });
    });
  });
}
