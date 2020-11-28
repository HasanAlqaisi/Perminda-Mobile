import 'package:moor_flutter/moor_flutter.dart';
import 'package:perminda/data/db/app_database/app_database.dart';
import 'package:perminda/data/db/models/shop/shop_dao.dart';

abstract class ShopsLocalSource {
  Future<int> insertShop(ShopTableCompanion shop);
  Future<ShopData> getShopById(String shopId);
  Stream<ShopData> watchShopById(String shopId);
  Stream<List<ShopData>> watchShops();
}

class ShopsLocalSourceImpl extends ShopsLocalSource {
  final ShopDao shopDao;

  ShopsLocalSourceImpl({this.shopDao});

  @override
  Future<ShopData> getShopById(String shopId) {
    return shopDao.getShopById(shopId);
  }

  @override
  Future<int> insertShop(ShopTableCompanion shop) {
    try {
      return shopDao.insertShop(shop);
    } on InvalidDataException {
      rethrow;
    }
  }

  @override
  Stream<ShopData> watchShopById(String shopId) {
    return shopDao.watchShopById(shopId);
  }

  @override
  Stream<List<ShopData>> watchShops() {
    return shopDao.watchShops();
  }
}
