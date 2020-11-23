import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:perminda/core/api_helpers/api.dart';
import 'package:perminda/core/constants/sensetive_constants.dart';
import 'package:perminda/core/errors/exception.dart';
import 'package:http/http.dart' as http;
import 'package:perminda/data/data_sources/orders/orders_remote_source.dart';
import 'package:perminda/data/remote_models/orders/orders.dart';
import 'package:perminda/data/remote_models/orders/results.dart';

import '../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  MockHttpClient client;
  OrdersRemoteSourceImpl remoteSource;
  int offset = 0;

  final orders = Orders.fromJson(json.decode(fixture('orders.json')));

  final order = OrdersResult.fromJson(json.decode(fixture('order.json')));

  setUp(() {
    client = MockHttpClient();
    remoteSource = OrdersRemoteSourceImpl(client: client);
  });

  group('addOrder', () {
    void do201Response(String url) {
      when(client.post(url,
              headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer((_) async => http.Response(fixture('order.json'), 201));
    }

    test('should return [OrdersResult] if response code is 201', () async {
      do201Response(API.orderUrlProvider([]));

      final result = await remoteSource.addOrder(null, []);

      expect(result, order);
    });

    test('should throw [UnauthorizedTokenException] if response code is 401',
        () {
      when(client.post(API.orderUrlProvider([]),
              headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer((_) async => http.Response(fixture('order.json'), 401));

      final result = remoteSource.addOrder;

      expect(
          () => result(null, []), throwsA(isA<UnauthorizedTokenException>()));
    });

    test('should throw [FieldsException] if response code is 400', () {
      when(client.post(API.orderUrlProvider([]),
              headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer((_) async => http.Response(fixture('order.json'), 400));

      final result = remoteSource.addOrder;

      expect(() => result(null, []), throwsA(isA<FieldsException>()));
    });

    test('should throw [UnknownException] if response code is not expected',
        () {
      when(client.post(API.orderUrlProvider([]),
              headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer((_) async => http.Response(fixture('order.json'), 500));

      final result = remoteSource.addOrder;

      expect(() => result(null, []), throwsA(isA<UnknownException>()));
    });
  });

  group('editOrder', () {
    void do200Response() {
      when(client.put('$baseUrl/api/order/',
              headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer((_) async => http.Response(fixture('order.json'), 200));
    }

    test('should return [OrdersResult] if response code is 200', () async {
      do200Response();

      final result = await remoteSource.editOrder(null, null);

      expect(result, order);
    });

    test('should throw [UnauthorizedTokenException] if response code is 401',
        () {
      when(client.put('$baseUrl/api/order/',
              headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer((_) async => http.Response(fixture('order.json'), 401));

      final result = remoteSource.editOrder;

      expect(
          () => result(null, null), throwsA(isA<UnauthorizedTokenException>()));
    });

    test('should throw [FieldsException] if response code is 400', () {
      when(client.put('$baseUrl/api/order/',
              headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer((_) async => http.Response(fixture('order.json'), 400));

      final result = remoteSource.editOrder;

      expect(() => result(null, null), throwsA(isA<FieldsException>()));
    });

    test('should throw [ItemNotFoundException] if response code is 404', () {
      when(client.put('$baseUrl/api/order/',
              headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer((_) async => http.Response(fixture('order.json'), 404));

      final result = remoteSource.editOrder;

      expect(() => result(null, null), throwsA(isA<ItemNotFoundException>()));
    });

    test('should throw [UnknownException] if response code is not expected',
        () {
      when(client.put('$baseUrl/api/order/',
              headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer((_) async => http.Response(fixture('order.json'), 500));

      final result = remoteSource.editOrder;

      expect(() => result(null, null), throwsA(isA<UnknownException>()));
    });
  });

  group('getOrders', () {
    void do200Response() {
      when(client.get('$baseUrl/api/order?limit=10&offset=$offset',
              headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(fixture('orders.json'), 200));
    }

    test('should return [Orders] if response code is 200', () async {
      do200Response();

      final result = await remoteSource.getOrders(offset);

      expect(result, orders);
    });

    test('should throw [UnauthorizedTokenException] if response code is 401',
        () {
      when(client.get('$baseUrl/api/order?limit=10&offset=$offset',
              headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(fixture('order.json'), 401));

      final result = remoteSource.getOrders;

      expect(() => result(offset), throwsA(isA<UnauthorizedTokenException>()));
    });

    test('should throw [UnknownException] if response code is not expected',
        () {
      when(client.get('$baseUrl/api/order?limit=10&offset=$offset',
              headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(fixture('order.json'), 500));

      final result = remoteSource.getOrders;

      expect(() => result(offset), throwsA(isA<UnknownException>()));
    });
  });
}
