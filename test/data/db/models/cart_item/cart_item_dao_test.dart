import 'package:flutter_test/flutter_test.dart';
import 'package:moor_ffi/moor_ffi.dart';
import 'package:moor_flutter/moor_flutter.dart';
import 'package:perminda/data/db/app_database/app_database.dart';

void main() {
  AppDatabase appDatabase;
  final brand = BrandTableCompanion(
    id: Value('dada'),
    logo: Value('ex.com'),
    name: Value('Samsung'),
  );
  final user = UserTableCompanion(
    id: Value('1'),
    firstName: Value('Hasan'),
    lastName: Value('AlQaisi'),
    username: Value('hasan'),
    email: Value('hasan@gmail.com'),
    phoneNumber: Value('+964-hasan'),
    address: Value('Baghdad - Iraq'),
    image: Value('example.com'),
    dateJoined: Value(DateTime.parse('2020-10-10')),
    lastLogin: Value(DateTime.parse('2020-10-10')),
  );
  final user2 = UserTableCompanion(
    id: Value('2'),
    firstName: Value('rami'),
    lastName: Value('rami'),
    username: Value('rami'),
    email: Value('rami@gmail.com'),
    phoneNumber: Value('+964-rami'),
    address: Value('Baghdad - Iraq'),
    image: Value('example.com'),
    dateJoined: Value(DateTime.parse('2020-10-10')),
    lastLogin: Value(DateTime.parse('2020-10-10')),
  );
  final shop = ShopTableCompanion(
    id: Value('1'),
    user: Value('1'),
    name: Value('hasanShop'),
    dateCreated: Value(DateTime.parse('2020-10-10')),
  );
  final category = CategoryTableCompanion(
    id: Value('1'),
    name: Value('hasanShop'),
  );
  final product = ProductTableCompanion(
    id: Value('1'),
    shop: Value('1'),
    category: Value('1'),
    brand: Value('1'),
    name: Value('galaxy S10'),
    price: Value(100),
    sale: Value(0),
    overview: Value('this is a mobile'),
    deliveryTime: Value(0),
    rate: Value(4.3),
    buyers: Value(0),
    numReviews: Value(0),
    active: Value(true),
    quantity: Value(500),
    dateAdded: Value(DateTime.parse('2020-10-10')),
    dateFirstActive: Value(DateTime.parse('2020-10-10')),
    lastUpdate: Value(DateTime.parse('2020-10-10')),
  );
  final product2 = ProductTableCompanion(
    id: Value('2'),
    shop: Value('1'),
    category: Value('1'),
    name: Value('ihpone'),
    price: Value(100),
    sale: Value(0),
    overview: Value('this is an ihpone'),
    deliveryTime: Value(0),
    rate: Value(4.3),
    buyers: Value(0),
    numReviews: Value(0),
    active: Value(true),
    quantity: Value(500),
    dateAdded: Value(DateTime.parse('2020-10-10')),
    dateFirstActive: Value(DateTime.parse('2020-10-10')),
    lastUpdate: Value(DateTime.parse('2020-10-10')),
  );
  final cartItem = CartItemTableCompanion(
    id: Value('1'),
    product: Value('1'),
    user: Value('1'),
    quantity: Value(10),
  );
  final cartItem2 = CartItemTableCompanion(
    id: Value('2'),
    product: Value('2'),
    user: Value('1'),
    quantity: Value(10),
  );
  final cartItem3 = CartItemTableCompanion(
    id: Value('3'),
    product: Value('1'),
    user: Value('2'),
    quantity: Value(10),
  );

  setUp(() {
    appDatabase = AppDatabase(VmDatabase.memory());
  });

  tearDown(() async {
    appDatabase.close();
  });

  test('should return [userWithCartItemsWithProducts] in a correct way',
      () async {
    await appDatabase.brandDao.insertBrands([brand]);
    await appDatabase.userDao.insertUser(user);
    await appDatabase.userDao.insertUser(user2);
    await appDatabase.shopDao.insertShops([shop]);
    await appDatabase.categoryDao.insertCategories([category]);
    await appDatabase.productDao.insertProducts([product, product2]);
    await appDatabase.cartItemDao
        .insertCartItems([cartItem, cartItem2, cartItem3]);

    final result = appDatabase.cartItemDao.watchCartItems(user.id.value);

    final res = await result.first;

    (await res).forEach((e) async {
      final finalResult = await e;
      print('cart Item ${finalResult.cartItem.toString()}');
      print('product: ${finalResult.product.toString()}');
      print('brand: ${finalResult.brand.toString()}');
      print('category: ${finalResult.category.toString()}');
      print('shop: ${finalResult.shop.toString()}\n\n');
    });
  });
}
