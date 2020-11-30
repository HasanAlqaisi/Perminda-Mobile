import 'package:moor_flutter/moor_flutter.dart';
import 'package:perminda/data/db/app_database/app_database.dart';
import 'package:perminda/data/db/models/product_image/product_image_dao.dart';

abstract class ProductImageLocalSource {
  Future<void> insertProductImages(
      List<ProductImageTableCompanion> productImages);
  Future<List<ProductImageData>> getProductImages(String productId);
  Future<int> deleteProductImageById(String productImageId);

  Future<int> deleteImagesOfProduct(String productId);
}

class ProductImageLocalSourceImpl extends ProductImageLocalSource {
  final ProductImageDao productImageDao;

  ProductImageLocalSourceImpl({this.productImageDao});

  @override
  Future<List<ProductImageData>> getProductImages(String productId) {
    return productImageDao.getProductImages(productId);
  }

  @override
  Future<void> insertProductImages(
      List<ProductImageTableCompanion> productImages) {
    try {
      return productImageDao.insertProductImages(productImages);
    } on InvalidDataException {
      rethrow;
    }
  }

  @override
  Future<int> deleteProductImageById(String productImageId) {
    return productImageDao.deleteProductImageById(productImageId);
  }

  @override
  Future<int> deleteImagesOfProduct(String productId) =>
      productImageDao.deleteProductImages(productId);
}
