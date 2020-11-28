import 'package:moor_flutter/moor_flutter.dart';
import 'package:perminda/data/db/app_database/app_database.dart';
import 'package:perminda/data/db/models/brand/brand_dao.dart';

abstract class BrandLocalSource {
  Future<int> insertBrand(BrandTableCompanion brand);

  Future<List<BrandData>> getBrands();

  Stream<List<BrandData>> watchBrands();

  Future<BrandData> getBrandById(String brandId);
}

class BrandLocalSourceImpl extends BrandLocalSource {
  final BrandDao brandDao;

  BrandLocalSourceImpl({this.brandDao});

  @override
  Future<BrandData> getBrandById(String brandId) {
    return brandDao.getBrandById(brandId);
  }

  @override
  Future<List<BrandData>> getBrands() {
    return brandDao.getBrands();
  }

  @override
  Future<int> insertBrand(BrandTableCompanion brand) {
    try {
      return brandDao.insertBrand(brand);
    } on InvalidDataException {
      rethrow;
    }
  }

  @override
  Stream<List<BrandData>> watchBrands() {
    return brandDao.watchBrands();
  }
}
