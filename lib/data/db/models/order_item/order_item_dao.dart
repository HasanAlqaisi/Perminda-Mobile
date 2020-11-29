import 'package:moor_flutter/moor_flutter.dart';
import 'package:perminda/data/db/app_database/app_database.dart';
import 'package:perminda/data/db/models/order/order_table.dart';
import 'package:perminda/data/db/models/order_item/order_Item_table.dart';
import 'package:perminda/data/db/models/product/product_table.dart';
import 'package:perminda/data/db/relations/order_item/order_with_products.dart';
import 'package:perminda/data/db/relations/order_item/product_info.dart';
import 'package:perminda/data/remote_models/orders/results.dart';
import 'package:rxdart/rxdart.dart';

part 'order_item_dao.g.dart';

@UseDao(tables: [OrderItemTable, ProductTable, OrderTable])
class OrderItemDao extends DatabaseAccessor<AppDatabase>
    with _$OrderItemDaoMixin {
  OrderItemDao(AppDatabase db) : super(db);

  Future<void> insertOrderItems(List<OrdersResult> orders) async {
    await batch((batch) async {
      orders.forEach(
        (order) => order.products.forEach(
          (product) => batch.insert(
            orderItemTable,
            OrderItemTable.fromOrdersResult(order, product),
            mode: InsertMode.insertOrReplace,
          ),
        ),
      );
    });
  }

  Stream<Future<List<OrderWithProducts>>> watchOrders(String userId) {
    final orderStream =
        (select(orderTable)..where((tbl) => tbl.user.equals(userId))).watch();

    return orderStream.switchMap((orders) {
      final idToOrder = {for (var order in orders) order.id: order};
      final ids = idToOrder.keys;

      final entryQuery = select(orderItemTable).join(
        [
          innerJoin(
              productTable, productTable.id.equalsExp(orderItemTable.product)),
        ],
      )..where(orderItemTable.order.isIn(ids));

      return entryQuery.watch().map((rows) async {
        final idToProducts = <String, List<ProductInfo>>{};

        for (var row in rows) {
          final productRow = row.readTable(productTable);

          final product = productRow;
          final id = row.readTable(orderItemTable).order;
          final category =
              await db.categoryDao.getCategoryById(productRow.category);
          final brand = await db.brandDao.getBrandById(productRow.brand);
          final shop = await db.shopDao.getShopById(productRow.shop);

          final productInfo = ProductInfo(
            product: product,
            brand: brand,
            shop: shop,
            category: category,
          );

          idToProducts.putIfAbsent(id, () => []).add(productInfo);
        }

        return [
          for (var id in ids)
            OrderWithProducts(
                order: idToOrder[id], products: idToProducts[id] ?? []),
        ];
      });
    });
  }

  Future<int> deleteOrderItems() => delete(orderItemTable).go();

  Future<int> deleteOrderItemById(String orderItemId) =>
      (delete(orderItemTable)..where((tbl) => tbl.id.equals(orderItemId))).go();
}
