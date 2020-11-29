import 'package:moor_flutter/moor_flutter.dart';
import 'package:perminda/data/db/app_database/app_database.dart';
import 'package:perminda/data/remote_models/cart_items/results.dart';

@DataClassName('CartItemData')
class CartItemTable extends Table {
  TextColumn get id => text()();
  TextColumn get user => text().customConstraint('REFERENCES user_table(id)')();
  TextColumn get product =>
      text().customConstraint('REFERENCES product_table(id)')();
  IntColumn get quantity => integer()();

  @override
  String get tableName => 'cart_item_table';

  @override
  Set<Column> get primaryKey => {id, user, product};

  static List<CartItemTableCompanion> fromCartItemsResult(
      List<CartItemsResult> cartItemsResult) {
    return cartItemsResult
        .map(
          (result) => CartItemTableCompanion(
            id: Value(result.id),
            user: Value(result.userId),
            quantity: Value(result.quantity),
            product: Value(result.productId),
          ),
        )
        .toList();
  }
}
