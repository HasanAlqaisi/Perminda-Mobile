import 'package:moor_flutter/moor_flutter.dart';
import 'package:perminda/data/db/app_database/app_database.dart';
import 'package:perminda/data/db/models/cart_item/cart_item_table.dart';
import 'package:perminda/data/db/models/product/product_table.dart';
import 'package:perminda/data/db/models/user/user_table.dart';
import 'package:perminda/data/db/relations/cart_item/user_with_cartItems_and_products.dart';

part 'cart_item_dao.g.dart';

@UseDao(tables: [CartItemTable, UserTable, ProductTable])
class CartItemDao extends DatabaseAccessor<AppDatabase>
    with _$CartItemDaoMixin {
  CartItemDao(AppDatabase db) : super(db);

  Future<int> insertCartItem(CartItemTableCompanion cartItem) =>
      into(cartItemTable).insert(cartItem, mode: InsertMode.insertOrReplace);

  Stream<Future<List<Future<CartItemAndProduct>>>> watchCartItems(
      String userId) {
    return (select(cartItemTable)
          ..where((cartItemTable) => cartItemTable.user.equals(userId)))
        .join([
          innerJoin(
              productTable, productTable.id.equalsExp(cartItemTable.product)),
        ])
        .watch()
        .map((rows) async => rows.map((row) async {
              final productRow = row.readTable(productTable);
              return CartItemAndProduct(
                  cartItem: row.readTable(cartItemTable),
                  product: productRow,
                  category:
                      await db.categoryDao.getCategoryById(productRow.category),
                  brand: await db.brandDao.getBrandById(productRow.brand),
                  shop: await db.shopDao.getShopById(productRow.shop));
            }).toList());
  }
}
