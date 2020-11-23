import 'package:dartz/dartz.dart';
import 'package:perminda/core/errors/failure.dart';
import 'package:perminda/data/remote_models/cart_items/cart_items.dart';
import 'package:perminda/data/remote_models/cart_items/results.dart';

abstract class CartItemsRepo {
  Future<Either<Failure, CartItems>> getCartItems(int offset);

  Future<Either<Failure, CartItemsResult>> addCartItem(
    String productId,
    int quantity,
  );

  Future<Either<Failure, CartItemsResult>> editCartItem(
    String id,
    String productId,
    int quantity,
  );

  Future<Either<Failure, bool>> deleteCartItem(String id);
}
