import 'package:moor_flutter/moor_flutter.dart';
import 'package:perminda/data/db/app_database/app_database.dart';
import 'package:perminda/data/db/models/order/order_table.dart';

part 'order_dao.g.dart';

@UseDao(tables: [OrderTable])
class OrderDao extends DatabaseAccessor<AppDatabase> with _$OrderDaoMixin {
  OrderDao(AppDatabase db) : super(db);

  Future<void> insertOrders(List<OrderTableCompanion> orders) async {
    await batch((batch) {
      batch.insertAllOnConflictUpdate(orderTable, orders);
    });
  }

  Future<int> deleteOrders() => delete(orderTable).go();

  Future<int> deleteOrderById(String orderId) =>
      (delete(orderTable)..where((tbl) => tbl.id.equals(orderId))).go();
}
