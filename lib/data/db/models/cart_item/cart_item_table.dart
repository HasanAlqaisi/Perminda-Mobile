import 'package:moor_flutter/moor_flutter.dart';

@DataClassName('CartItemData')
class CartItemTable extends Table {
  TextColumn get user => text().customConstraint('REFERENCES user_table(id)')();
  TextColumn get product =>
      text().customConstraint('REFERENCES product_table(id)')();
  IntColumn get quantity => integer()();

  @override
  String get tableName => 'cart_item_table';

  @override
  Set<Column> get primaryKey => {user, product};
}
