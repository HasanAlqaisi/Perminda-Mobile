import 'package:moor_flutter/moor_flutter.dart';

@DataClassName('OrderItemData')
class OrderItemTable extends Table {
  TextColumn get order =>
      text().customConstraint('REFERENCES order_table(id)')();
  TextColumn get product =>
      text().customConstraint('REFERENCES product_table(id)')();

  @override
  String get tableName => 'order_item_table';

  @override
  Set<Column> get primaryKey => {order, product};
}
