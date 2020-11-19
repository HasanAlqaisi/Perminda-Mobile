import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:perminda/core/constants/sensetive_constants.dart';
import 'package:perminda/core/errors/exception.dart';
import 'package:perminda/data/data_sources/categories/remote_soruce.dart';
import 'package:perminda/data/remote_models/categories/category.dart';

import '../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  MockHttpClient client;
  CategoriesRemoteSourceImpl remoteSourceImpl;

  setUp(() {
    client = MockHttpClient();
    remoteSourceImpl = CategoriesRemoteSourceImpl(client: client);
  });

  group('getCategories', () {
    final categories = (json.decode(fixture('categories.json')) as List)
        .map((category) => Category.fromJson(category))
        .toList();

    void do200Response() {
      when(client.get('$baseUrl/api/category/')).thenAnswer(
          (_) async => http.Response(fixture('categories.json'), 200));
    }

    void do404Response() {
      when(client.get('$baseUrl/api/category/'))
          .thenAnswer((_) async => http.Response(fixture('detail.json'), 404));
    }

    test('should return list of [Category] if response code is 200', () async {
      do200Response();
      final result = await remoteSourceImpl.getCategories();

      expect(result, categories);
    });

    test('should throw UnknownException if response code is not 200', () {
      do404Response();

      final result = remoteSourceImpl.getCategories;

      expect(() => result(), throwsA(isA<UnknownException>()));
    });
  });

  group('getCategoryById', () {
    final category = Category.fromJson(json.decode(fixture('category.json')));
    final id = '6ed29f7b-88b5-4dad-a2dd-c7d5d6df5e4d';

    void do200Response() {
      when(client.get('$baseUrl/api/category/$id/')).thenAnswer(
          (_) async => http.Response(fixture('category.json'), 200));
    }

    void do404Response() {
      when(client.get('$baseUrl/api/category/$id/'))
          .thenAnswer((_) async => http.Response(fixture('detail.json'), 404));
    }

    void do500Response() {
      when(client.get('$baseUrl/api/category/$id/'))
          .thenAnswer((_) async => http.Response(fixture('detail.json'), 500));
    }

    test('should return [Category] if response code is 200', () async {
      do200Response();
      final result = await remoteSourceImpl.getCategoryById(id);

      expect(result, category);
    });

    test(
        'should throw [ItemNotFoundException] if response code is neither 200 nor 404',
        () {
      do404Response();

      final result = remoteSourceImpl.getCategoryById;

      expect(() => result(id), throwsA(isA<ItemNotFoundException>()));
    });

    test(
        'should throw [UnknownException] if response code is neither 200 nor 404',
        () {
      do500Response();

      final result = remoteSourceImpl.getCategoryById;

      expect(() => result(id), throwsA(isA<UnknownException>()));
    });
  });
}
