import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:perminda/core/constants/sensetive_constants.dart';
import 'package:perminda/core/errors/exception.dart';
import 'package:perminda/data/data_sources/auth/remote_data_source.dart';
import 'package:perminda/data/remote_models/auth/user.dart';

import '../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  MockHttpClient client;
  AuthRemoteDataSourceImpl remoteDataSource;

  setUp(() {
    client = MockHttpClient();
    remoteDataSource = AuthRemoteDataSourceImpl(client: client);
  });

  final user = User.fromJson(json.decode(fixture('user.json')));

  group('registerUser', () {
    test('should return [User] if response is 201', () async {
      when(client.post(
        '$baseUrl/api/accounts/registration/',
        body: {
          'first_name': 'string',
          'last_name': 'string',
          'username': 'string',
          'email': 'user@example.com',
          'phone_number': '',
          'password': '3489',
        },
      )).thenAnswer((_) async => http.Response(fixture('user.json'), 201));

      final result = await remoteDataSource.registerUser(
          user.firstName, user.lastName, user.username, user.email, '', '3489');

      expect(result, user);
    });

    test('should throw [FieldsException] if response is 400', () async {
      when(client.post(
        '$baseUrl/api/accounts/registration/',
        body: {
          'first_name': 'string',
          'last_name': 'string',
          'username': 'string',
          'email': 'user@example.com',
          'phone_number': '',
          'password': '3489',
        },
      )).thenAnswer((_) async =>
          http.Response(fixture('registration_fields_error.json'), 400));

      final result = remoteDataSource.registerUser;

      expect(
        () => result(user.firstName, user.lastName, user.username, user.email,
            '', '3489'),
        throwsA(isA<FieldsException>()),
      );
    });

    test('should throw [UnkownException] if response is not 201 or 400',
        () async {
      when(client.post(
        '$baseUrl/api/accounts/registration/',
        body: {
          'first_name': 'string',
          'last_name': 'string',
          'username': 'string',
          'email': 'user@example.com',
          'phone_number': '',
          'password': '3489',
        },
      )).thenAnswer((_) async =>
          http.Response(fixture('registration_fields_error.json'), 404));

      final result = remoteDataSource.registerUser;

      expect(
        () => result(user.firstName, user.lastName, user.username, user.email,
            '', '3489'),
        throwsA(isA<UnknownException>()),
      );
    });
  });

  group('loginUser', () {
    test('should return user token when if response is 200', () async {
      when(client.post(
        '$baseUrl/api/accounts/login/',
        body: {
          'username': '',
          'password': '',
        },
      )).thenAnswer((_) async => http.Response(fixture('key.json'), 200));

      final result = await remoteDataSource.loginUser('', '');
      final expectedResult = (json.decode(fixture('key.json'))['key']);
      expect(result, expectedResult);
    });

    test('should throw [NonFieldsException] if response is 400', () async {
      when(client.post(
        '$baseUrl/api/accounts/login/',
        body: {
          'username': '',
          'password': '',
        },
      )).thenAnswer(
          (_) async => http.Response(fixture('non_fields.json'), 400));

      final result = remoteDataSource.loginUser;

      expect(
        () => result('', ''),
        throwsA(isA<NonFieldsException>()),
      );
    });

    test('should throw [UnknownException] if response is neither 400 nor 200',
        () async {
      when(client.post(
        '$baseUrl/api/accounts/login/',
        body: {
          'username': '',
          'password': '',
        },
      )).thenAnswer(
          (_) async => http.Response(fixture('non_fields.json'), 404));

      final result = remoteDataSource.loginUser;

      expect(
        () => result('', ''),
        throwsA(isA<UnknownException>()),
      );
    });
  });

  group('forgotPassword', () {
    test('should return success message if response code is 200', () async {
      when(client.post('$baseUrl/api/accounts/password/reset/',
              body: {'email': ''}))
          .thenAnswer((_) async => http.Response(fixture('detail.json'), 200));

      final result = await remoteDataSource.forgotPassword('');
      final expectedResult = (json.decode(fixture('detail.json'))['detail']);

      expect(result, expectedResult);
    });

    test('should throw [UnknownException] if response is not 200', () async {
      when(client.post(
        '$baseUrl/api/accounts/password/reset/',
        body: {
          'email': '',
        },
      )).thenAnswer((_) async => http.Response(fixture('detail.json'), 400));

      final result = remoteDataSource.forgotPassword;

      expect(
        () => result(''),
        throwsA(isA<UnknownException>()),
      );
    });
  });

  group('getUser', () {
    test('should return [user] if response code is 200', () async {
      when(client.get('$baseUrl/api/accounts/user/',
              headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(fixture('user.json'), 200));

      final result = await remoteDataSource.getUser();

      expect(result, user);
    });

    test('should throw [UnauthorizedTokenException] if response is not 401',
        () async {
      when(client.get('$baseUrl/api/accounts/user/',
              headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(fixture('detail.json'), 401));

      final result = remoteDataSource.getUser;

      expect(
        () => result(),
        throwsA(isA<UnauthorizedTokenException>()),
      );
    });

    test('should throw [UnknownException] if response is not 200', () async {
      when(client.get('$baseUrl/api/accounts/user/',
              headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(fixture('detail.json'), 400));

      final result = remoteDataSource.getUser;

      expect(
        () => result(),
        throwsA(isA<UnknownException>()),
      );
    });
  });

  group('editUser', () {
    test('should return [User] if response code is 200', () async {
      when(client.put('$baseUrl/api/accounts/user/',
          headers: anyNamed('headers'),
          body: {
            'first_name': null,
            'last_name': null,
            'username': null,
            'email': null,
            'phone_number': null,
            'password': null,
            'address': null,
            'image': null,
          })).thenAnswer((_) async => http.Response(fixture('user.json'), 200));

      final result = await remoteDataSource.editUser(
          null, null, null, null, null, null, null, null);

      expect(result, user);
    });

    test('should throw [FieldsException] if response is 400', () async {
      when(client.put('$baseUrl/api/accounts/user/',
              headers: anyNamed('headers'),
              body: {
            'first_name': null,
            'last_name': null,
            'username': null,
            'email': null,
            'phone_number': null,
            'password': null,
            'address': null,
            'image': null,
          }))
          .thenAnswer((_) async => http.Response(fixture('detail.json'), 400));

      final result = remoteDataSource.editUser;

      expect(
        () => result(null, null, null, null, null, null, null, null),
        throwsA(isA<FieldsException>()),
      );
    });

    test('should throw [UnauthorizedTokenException] if response is 401',
        () async {
      when(client.put('$baseUrl/api/accounts/user/',
              headers: anyNamed('headers'),
              body: {
            'first_name': null,
            'last_name': null,
            'username': null,
            'email': null,
            'phone_number': null,
            'password': null,
            'address': null,
            'image': null,
          }))
          .thenAnswer((_) async => http.Response(fixture('detail.json'), 401));

      final result = remoteDataSource.editUser;

      expect(
        () => result(null, null, null, null, null, null, null, null),
        throwsA(isA<UnauthorizedTokenException>()),
      );
    });

    test('should throw [UnknownException] if response code is not expected ',
        () async {
      when(client.put('$baseUrl/api/accounts/user/',
              headers: anyNamed('headers'),
              body: {
            'first_name': null,
            'last_name': null,
            'username': null,
            'email': null,
            'phone_number': null,
            'password': null,
            'address': null,
            'image': null,
          }))
          .thenAnswer((_) async => http.Response(fixture('detail.json'), 403));

      final result = remoteDataSource.editUser;

      expect(
        () => result(null, null, null, null, null, null, null, null),
        throwsA(isA<UnknownException>()),
      );
    });
  });
}
