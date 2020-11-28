import 'package:moor_flutter/moor_flutter.dart';
import 'package:perminda/data/db/models/brand/brand_table.dart';
import 'package:perminda/data/db/models/cart_item/cart_item_dao.dart';
import 'package:perminda/data/db/models/cart_item/cart_item_table.dart';
import 'package:perminda/data/db/models/category/category_dao.dart';
import 'package:perminda/data/db/models/category/category_table.dart';
import 'package:perminda/data/db/models/favourite_item/favourite_item_dao.dart';
import 'package:perminda/data/db/models/favourite_item/favourite_item_table.dart';
import 'package:perminda/data/db/models/order/order_dao.dart';
import 'package:perminda/data/db/models/order/order_table.dart';
import 'package:perminda/data/db/models/order_item/order_Item_table.dart';
import 'package:perminda/data/db/models/order_item/order_item_dao.dart';
import 'package:perminda/data/db/models/product/product_dao.dart';
import 'package:perminda/data/db/models/product/product_table.dart';
import 'package:perminda/data/db/models/product_image/product_image_dao.dart';
import 'package:perminda/data/db/models/product_image/product_image_table.dart';
import 'package:perminda/data/db/models/review/review_dao.dart';
import 'package:perminda/data/db/models/review/review_table.dart';
import 'package:perminda/data/db/models/shop/shop_dao.dart';
import 'package:perminda/data/db/models/shop/shop_table.dart';
import 'package:perminda/data/db/models/user/user_dao.dart';
import 'package:perminda/data/db/models/user/user_table.dart';
import 'package:perminda/data/db/models/user_notification/notification_table.dart';
import 'package:perminda/data/db/models/brand/brand_dao.dart';
import 'package:perminda/data/db/models/user_notification/user_notification_dao.dart';

part 'app_database.g.dart';

@UseMoor(
  tables: [
    BrandTable,
    CartItemTable,
    CategoryTable,
    FavouriteItemTable,
    OrderTable,
    OrderItemTable,
    ProductTable,
    ProductImageTable,
    ReviewTable,
    ShopTable,
    UserTable,
    UserNotificationTable,
  ],
  daos: [
    BrandDao,
    CartItemDao,
    CategoryDao,
    ShopDao,
    ProductDao,
    UserDao,
    FavouriteItemDao,
    UserNotificationDao,
    ReviewDao,
    ProductImageDao,
    OrderDao,
    OrderItemDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(QueryExecutor q) : super(q);

  @override
  int get schemaVersion => 1;
}
