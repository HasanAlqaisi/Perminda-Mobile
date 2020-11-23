import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:perminda/core/constants/sensetive_constants.dart';
import 'package:perminda/core/errors/exception.dart';
import 'package:http/http.dart' as http;
import 'package:perminda/data/data_sources/cart_items/cart_items_remote_source.dart';
import 'package:perminda/data/remote_models/cart_items/cart_items.dart';
import 'package:perminda/data/remote_models/cart_items/results.dart';

import '../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  MockHttpClient client;
  CartItemsRemoteSourceImpl remoteSource;

  const int limit = 10;
  int offset = 0;

  final cartItem =
      CartItemsResult.fromJson(json.decode(fixture('cart_item.json')));

  final cartItems = CartItems.fromJson(json.decode(fixture('cart_items.json')));

  setUp(() {
    client = MockHttpClient();
    remoteSource = CartItemsRemoteSourceImpl(client: client);
  });

  group('addCartItem', () {
    void do201Response() {
      when(client.post('$baseUrl/api/cart-item/',
              headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer(
              (_) async => http.Response(fixture('cart_item.json'), 201));
    }

    test('should return [CartItemsResult] if response code is 201', () async {
      do201Response();

      final result = await remoteSource.addCartItem(null, null);

      expect(result, cartItem);
    });

    test('should throw [UnauthorizedTokenException] if response code is 401',
        () {
      when(client.post('$baseUrl/api/cart-item/',
              headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer((_) async => http.Response(fixture('detail.json'), 401));

      final result = remoteSource.addCartItem;

      expect(
          () => result(null, null), throwsA(isA<UnauthorizedTokenException>()));
    });

    test('should throw [FieldsException] if response code is 400', () {
      when(client.post('$baseUrl/api/cart-item/',
              headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer((_) async => http.Response(fixture('detail.json'), 400));

      final result = remoteSource.addCartItem;

      expect(() => result(null, null), throwsA(isA<FieldsException>()));
    });

    test('should throw [UnknownException] if response code is not expected',
        () {
      when(client.post('$baseUrl/api/cart-item/',
              headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer((_) async => http.Response(fixture('detail.json'), 500));

      final result = remoteSource.addCartItem;

      expect(() => result(null, null), throwsA(isA<UnknownException>()));
    });
  });

  group('deleteCartItem', () {
    void do204Response() {
      when(client.delete('$baseUrl/api/cart-item/null/',
              headers: anyNamed('headers')))
          .thenAnswer(
              (_) async => http.Response(fixture('cart_item.json'), 204));
    }

    test('should return [true] if response code is 204', () async {
      do204Response();

      final result = await remoteSource.deleteCartItem(null);

      expect(result, true);
    });

    test('should throw [UnauthorizedTokenException] if response code is 401',
        () {
      when(client.delete('$baseUrl/api/cart-item/null/',
              headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(fixture('detail.json'), 401));

      final result = remoteSource.deleteCartItem;

      expect(() => result(null), throwsA(isA<UnauthorizedTokenException>()));
    });

    test('should throw [ItemNotFoundException] if response code is 404', () {
      when(client.delete('$baseUrl/api/cart-item/null/',
              headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(fixture('detail.json'), 404));

      final result = remoteSource.deleteCartItem;

      expect(() => result(null), throwsA(isA<ItemNotFoundException>()));
    });

    test('should throw [UnknownException] if response code is not expected',
        () {
      when(client.delete('$baseUrl/api/cart-item/null/',
              headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(fixture('detail.json'), 500));

      final result = remoteSource.deleteCartItem;

      expect(() => result(null), throwsA(isA<UnknownException>()));
    });
  });

  group('editCartItem', () {
    void do200Response() {
      when(client.put('$baseUrl/api/cart-item/null/',
              headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer(
              (_) async => http.Response(fixture('cart_item.json'), 200));
    }

    test('should return [CartItemsResult] if response code is 200', () async {
      do200Response();

      final result = await remoteSource.editCartItem(null, null, null);

      expect(result, cartItem);
    });

    test('should throw [UnauthorizedTokenException] if response code is 401',
        () {
      when(client.put('$baseUrl/api/cart-item/null/',
              headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer((_) async => http.Response(fixture('detail.json'), 401));

      final result = remoteSource.editCartItem;

      expect(() => result(null, null, null),
          throwsA(isA<UnauthorizedTokenException>()));
    });

    test('should throw [ItemNotFoundException] if response code is 404', () {
      when(client.put('$baseUrl/api/cart-item/null/',
              headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer((_) async => http.Response(fixture('detail.json'), 404));

      final result = remoteSource.editCartItem;

      expect(() => result(null, null, null),
          throwsA(isA<ItemNotFoundException>()));
    });

    test('should throw [FieldsException] if response code is 400', () {
      when(client.put('$baseUrl/api/cart-item/null/',
              headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer((_) async => http.Response(fixture('detail.json'), 400));

      final result = remoteSource.editCartItem;

      expect(() => result(null, null, null), throwsA(isA<FieldsException>()));
    });

    test('should throw [UnknownException] if response code is not expected',
        () {
      when(client.put('$baseUrl/api/cart-item/null/',
              headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer((_) async => http.Response(fixture('detail.json'), 500));

      final result = remoteSource.editCartItem;

      expect(() => result(null, null, null), throwsA(isA<UnknownException>()));
    });
  });

  group('getCartItems', () {
    void do200Response() {
      when(client.get('$baseUrl/api/cart-item?limit=$limit&offset=$offset',
              headers: anyNamed('headers')))
          .thenAnswer(
              (_) async => http.Response(fixture('cart_items.json'), 200));
    }

    test('should return [CartItems] if response code is 200', () async {
      do200Response();

      final result = await remoteSource.getCartItems(offset);

      expect(result, cartItems);
    });

    test('should throw [UnauthorizedTokenException] if response code is 401',
        () {
      when(client.get('$baseUrl/api/cart-item?limit=$limit&offset=$offset',
              headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(fixture('detail.json'), 401));

      final result = remoteSource.getCartItems;

      expect(() => result(offset), throwsA(isA<UnauthorizedTokenException>()));
    });

    test('should throw [UnknownException] if response code is not expected',
        () {
      when(client.get('$baseUrl/api/cart-item?limit=$limit&offset=$offset',
              headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(fixture('detail.json'), 500));

      final result = remoteSource.getCartItems;

      expect(() => result(offset), throwsA(isA<UnknownException>()));
    });
  });
}
