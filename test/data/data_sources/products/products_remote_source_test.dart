import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:perminda/core/constants/sensetive_constants.dart';
import 'package:perminda/core/errors/exception.dart';
import 'package:http/http.dart' as http;
import 'package:perminda/data/data_sources/products/products_remote_source.dart';
import 'package:perminda/data/remote_models/products/products.dart';

import '../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  MockHttpClient client;
  ProductsRemoteSourceImpl remoteSource;
  const int limit = 10;
  int offset = 0;

  setUp(() {
    client = MockHttpClient();
    remoteSource = ProductsRemoteSourceImpl(client: client);
  });

  group('getProducts', () {
    final products = Products.fromJson(json.decode(fixture('products.json')));

    void do200Response() {
      when(client.get(
              '$baseUrl/api/product?limit=$limit&offset=$offset&shop=null&category=null&brand=null'))
          .thenAnswer(
              (_) async => http.Response(fixture('products.json'), 200));
    }

    test('should return [Products] if response code is 200', () async {
      do200Response();

      final result = await remoteSource.getProducts(offset, null, null, null);

      expect(result, products);
    });

    test('should throw [UnknownException] if response code is not expected',
        () {
      when(client.get(
              '$baseUrl/api/product?limit=$limit&offset=$offset&shop=null&category=null&brand=null'))
          .thenAnswer((_) async => http.Response(fixture('detail.json'), 500));

      final result = remoteSource.getProducts;

      expect(() => result(offset, null, null, null),
          throwsA(isA<UnknownException>()));
    });
  });
}
