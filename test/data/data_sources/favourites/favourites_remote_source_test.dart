import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:perminda/core/constants/sensetive_constants.dart';
import 'package:perminda/core/errors/exception.dart';
import 'package:http/http.dart' as http;
import 'package:perminda/data/data_sources/favourites/favourites_remote_source.dart';
import 'package:perminda/data/remote_models/favourites/favourites.dart';
import 'package:perminda/data/remote_models/favourites/results.dart';

import '../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  MockHttpClient client;
  FavouritesRemoteSourceImpl remoteSource;

  const int limit = 10;
  int offset = 0;

  final favourites =
      Favourites.fromJson(json.decode(fixture('favourites.json')));

  final favourite =
      FavouritesResult.fromJson(json.decode(fixture('favourite.json')));

  setUp(() {
    client = MockHttpClient();
    remoteSource = FavouritesRemoteSourceImpl(client: client);
  });

  group('addFavourite', () {
    void do201Response() {
      when(client.post('$baseUrl/api/favourite/',
              headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer(
              (_) async => http.Response(fixture('favourite.json'), 201));
    }

    test('sould return [favouritesResult] if response code is 201', () async {
      do201Response();

      final result = await remoteSource.addFavourite(null);

      expect(result, favourite);
    });

    test('should throw [UnauthorizedTokenException] if response code is 401',
        () {
      when(client.post('$baseUrl/api/favourite/',
              headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer(
              (_) async => http.Response(fixture('favourite.json'), 401));

      final result = remoteSource.addFavourite;

      expect(() => result(null), throwsA(isA<UnauthorizedTokenException>()));
    });

    test('should throw [FieldsException] if response code is 400', () {
      when(client.post('$baseUrl/api/favourite/',
              headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer(
              (_) async => http.Response(fixture('favourite.json'), 400));

      final result = remoteSource.addFavourite;

      expect(() => result(null), throwsA(isA<FieldsException>()));
    });

    test('should throw [UnknownException] if response code is not expected',
        () {
      when(client.post('$baseUrl/api/favourite/',
              headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer(
              (_) async => http.Response(fixture('favourite.json'), 500));

      final result = remoteSource.addFavourite;

      expect(() => result(null), throwsA(isA<UnknownException>()));
    });
  });

  group('deleteFavourite', () {
    void do204Response() {
      when(client.delete('$baseUrl/api/favourite/null/',
              headers: anyNamed('headers')))
          .thenAnswer(
              (_) async => http.Response(fixture('favourite.json'), 204));
    }

    test('sould return [true] if response code is 204', () async {
      do204Response();

      final result = await remoteSource.deleteFavourite(null);

      expect(result, true);
    });

    test('should throw [UnauthorizedTokenException] if response code is 401',
        () {
      when(client.delete('$baseUrl/api/favourite/null/',
              headers: anyNamed('headers')))
          .thenAnswer(
              (_) async => http.Response(fixture('favourite.json'), 401));

      final result = remoteSource.deleteFavourite;

      expect(() => result(null), throwsA(isA<UnauthorizedTokenException>()));
    });

    test('should throw [ItemNotFoundException] if response code is 404', () {
      when(client.delete('$baseUrl/api/favourite/null/',
              headers: anyNamed('headers')))
          .thenAnswer(
              (_) async => http.Response(fixture('favourite.json'), 404));

      final result = remoteSource.deleteFavourite;

      expect(() => result(null), throwsA(isA<ItemNotFoundException>()));
    });

    test('should throw [UnknownException] if response code is not expected',
        () {
      when(client.delete('$baseUrl/api/favourite/null/',
              headers: anyNamed('headers')))
          .thenAnswer(
              (_) async => http.Response(fixture('favourite.json'), 500));

      final result = remoteSource.deleteFavourite;

      expect(() => result(null), throwsA(isA<UnknownException>()));
    });
  });

  group('getFavourites', () {
    void do200Response() {
      when(client.get('$baseUrl/api/favourite?limit=$limit&offset=$offset',
              headers: anyNamed('headers')))
          .thenAnswer(
              (_) async => http.Response(fixture('favourites.json'), 200));
    }

    test('sould return [favourites] if response code is 200', () async {
      do200Response();

      final result = await remoteSource.getFavourites(offset);

      expect(result, favourites);
    });

    test('should throw [UnauthorizedTokenException] if response code is 401',
        () {
      when(client.get('$baseUrl/api/favourite?limit=$limit&offset=$offset',
              headers: anyNamed('headers')))
          .thenAnswer(
              (_) async => http.Response(fixture('favourites.json'), 401));

      final result = remoteSource.getFavourites;

      expect(() => result(offset), throwsA(isA<UnauthorizedTokenException>()));
    });

    test('should throw [UnknownException] if response code is not expected',
        () {
      when(client.get('$baseUrl/api/favourite?limit=$limit&offset=$offset',
              headers: anyNamed('headers')))
          .thenAnswer(
              (_) async => http.Response(fixture('favourite.json'), 500));

      final result = remoteSource.getFavourites;

      expect(() => result(offset), throwsA(isA<UnknownException>()));
    });
  });
}
