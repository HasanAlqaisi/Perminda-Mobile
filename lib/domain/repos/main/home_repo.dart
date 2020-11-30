import 'package:perminda/core/errors/failure.dart';
import 'package:perminda/data/db/app_database/app_database.dart';
import 'package:perminda/data/db/relations/order_item/product_info.dart';

abstract class HomeRepo {
  Future<Failure> triggerPackages();

  Stream<List<PackageData>> watchPackages();

  Stream<Future<List<ProductInfo>>> watchProductsOfPackage(String packageId);

  Future<Failure> triggerCategories();

  Stream<List<CategoryData>> watchCategories();

  /// List of [List of products in one category]
  Future<Failure> triggerProductsByCategory(String categoryId);

  Stream<List<ProductData>> watchProductsByCategory(String categoryId);

  // /// List of [List of products in one category]
  // Stream<List<List<ProductAndCategoryAndBrandAndShop>>>
  //     watchCategoiesWithProducts();
}
