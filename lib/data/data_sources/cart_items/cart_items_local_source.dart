import 'package:moor_flutter/moor_flutter.dart';
import 'package:perminda/data/db/app_database/app_database.dart';
import 'package:perminda/data/db/models/cart_item/cart_item_dao.dart';
import 'package:perminda/data/db/relations/cart_item/user_with_cartItems_and_products.dart';

abstract class CartItemsLocalSource {
  Future<void> insertCartItems(List<CartItemTableCompanion> cartItems);

  Stream<Future<List<Future<CartItemAndProduct>>>> watchCartItems(
      String userId);

  Future<int> deleteCartItemById(String cartItemId);

  Future<int> deleteCartItems(String userId);
}

class CartItemsLocalSourceImpl extends CartItemsLocalSource {
  final CartItemDao cartItemDao;

  CartItemsLocalSourceImpl({this.cartItemDao});

  @override
  Future<void> insertCartItems(List<CartItemTableCompanion> cartItems) {
    try {
      return cartItemDao.insertCartItems(cartItems);
    } on InvalidDataException {
      rethrow;
    }
  }

  @override
  Stream<Future<List<Future<CartItemAndProduct>>>> watchCartItems(
      String userId) {
    return cartItemDao.watchCartItems(userId);
  }

  @override
  Future<int> deleteCartItemById(String cartItemId) {
    return cartItemDao.deleteCartItemById(cartItemId);
  }

  @override
  Future<int> deleteCartItems(String userId) => cartItemDao.deleteCartItems(userId);
}
