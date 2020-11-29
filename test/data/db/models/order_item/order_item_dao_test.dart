import 'package:flutter_test/flutter_test.dart';
import 'package:moor_ffi/moor_ffi.dart';
import 'package:perminda/data/db/app_database/app_database.dart';
import 'package:perminda/data/remote_models/orders/results.dart';

import '../../dummy_models.dart';

void main() {
  AppDatabase db;

  setUp(() {
    db = AppDatabase(VmDatabase.memory());
  });

  tearDown(() async {
    db.close();
  });

  final List<OrdersResult> ordersResult = [
    OrdersResult(
      '1',
      '1',
      'Baghdad',
      ['1', '2'],
      201.1,
      3,
      0,
      '2020-10-10',
      '2020-10-10',
      '2020-10-10',
      '2020-10-10',
    ),
    OrdersResult(
      '2',
      '1',
      'Baghdad',
      ['3'],
      201.1,
      3,
      0,
      '2020-10-10',
      '2020-10-10',
      '2020-10-10',
      '2020-10-10',
    ),
    OrdersResult(
      '3',
      '2',
      'Baghdad',
      ['2', '3'],
      201.1,
      3,
      0,
      '2020-10-10',
      '2020-10-10',
      '2020-10-10',
      '2020-10-10',
    )
  ];

  group('watchOrders', () {
    test('should return list of [OrderWithProducts] in a correct way',
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
      await db.orderDao.insertOrders(
          [DummyModels.order1, DummyModels.order2, DummyModels.order3]);

      //Inserting [product1, product2] for order1
      //Inserting [product3] for order2
      //Inserting [product2, product3] for order3
      await db.orderItemDao.insertOrderItems(ordersResult);

      final result = db.orderItemDao.watchOrders('2');

      final res = await result.first;

      (await res).forEach((element) {
        print('order: ${element.order}');
        print('products: ${element.products.length}\n\n');
      });
    });
  });
}
