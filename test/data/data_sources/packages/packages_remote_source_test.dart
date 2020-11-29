import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:perminda/core/constants/sensetive_constants.dart';
import 'package:perminda/core/errors/exception.dart';
import 'package:http/http.dart' as http;
import 'package:perminda/data/data_sources/packages/packages_remote_source.dart';
import 'package:perminda/data/remote_models/packages/packages.dart';
import '../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  MockHttpClient client;
  PackagesRemoteSourceImpl remoteSource;
  int offset = 0;

  final packages = Packages.fromJson(json.decode(fixture('packages.json')));

  setUp(() {
    client = MockHttpClient();
    remoteSource = PackagesRemoteSourceImpl(client: client);
  });
  group('getPackages', () {
    void do200Response() {
      when(client.get(
        '$baseUrl/api/package?limit=10&offset=$offset',
      )).thenAnswer((_) async => http.Response(fixture('packages.json'), 200));
    }

    test('should return [Packages] if response code is 200', () async {
      do200Response();

      final result = await remoteSource.getPackages(offset);

      expect(result, packages);
    });

    test('should throw [UnknownException] if response code is not expected',
        () {
      when(client.get(
        '$baseUrl/api/package?limit=10&offset=$offset',
      )).thenAnswer((_) async => http.Response(fixture('packages.json'), 500));

      final result = remoteSource.getPackages;

      expect(() => result(offset), throwsA(isA<UnknownException>()));
    });
  });
}
