import 'package:moor_flutter/moor_flutter.dart';
import 'package:perminda/data/db/app_database/app_database.dart';
import 'package:perminda/data/db/models/product/product_dao.dart';
import 'package:perminda/data/db/relations/product/product_and_category_brand.dart';

abstract class ProductsLocalSource {
  Future<int> insertProduct(ProductTableCompanion product);

  Stream<List<ProductAndCategoryAndBrandAndShop>> watchProductsByShopId(
      String shopId);

  Stream<List<ProductAndCategoryAndBrandAndShop>> watchProductsByCategoryId(
      String categoryId);

  Stream<List<ProductAndCategoryAndBrandAndShop>> watchProductsByBrandId(
      String brandId);
}

class ProductsLocalSourceImpl extends ProductsLocalSource {
  final ProductDao productDao;

  ProductsLocalSourceImpl({this.productDao});

  @override
  Future<int> insertProduct(ProductTableCompanion product) {
    try {
      return productDao.insertProduct(product);
    } on InvalidDataException {
      rethrow;
    }
  }

  @override
  Stream<List<ProductAndCategoryAndBrandAndShop>> watchProductsByBrandId(
      String brandId) {
    return productDao.watchProductsByBrandId(brandId);
  }

  @override
  Stream<List<ProductAndCategoryAndBrandAndShop>> watchProductsByCategoryId(
      String categoryId) {
    return productDao.watchProductsByCategoryId(categoryId);
  }

  @override
  Stream<List<ProductAndCategoryAndBrandAndShop>> watchProductsByShopId(
      String shopId) {
    return productDao.watchProductsByShopId(shopId);
  }
}
