import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:perminda/core/constants/sensetive_constants.dart';
import 'package:perminda/core/errors/exception.dart';
import 'package:http/http.dart' as http;
import 'package:perminda/data/data_sources/product_image/remote_source.dart';
import 'package:perminda/data/remote_models/product_image/product_image.dart';

import '../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  MockHttpClient client;
  ProductImageRemoteSourceImpl remoteSource;

  setUp(() {
    client = MockHttpClient();
    remoteSource = ProductImageRemoteSourceImpl(client: client);
  });

  final productImage =
      ProductImage.fromJson(json.decode(fixture('product_image.json')));

  group('addProductImage', () {
    void do201Response() {
      when(client.post('$baseUrl/api/product-image/',
              body: anyNamed('body'), headers: anyNamed('headers')))
          .thenAnswer(
              (_) async => http.Response(fixture('product_image.json'), 201));
    }

    test('should return [ProductImage] if response code is 201', () async {
      do201Response();

      final result = await remoteSource.addProductImage(null, null, null);

      expect(result, productImage);
    });

    test('should throw [FieldsException] if response code is 400', () {
      when(client.post('$baseUrl/api/product-image/',
              body: anyNamed('body'), headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(fixture('detail.json'), 400));

      final result = remoteSource.addProductImage;

      expect(() => result(null, null, null), throwsA(isA<FieldsException>()));
    });

    test('should throw [UnauthorizedTokenException] if response code is 401',
        () {
      when(client.post('$baseUrl/api/product-image/',
              body: anyNamed('body'), headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(fixture('detail.json'), 401));

      final result = remoteSource.addProductImage;

      expect(() => result(null, null, null),
          throwsA(isA<UnauthorizedTokenException>()));
    });

    test('should throw [NotAllowedPermissionException] if response code is 403',
        () {
      when(client.post('$baseUrl/api/product-image/',
              body: anyNamed('body'), headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(fixture('detail.json'), 403));

      final result = remoteSource.addProductImage;

      expect(() => result(null, null, null),
          throwsA(isA<NotAllowedPermissionException>()));
    });

    test('should throw [UnknownException] if response code is not expected',
        () {
      when(client.post('$baseUrl/api/product-image/',
              body: anyNamed('body'), headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(fixture('detail.json'), 500));

      final result = remoteSource.addProductImage;

      expect(() => result(null, null, null), throwsA(isA<UnknownException>()));
    });
  });

  group('editProductImage', () {
    void do200Response() {
      when(client.put('$baseUrl/api/product-image/${productImage.id}/',
              body: anyNamed('body'), headers: anyNamed('headers')))
          .thenAnswer(
              (_) async => http.Response(fixture('product_image.json'), 200));
    }

    test('should return [ProductImage] if response code is 200', () async {
      do200Response();

      final result = await remoteSource.editProductImage(
          productImage.id, null, null, null);

      expect(result, productImage);
    });

    test('should throw [FieldsException] if response code is 400', () {
      when(client.put('$baseUrl/api/product-image/${productImage.id}/',
              body: anyNamed('body'), headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(fixture('detail.json'), 400));

      final result = remoteSource.editProductImage;

      expect(() => result(productImage.id, null, null, null),
          throwsA(isA<FieldsException>()));
    });

    test('should throw [UnauthorizedTokenException] if response code is 401',
        () {
      when(client.put('$baseUrl/api/product-image/${productImage.id}/',
              body: anyNamed('body'), headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(fixture('detail.json'), 401));

      final result = remoteSource.editProductImage;

      expect(() => result(productImage.id, null, null, null),
          throwsA(isA<UnauthorizedTokenException>()));
    });

    test('should throw [NotAllowedPermissionException] if response code is 403',
        () {
      when(client.put('$baseUrl/api/product-image/${productImage.id}/',
              body: anyNamed('body'), headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(fixture('detail.json'), 403));

      final result = remoteSource.editProductImage;

      expect(() => result(productImage.id, null, null, null),
          throwsA(isA<NotAllowedPermissionException>()));
    });

    test('should throw [ItemNotFoundException] if response code is 404', () {
      when(client.put('$baseUrl/api/product-image/${productImage.id}/',
              body: anyNamed('body'), headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(fixture('detail.json'), 404));

      final result = remoteSource.editProductImage;

      expect(() => result(productImage.id, null, null, null),
          throwsA(isA<ItemNotFoundException>()));
    });

    test('should throw [UnknownException] if response code is not expected',
        () {
      when(client.put('$baseUrl/api/product-image/${productImage.id}/',
              body: anyNamed('body'), headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(fixture('detail.json'), 500));

      final result = remoteSource.editProductImage;

      expect(() => result(productImage.id, null, null, null),
          throwsA(isA<UnknownException>()));
    });
  });

  group('deleteProductImage', () {
    void do204Response() {
      when(client.delete('$baseUrl/api/product-image/${productImage.id}/',
              headers: anyNamed('headers')))
          .thenAnswer(
              (_) async => http.Response(fixture('product_image.json'), 204));
    }

    test('should return [true] if response code is 204', () async {
      do204Response();

      final result = await remoteSource.deleteProductImage(productImage.id);

      expect(result, true);
    });

    test('should throw [UnauthorizedTokenException] if response code is 401',
        () {
      when(client.delete('$baseUrl/api/product-image/${productImage.id}/',
              headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(fixture('detail.json'), 401));

      final result = remoteSource.deleteProductImage;

      expect(() => result(productImage.id),
          throwsA(isA<UnauthorizedTokenException>()));
    });

    test('should throw [NotAllowedPermissionException] if response code is 403',
        () {
      when(client.delete('$baseUrl/api/product-image/${productImage.id}/',
              headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(fixture('detail.json'), 403));

      final result = remoteSource.deleteProductImage;

      expect(() => result(productImage.id),
          throwsA(isA<NotAllowedPermissionException>()));
    });

    test('should throw [ItemNotFoundException] if response code is 404', () {
      when(client.delete('$baseUrl/api/product-image/${productImage.id}/',
              headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(fixture('detail.json'), 404));

      final result = remoteSource.deleteProductImage;

      expect(
          () => result(productImage.id), throwsA(isA<ItemNotFoundException>()));
    });

    test('should throw [UnknownException] if response code is not expected',
        () {
      when(client.delete('$baseUrl/api/product-image/${productImage.id}/',
              headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(fixture('detail.json'), 500));

      final result = remoteSource.deleteProductImage;

      expect(() => result(productImage.id), throwsA(isA<UnknownException>()));
    });
  });

  group('getProductImage', () {
    void do200Response() {
      when(client.get(
        '$baseUrl/api/product-image/${productImage.id}/',
      )).thenAnswer(
          (_) async => http.Response(fixture('product_image.json'), 200));
    }

    test('should return [productImage] if response code is 200', () async {
      do200Response();

      final result = await remoteSource.getProductImage(productImage.id);

      expect(result, productImage);
    });

    test('should throw [ItemNotFoundException] if response code is 404', () {
      when(client.get(
        '$baseUrl/api/product-image/${productImage.id}/',
      )).thenAnswer((_) async => http.Response(fixture('detail.json'), 404));

      final result = remoteSource.getProductImage;

      expect(
          () => result(productImage.id), throwsA(isA<ItemNotFoundException>()));
    });

    test('should throw [UnknownException] if response code is not expected',
        () {
      when(client.get(
        '$baseUrl/api/product-image/${productImage.id}/',
      )).thenAnswer((_) async => http.Response(fixture('detail.json'), 500));

      final result = remoteSource.getProductImage;

      expect(() => result(productImage.id), throwsA(isA<UnknownException>()));
    });
  });
}
