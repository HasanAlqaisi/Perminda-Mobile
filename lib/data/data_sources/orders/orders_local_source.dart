import 'package:moor_flutter/moor_flutter.dart';
import 'package:perminda/data/db/app_database/app_database.dart';
import 'package:perminda/data/db/models/order/order_dao.dart';
import 'package:perminda/data/db/models/order_item/order_item_dao.dart';
import 'package:perminda/data/db/relations/order_item/order_with_products.dart';

abstract class OrdersLocalSource {
  Future<int> insertOrder(OrderTableCompanion order);
  Future<int> insertOrderItem(OrderItemTableCompanion order);
  Stream<Future<List<OrderWithProducts>>> watchOrders(String userId);
}

class OrdersLocalSourceImpl extends OrdersLocalSource {
  final OrderDao orderDao;
  final OrderItemDao orderItemDao;

  OrdersLocalSourceImpl({this.orderDao, this.orderItemDao});

  @override
  Future<int> insertOrder(OrderTableCompanion order) {
    try {
      return orderDao.insertOrder(order);
    } on InvalidDataException {
      rethrow;
    }
  }

  @override
  Future<int> insertOrderItem(OrderItemTableCompanion order) {
    try {
      return orderItemDao.insertOrderItem(order);
    } on InvalidDataException {
      rethrow;
    }
  }

  @override
  Stream<Future<List<OrderWithProducts>>> watchOrders(String userId) {
    return orderItemDao.watchOrders(userId);
  }
}
