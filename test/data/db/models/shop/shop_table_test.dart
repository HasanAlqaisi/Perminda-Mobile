import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:moor_flutter/moor_flutter.dart';
import 'package:perminda/data/db/app_database/app_database.dart';
import 'package:perminda/data/db/models/shop/shop_table.dart';
import 'package:perminda/data/remote_models/shops/results.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final shopsResult = ShopsResult.fromJson(json.decode(fixture('shop.json')));
  test('should convert shopsResult to db model in a correct way', () {
    final result = ShopTable.fromShopsResult([shopsResult]);

    final expectedResult = [
      ShopTableCompanion(
        id: Value('3fa85f64-5717-4562-b3fc-2c963f66afa6'),
        user: Value('3fa85f64-5717-4562-b3fc-2c963f66afa6'),
        name: Value('string'),
        dateCreated: Value(DateTime.tryParse('2020-11-22T16:34:15.107Z')),
      ),
    ];
    
    expect(result, expectedResult);
  });
}
