import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:http/http.dart' as http;
import 'package:perminda/core/constants/sensetive_constants.dart';
import 'package:perminda/core/errors/exception.dart';
import 'package:perminda/data/data_sources/shops/shops_remote_source.dart';
import 'package:perminda/data/remote_models/shops/results.dart';
import 'package:perminda/data/remote_models/shops/shops.dart';

import '../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  MockHttpClient client;
  ShopsRemoteSourceImpl shopsRemoteSource;
  const int limit = 10;
  int offset = 0;

  setUp(() {
    client = MockHttpClient();
    shopsRemoteSource = ShopsRemoteSourceImpl(client: client);
  });

  group('getShops', () {
    final shops = Shops.fromJson(json.decode(fixture('shops.json')));

    test('should return list of [Shop] when response code is 200', () async {
      when(client.get(
        '$baseUrl/api/shop?limit=$limit&offset=$offset',
      )).thenAnswer((_) async => http.Response(fixture('shops.json'), 200));

      final result = await shopsRemoteSource.getShops(offset);

      expect(result, shops);
    });

    test('should throw [UnknownException] when response code is not 200',
        () async {
      when(client.get(
        '$baseUrl/api/shop?limit=$limit&offset=$offset',
      )).thenThrow(UnknownException(message: ''));

      final result = shopsRemoteSource.getShops;

      expect(result(offset), throwsA(isA<UnknownException>()));
    });
  });

  group('getShopById', () {
    final shop = ShopsResult.fromJson(json.decode(fixture('shop.json')));
    test('should return shop when resposne code is 200', () async {
      when(client.get('$baseUrl/api/shop/${shop.id}'))
          .thenAnswer((_) async => http.Response(fixture('shop.json'), 200));

      final result = await shopsRemoteSource.getShopById(shop.id);

      expect(result, shop);
    });

    test('should throw [ItemNotFoundException] when response code is 404',
        () async {
      when(client.get(
        '$baseUrl/api/shop/${shop.id}',
      )).thenAnswer((_) async => http.Response(fixture('detail.json'), 404));

      final result = shopsRemoteSource.getShopById;

      expect(result(shop.id), throwsA(isA<ItemNotFoundException>()));
    });
    test(
        'should throw [UnknownException] when response code is neither 200 nor 404',
        () async {
      when(client.get(
        '$baseUrl/api/shop/${shop.id}',
      )).thenAnswer((_) async => http.Response(fixture('detail.json'), 400));
      // .thenThrow(UnknownException(message: ''));

      final result = shopsRemoteSource.getShopById;

      expect(result(shop.id), throwsA(isA<UnknownException>()));
    });
  });
}
