import 'package:perminda/core/errors/failure.dart';
import 'package:perminda/core/network/network_info.dart';
import 'package:perminda/data/db/relations/order_item/product_info.dart';
import 'package:perminda/data/db/app_database/app_database.dart';
import 'package:perminda/domain/repos/brands_repo.dart';
import 'package:perminda/domain/repos/categories_repo.dart';
import 'package:perminda/domain/repos/main/home_repo.dart';
import 'package:perminda/domain/repos/packages_repo.dart';
import 'package:perminda/domain/repos/products_repo.dart';
import 'package:perminda/domain/repos/shops_repo.dart';

/// in UI, try to listen to the categoires and products separately
class HomeRepoImpl extends HomeRepo {
  final NetWorkInfo netWorkInfo;
  final ShopsRepo shopsRepo;
  final CategoriesRepo categoriesRepo;
  final BrandsRepo brandsRepo;
  final PackagesRepo packagesRepo;
  final ProductsRepo productsRepo;

  HomeRepoImpl({
    this.netWorkInfo,
    this.shopsRepo,
    this.categoriesRepo,
    this.brandsRepo,
    this.packagesRepo,
    this.productsRepo,
  });

  @override
  Stream<List<PackageData>> watchPackages() => packagesRepo.watchPackages();

  @override
  Stream<Future<List<ProductInfo>>> watchProductsOfPackage(String packageId) =>
      packagesRepo.watchProductsOfPackage(packageId);

  @override
  Future<Failure> triggerPackages() async {
    if (await netWorkInfo.isConnected()) {
      final result = await packagesRepo.getPackages();
      return result.fold((failure) => failure, (_) => null);
    } else {
      return NoInternetFailure();
    }
  }

  /// This call will bring every category with its products
  /// but, if you need detailed info about a specific product
  /// you have to make the API calls when the user clicks on that product
  @override
  // Future<Failure> triggerProducts() async {
  //   if (await netWorkInfo.isConnected()) {
  //     final categories = await categoriesRepo.getCategories();
  //     return categories.fold((categoryFailure) => categoryFailure,
  //         (categories) async {
  //       Failure fail;
  //       for (final category in categories.results) {
  //         if (fail != null) break;
  //         final product =
  //             await productsRepo.getProducts(null, category.id, null);
  //         product.fold((failure) {
  //           fail = failure;
  //         }, (_) => null);
  //       }
  //       return fail;
  //     });
  //   }
  // }

  Future<Failure> triggerProductsByCategory(String categoryId) async {
    if (await netWorkInfo.isConnected()) {
      final products = await productsRepo.getProducts(null, categoryId, null);
      return products.fold((failure) => failure, (_) => null);
    } else {
      return NoInternetFailure();
    }
  }

  @override
  Future<Failure> triggerCategories() async {
    if (await netWorkInfo.isConnected()) {
      final categories = await categoriesRepo.getCategories();
      return categories.fold((failure) => failure, (_) => null);
    } else {
      return NoInternetFailure();
    }
  }

  @override
  Stream<List<ProductData>> watchProductsByCategory(String categoryId) =>
      productsRepo.watchProductsByCategory(categoryId);

  @override
  Stream<List<CategoryData>> watchCategories() =>
      categoriesRepo.watchCategories();
}
