import 'package:moor_flutter/moor_flutter.dart';
import 'package:perminda/data/db/app_database/app_database.dart';
import 'package:perminda/data/db/models/order/order_table.dart';

part 'order_dao.g.dart';

@UseDao(tables: [OrderTable])
class OrderDao extends DatabaseAccessor<AppDatabase> with _$OrderDaoMixin {
  OrderDao(AppDatabase db) : super(db);

  Future<int> insertOrder(OrderTableCompanion order) =>
      into(orderTable).insert(order, mode: InsertMode.insertOrReplace);
}
