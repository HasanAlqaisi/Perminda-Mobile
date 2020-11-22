import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:perminda/core/constants/sensetive_constants.dart';
import 'package:perminda/core/errors/exception.dart';
import 'package:perminda/data/data_sources/brands/remote_source.dart';
import 'package:perminda/data/remote_models/brands/brands.dart';
import 'package:perminda/data/remote_models/brands/results.dart';

import '../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  MockHttpClient client;
  BrandsRemoteSourceImpl remoteSource;
  const int limit = 10;
  int offset = 0;

  setUp(() {
    client = MockHttpClient();
    remoteSource = BrandsRemoteSourceImpl(client: client);
  });

  group('getBrands', () {
    final brands = Brands.fromJson(json.decode(fixture('brands.json')));

    test('should return list of [Brand] if response code is 200', () async {
      when(client.get('$baseUrl/api/brand?limit=$limit&offset=$offset'))
          .thenAnswer((_) async => http.Response(fixture('brands.json'), 200));

      final result = await remoteSource.getBrands(offset);

      expect(result, brands);
    });

    test('should throw [UnknownException] if response code is NOT 200',
        () async {
      when(client.get('$baseUrl/api/brand?limit=$limit&offset=$offset'))
          .thenAnswer((_) async => http.Response(fixture('detail.json'), 404));

      final result = remoteSource.getBrands;

      expect(() => result(offset), throwsA(isA<UnknownException>()));
    });
  });

  group('getBrandById', () {
    final brand = BrandsResult.fromJson(json.decode(fixture('brand.json')));
    final id = 'a7533fbf-5ab6-41a9-b110-42ac54d71def';

    test('should return [Brand] if response code is 200', () async {
      when(client.get('$baseUrl/api/brand/$id/'))
          .thenAnswer((_) async => http.Response(fixture('brand.json'), 200));

      final result = await remoteSource.getBrandById(id);

      expect(result, brand);
    });

    test('should throw [ItemNotFoundException] if response code is 404',
        () async {
      when(client.get('$baseUrl/api/brand/$id/'))
          .thenAnswer((_) async => http.Response(fixture('detail.json'), 404));

      final result = remoteSource.getBrandById;

      expect(() => result(id), throwsA(isA<ItemNotFoundException>()));
    });

    test(
        'should throw [UnknownException] if response code is neither 200 nor 404',
        () async {
      when(client.get('$baseUrl/api/brand/$id/'))
          .thenAnswer((_) async => http.Response(fixture('detail.json'), 400));

      final result = remoteSource.getBrandById;

      expect(() => result(id), throwsA(isA<UnknownException>()));
    });
  });
}
