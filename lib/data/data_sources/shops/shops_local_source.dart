import 'package:moor_flutter/moor_flutter.dart';
import 'package:perminda/data/db/app_database/app_database.dart';
import 'package:perminda/data/db/models/shop/shop_dao.dart';

abstract class ShopsLocalSource {
  Future<void> insertShops(List<ShopTableCompanion> shop);
  Future<ShopData> getShopById(String shopId);
  Stream<ShopData> watchShopById(String shopId);
  Stream<List<ShopData>> watchShops();
  Future<int> deleteShopById(String shopId);
  Future<int> deleteShops();
}

class ShopsLocalSourceImpl extends ShopsLocalSource {
  final ShopDao shopDao;

  ShopsLocalSourceImpl({this.shopDao});

  @override
  Future<ShopData> getShopById(String shopId) {
    return shopDao.getShopById(shopId);
  }

  @override
  Future<void> insertShops(List<ShopTableCompanion> shops) {
    try {
      return shopDao.insertShops(shops);
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

  @override
  Future<int> deleteShopById(String shopId) {
    return shopDao.deleteShopById(shopId);
  }

  @override
  Future<int> deleteShops() => shopDao.deleteShops();
}
