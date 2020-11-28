import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:moor_flutter/moor_flutter.dart';
import 'package:perminda/data/data_sources/cart_items/cart_items_local_source.dart';
import 'package:perminda/data/db/app_database/app_database.dart';
import 'package:perminda/data/db/models/cart_item/cart_item_dao.dart';
import '../../db/dummy_models.dart';

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

    test('sould return 1[int] if the cartItem inserted', () async {
      when(cartItemDao.insertCartItem(cartItem)).thenAnswer((_) async => 1);

      final result = await cartItemLocal.insertCartItem(cartItem);

      expect(result, 1);
    });

    test('should throw [InvalidDataException] otherwise', () {
      when(cartItemDao.insertCartItem(cartItem))
          .thenThrow(InvalidDataException(''));

      final result = cartItemLocal.insertCartItem;

      expect(() => result(cartItem), throwsA(isA<InvalidDataException>()));
    });
  });
}
