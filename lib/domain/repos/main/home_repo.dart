import 'package:perminda/data/db/app_database/app_database.dart';
import 'package:perminda/data/db/relations/order_item/product_info.dart';
import 'package:perminda/data/db/relations/product/product_and_category_brand.dart';

abstract class HomeRepo {
  Stream<List<PackageData>> triggerPackages();

  Stream<List<PackageData>> watchPackages();

  Stream<List<ProductInfo>> triggerProductsOfPackage(String packageId);

  Stream<List<ProductInfo>> watchProductsOfPackage(String packageId);

  /// List of [List of products in one category]
  Stream<List<List<ProductAndCategoryAndBrandAndShop>>> triggerProducts();

  /// List of [List of products in one category]
  Stream<List<List<ProductAndCategoryAndBrandAndShop>>> getProducts();
}
