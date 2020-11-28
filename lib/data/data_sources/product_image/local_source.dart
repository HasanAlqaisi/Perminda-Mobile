import 'package:moor_flutter/moor_flutter.dart';
import 'package:perminda/data/db/app_database/app_database.dart';
import 'package:perminda/data/db/models/product_image/product_image_dao.dart';

abstract class ProductImageLocalSource {
  Future<int> insertProductImage(ProductImageTableCompanion productImage);
  Future<List<ProductImageData>> getProductImages(String productId);
}

class ProductImageLocalSourceImpl extends ProductImageLocalSource {
  final ProductImageDao productImageDao;

  ProductImageLocalSourceImpl({this.productImageDao});

  @override
  Future<List<ProductImageData>> getProductImages(String productId) {
    return productImageDao.getProductImages(productId);
  }

  @override
  Future<int> insertProductImage(ProductImageTableCompanion productImage) {
    try {
      return productImageDao.insertProductImage(productImage);
    } on InvalidDataException {
      rethrow;
    }
  }
}
