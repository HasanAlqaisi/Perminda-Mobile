import 'package:perminda/core/api_helpers/api.dart';
import 'package:perminda/core/errors/exception.dart';
import 'package:perminda/core/network/network_info.dart';
import 'package:perminda/data/data_sources/products/products_local_source.dart';
import 'package:perminda/data/data_sources/products/products_remote_source.dart';
import 'package:perminda/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:perminda/data/db/app_database/app_database.dart';
import 'package:perminda/data/db/models/product/product_table.dart';
import 'package:perminda/data/remote_models/products/results.dart';
import 'package:perminda/domain/repos/products_repo.dart';

class ProductsRepoImpl extends ProductsRepo {
  final NetWorkInfo netWorkInfo;
  final ProductsRemoteSource remoteSource;
  final ProductsLocalSource localSource;
  int offset = 0;

  ProductsRepoImpl({this.netWorkInfo, this.remoteSource, this.localSource});

  @override
  Future<Either<Failure, List<ProductsResult>>> getProducts(
      String shopId, String categoryId, String brandId) async {
    if (await netWorkInfo.isConnected()) {
      try {
        final products = await remoteSource.getProducts(
            this.offset, shopId, categoryId, brandId);

        if (this.offset == 0) localSource.deleteProducts();

        await localSource
            .insertProducts(ProductTable.fromProductsesult(products.results));

        int offset = API.offsetExtractor(products.nextPage);

        cacheOffset(offset);

        return Right(products.results);
      } on UnknownException catch (error) {
        print(error.message);
        return Left(UnknownFailure());
      }
    } else {
      return Left(NoInternetFailure());
    }
  }

  void cacheOffset(int offset) {
    this.offset = offset;
  }

  @override
  Stream<List<ProductData>> watchProductsByCategory(String categoryId) => localSource.watchProductsByCategoryId(categoryId);
  
}
