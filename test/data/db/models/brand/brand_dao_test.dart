import 'package:flutter_test/flutter_test.dart';
import 'package:moor_ffi/moor_ffi.dart';
import 'package:moor_flutter/moor_flutter.dart';
import 'package:perminda/data/db/app_database/app_database.dart';

/// No need to test moor library because all we gonna do is testing its already defind functions
/// and since we are inserting the data in a correct way, the result will always be correct
/// So, if we test it. Then, we are testing the data insertion and that's useless
/// And this file is an example...

void main() {
  AppDatabase appDatabase;
  final brandComp = BrandTableCompanion(
    id: Value('dada'),
    logo: Value('ex.com'),
    name: Value('Samsung'),
  );

  setUp(() {
    appDatabase = AppDatabase(VmDatabase.memory());
  });

  tearDown(() async {
    appDatabase.close();
  });

  test('should brand can be created', () async {
    await appDatabase.brandDao.insertBrand(brandComp);

    final brandResult = await appDatabase.brandDao.getBrands();
    final brandExpected =
        BrandData(id: 'dada', logo: 'ex.com', name: 'Samsung');

    expect(brandResult.first, brandExpected);
  });
}
