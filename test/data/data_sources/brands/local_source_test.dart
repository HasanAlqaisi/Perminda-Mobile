import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:moor_flutter/moor_flutter.dart';
import 'package:perminda/data/data_sources/brands/local_source.dart';
import 'package:perminda/data/db/models/brand/brand_dao.dart';

import '../../db/dummy_models.dart';

class MockBrandDao extends Mock implements BrandDao {}

void main() {
  MockBrandDao brandDao;
  BrandLocalSourceImpl brandLocal;

  setUp(() {
    brandDao = MockBrandDao();
    brandLocal = BrandLocalSourceImpl(brandDao: brandDao);
  });

  group('insertBrand', () {
    test('should throw [InvalidDataException] otherwise', () {
      when(brandDao.insertBrands([DummyModels.brand1]))
          .thenThrow(InvalidDataException(''));

      final result = brandLocal.insertBrands;

      expect(() => result([DummyModels.brand1]),
          throwsA(isA<InvalidDataException>()));
    });
  });
}
