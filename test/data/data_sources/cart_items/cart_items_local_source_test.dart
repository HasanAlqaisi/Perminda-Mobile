import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:moor_flutter/moor_flutter.dart';
import 'package:perminda/data/data_sources/cart_items/cart_items_local_source.dart';
import 'package:perminda/data/db/app_database/app_database.dart';
import 'package:perminda/data/db/models/cart_item/cart_item_dao.dart';

class MockCartItemDao extends Mock implements CartItemDao {}

void main() {
  MockCartItemDao cartItemDao;
  CartItemsLocalSourceImpl cartItemLocal;

  setUp(() {
    cartItemDao = MockCartItemDao();
    cartItemLocal = CartItemsLocalSourceImpl(cartItemDao: cartItemDao);
  });

  group('insertCartItem', () {
    final cartItem = CartItemTableCompanion(
      product: Value('1'),
      user: Value('1'),
      quantity: Value(10),
    );

    test('should throw [InvalidDataException] otherwise', () {
      when(cartItemDao.insertCartItems([cartItem]))
          .thenThrow(InvalidDataException(''));

      final result = cartItemLocal.insertCartItems;

      expect(() => result([cartItem]), throwsA(isA<InvalidDataException>()));
    });
  });
}
