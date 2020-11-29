import 'package:moor_flutter/moor_flutter.dart';
import 'package:perminda/data/db/app_database/app_database.dart';
import 'package:perminda/data/db/models/order/order_dao.dart';
import 'package:perminda/data/db/models/order_item/order_item_dao.dart';
import 'package:perminda/data/db/relations/order_item/order_with_products.dart';
import 'package:perminda/data/remote_models/orders/results.dart';

abstract class OrdersLocalSource {
  Future<void> insertOrders(List<OrderTableCompanion> orders);
  Future<void> insertOrderItems(List<OrdersResult> orders);
  Stream<Future<List<OrderWithProducts>>> watchOrders(String userId);
  Future<int> deleteOrderId(String orderId);
  Future<int> deleteOrderItemId(String orderItemId);
}

class OrdersLocalSourceImpl extends OrdersLocalSource {
  final OrderDao orderDao;
  final OrderItemDao orderItemDao;

  OrdersLocalSourceImpl({this.orderDao, this.orderItemDao});

  @override
  Future<void> insertOrders(List<OrderTableCompanion> orders) {
    try {
      return orderDao.insertOrders(orders);
    } on InvalidDataException {
      rethrow;
    }
  }

  @override
  Future<void> insertOrderItems(List<OrdersResult> orders) {
    try {
      return orderItemDao.insertOrderItems(orders);
    } on InvalidDataException {
      rethrow;
    }
  }

  @override
  Stream<Future<List<OrderWithProducts>>> watchOrders(String userId) {
    return orderItemDao.watchOrders(userId);
  }

  @override
  Future<int> deleteOrderId(String orderId) {
    return orderDao.deleteOrderById(orderId);
  }

  @override
  Future<int> deleteOrderItemId(String orderItemId) {
    return orderItemDao.deleteOrderItemById(orderItemId);
  }
}
