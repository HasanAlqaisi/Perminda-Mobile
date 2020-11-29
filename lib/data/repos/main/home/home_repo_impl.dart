// import 'package:perminda/core/network/network_info.dart';
// import 'package:perminda/data/db/relations/product/product_and_category_brand.dart';
// import 'package:perminda/data/db/relations/order_item/product_info.dart';
// import 'package:perminda/data/db/app_database/app_database.dart';
// import 'package:perminda/domain/repos/brands_repo.dart';
// import 'package:perminda/domain/repos/categories_repo.dart';
// import 'package:perminda/domain/repos/main/home_repo.dart';
// import 'package:perminda/domain/repos/packages_repo.dart';
// import 'package:perminda/domain/repos/shops_repo.dart';

// class HomeRepoImpl extends HomeRepo {
//   final NetWorkInfo netWorkInfo;
//   final ShopsRepo shopsRepo;
//   final CategoriesRepo categoriesRepo;
//   final BrandsRepo brandsRepo;
//   final PackagesRepo packagesRepo;

//   HomeRepoImpl({
//     this.netWorkInfo,
//     this.shopsRepo,
//     this.categoriesRepo,
//     this.brandsRepo,
//     this.packagesRepo,
//   });

//   @override
//   Stream<List<List<ProductAndCategoryAndBrandAndShop>>> getProducts() {
//     // TODO: implement getProducts
//     throw UnimplementedError();
//   }

//   @override
//   Stream<List<PackageData>> triggerPackages() {
//     shopsRepo.getShops();
//   }

//   @override
//   Stream<List<List<ProductAndCategoryAndBrandAndShop>>> triggerProducts() {
//     // TODO: implement triggerProducts
//     throw UnimplementedError();
//   }

//   @override
//   Stream<List<ProductInfo>> triggerProductsOfPackage(String packageId) {
//       // TODO: implement triggerProductsOfPackage
//       throw UnimplementedError();
//     }
  
//     @override
//     Stream<List<PackageData>> watchPackages() {
//       // TODO: implement watchPackages
//       throw UnimplementedError();
//     }
  
//     @override
//     Stream<List<ProductInfo>> watchProductsOfPackage(String packageId) {
//     // TODO: implement watchProductsOfPackage
//     throw UnimplementedError();
//   }

  
// }
