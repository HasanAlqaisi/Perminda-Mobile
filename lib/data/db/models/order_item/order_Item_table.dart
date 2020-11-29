import 'package:moor_flutter/moor_flutter.dart';
import 'package:perminda/data/db/app_database/app_database.dart';
import 'package:perminda/data/remote_models/orders/results.dart';

@DataClassName('OrderItemData')
class OrderItemTable extends Table {
  TextColumn get id => text()();
  TextColumn get order =>
      text().customConstraint('REFERENCES order_table(id)')();
  TextColumn get product =>
      text().customConstraint('REFERENCES product_table(id)')();
  IntColumn get quantity => integer().withDefault(Constant(0))();

  @override
  String get tableName => 'order_item_table';

  @override
  Set<Column> get primaryKey => {id, order, product};

  static OrderItemTableCompanion fromOrdersResult(
      OrdersResult ordersResult, String product) {
    return OrderItemTableCompanion(
      id: Value(ordersResult.id),
      order: Value(ordersResult.id),
      product: Value(product),
      // quantity: Value(result.quantity),
    );
  }
}
