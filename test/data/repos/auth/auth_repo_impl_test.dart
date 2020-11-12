import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:perminda/core/errors/exception.dart';
import 'package:perminda/core/errors/failure.dart';
import 'package:perminda/core/network/network_info.dart';
import 'package:perminda/data/data_sources/auth/remote_data_source.dart';
import 'package:perminda/data/remote_models/auth/user.dart';
import 'package:perminda/data/repos/auth/auth_repo_impl.dart';

import '../../../fixtures/fixture_reader.dart';

class MockNetWorkInfo extends Mock implements NetWorkInfo {}

class MockRemoteDataSource extends Mock implements AuthRemoteDataSource {}

void main() {
  MockNetWorkInfo netWorkInfo;
  MockRemoteDataSource remoteDataSource;
  AuthRepoImpl authRepo;

  setUp(() {
    netWorkInfo = MockNetWorkInfo();
    remoteDataSource = MockRemoteDataSource();
    authRepo = AuthRepoImpl(
      netWorkInfo: netWorkInfo,
      remoteDataSource: remoteDataSource,
    );
  });

  group('device is online', () {
    setUp(() {
      when(netWorkInfo.isConnected()).thenAnswer((_) async => true);
    });

    group('registerUser', () {
      final user = User.fromJson(json.decode(fixture('user.json')));
      test('should check if the device is online', () async {
        final result = authRepo.registerUser('', '', '', '', '');

        verify(netWorkInfo.isConnected());
        expect(await netWorkInfo.isConnected(), true);
      });

      test('should return [User] if the remote call success', () async {
        when(remoteDataSource.registerUser(user.firstName, user.lastName,
                user.username, user.email, '3489'))
            .thenAnswer((_) async => user);

        final result = await authRepo.registerUser(
            user.firstName, user.lastName, user.username, user.email, '3489');

        verify(remoteDataSource.registerUser(
            user.firstName, user.lastName, user.username, user.email, '3489'));

        expect(result, Right(user));
      });

      test(
          'should return [FieldsFailure] if the remote call throws [FieldsException]',
          () async {
        final fieldsFailure = FieldsFailure(
          email: ['This field is required.'],
          userName: ['A user with this username is already exists.'],
        );
        when(remoteDataSource.registerUser(user.firstName, user.lastName,
                user.username, user.email, '3489'))
            .thenThrow(FieldsException(
                body: fixture('registration_fields_error.json')));

        final result = await authRepo.registerUser(
            user.firstName, user.lastName, user.username, user.email, '3489');

        verify(remoteDataSource.registerUser(
            user.firstName, user.lastName, user.username, user.email, '3489'));

        expect(result, Left(fieldsFailure));
      });

      test(
          'should return [UnknownFailure] if the remote call throws [UnknownException]',
          () async {
        when(remoteDataSource.registerUser(user.firstName, user.lastName,
                user.username, user.email, '3489'))
            .thenThrow(UnknownException());

        final result = await authRepo.registerUser(
            user.firstName, user.lastName, user.username, user.email, '3489');

        verify(remoteDataSource.registerUser(
            user.firstName, user.lastName, user.username, user.email, '3489'));

        expect(result, Left(UnknownFailure()));
      });
    });
  });

  group('device is offline', () {
    setUp(() {
      when(netWorkInfo.isConnected()).thenAnswer((_) async => false);
    });

    test('should return false if user has no connection', () async {
      authRepo.registerUser('', '', '', '', '');
      verify(netWorkInfo.isConnected());
      expect(await netWorkInfo.isConnected(), false);
    });

    test('should return [noInternetFailure] if user has no connection',
        () async {
      final result = await authRepo.registerUser('', '', '', '', '');

      expect(result, Left(NoInternetFailure()));
    });
  });
}
