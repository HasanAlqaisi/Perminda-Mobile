import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:moor_flutter/moor_flutter.dart';
import 'package:perminda/core/constants/sensetive_constants.dart';
import 'package:perminda/core/errors/exception.dart';
import 'package:perminda/core/errors/failure.dart';
import 'package:perminda/core/network/network_info.dart';
import 'package:perminda/data/data_sources/auth/local_source.dart';
import 'package:perminda/data/data_sources/auth/remote_data_source.dart';
import 'package:perminda/data/db/app_database/app_database.dart';
import 'package:perminda/data/db/models/user/user_table.dart';
import 'package:perminda/data/remote_models/auth/user.dart';
import 'package:perminda/data/repos/auth/auth_repo_impl.dart';

import '../../../fixtures/fixture_reader.dart';

class MockNetWorkInfo extends Mock implements NetWorkInfo {}

class MockRemoteDataSource extends Mock implements AuthRemoteDataSource {}

class MockUserLocalSource extends Mock implements UserLocalSource {}

void main() {
  MockNetWorkInfo netWorkInfo;
  MockRemoteDataSource remoteDataSource;
  MockUserLocalSource userLocalSource;
  AuthRepoImpl authRepo;

  setUp(() {
    netWorkInfo = MockNetWorkInfo();
    remoteDataSource = MockRemoteDataSource();
    userLocalSource = MockUserLocalSource();
    authRepo = AuthRepoImpl(
      netWorkInfo: netWorkInfo,
      remoteDataSource: remoteDataSource,
      userLocalSource: userLocalSource,
    );
  });

  group('device is online', () {
    setUp(() {
      when(netWorkInfo.isConnected()).thenAnswer((_) async => true);
    });

    final user = User.fromJson(json.decode(fixture('user.json')));
    group('registerUser', () {
      setUp(() {
        when(remoteDataSource.registerUser(user.firstName, user.lastName,
                user.username, user.email, '', '3489'))
            .thenAnswer((_) async => user);

        when(remoteDataSource.loginUser(user.username, '3489'))
            .thenAnswer((_) async => token);
        when(userLocalSource
                .cacheUserId('3fa85f64-5717-4562-b3fc-2c963f66afa6'))
            .thenAnswer((_) async => null);
        when(userLocalSource.cacheUserToken(null))
            .thenAnswer((_) async => null);
      });

      test('should check if the device is online', () async {
        authRepo.registerUser(user.firstName, user.lastName, user.username,
            user.email, '', '3489');

        verify(netWorkInfo.isConnected());
        expect(await netWorkInfo.isConnected(), true);
      });

      test('should return [true] if remote call is success', () async {
        final result = await authRepo.registerUser(user.firstName,
            user.lastName, user.username, user.email, '', '3489');

        verify(remoteDataSource.registerUser(user.firstName, user.lastName,
            user.username, user.email, '', '3489'));

        verify(remoteDataSource.loginUser(user.username, '3489'));

        expect(result, Right(true));
      });

      test('should save [token] and [user id] in shared preferences', () async {
        await authRepo.registerUser(user.firstName, user.lastName,
            user.username, user.email, '', '3489');

        verify(userLocalSource
            .cacheUserId('3fa85f64-5717-4562-b3fc-2c963f66afa6'));
        verify(userLocalSource.cacheUserToken(null));
      });

      test('should save [user] if the registration done successfully',
          () async {
        await authRepo.registerUser(user.firstName, user.lastName,
            user.username, user.email, '', '3489');

        verify(userLocalSource.insertUser(UserTable.fromUser(user)));
      });

      test(
          'should return [UserFieldsFailure] if the remote call throws [FieldsException]',
          () async {
        final fieldsFailure = UserFieldsFailure(
          email: ['This field is required.'],
          userName: ['A user with this username is already exists.'],
        );
        when(remoteDataSource.registerUser(user.firstName, user.lastName,
                user.username, user.email, '', '3489'))
            .thenThrow(FieldsException(
                body: fixture('registration_fields_error.json')));

        final result = await authRepo.registerUser(user.firstName,
            user.lastName, user.username, user.email, '', '3489');

        verify(remoteDataSource.registerUser(user.firstName, user.lastName,
            user.username, user.email, '', '3489'));

        expect(result, Left(fieldsFailure));
      });

      test(
          'should return [UnknownFailure] if the remote call throws [UnknownException]',
          () async {
        when(remoteDataSource.registerUser(user.firstName, user.lastName,
                user.username, user.email, '', '3489'))
            .thenThrow(UnknownException());

        final result = await authRepo.registerUser(user.firstName,
            user.lastName, user.username, user.email, '', '3489');

        verify(remoteDataSource.registerUser(user.firstName, user.lastName,
            user.username, user.email, '', '3489'));

        expect(result, Left(UnknownFailure()));
      });

      test(
          'should return [UnauthorizedTokenFailure] if the remote call throws [UnauthorizedTokenException]',
          () async {
        when(remoteDataSource.registerUser(user.firstName, user.lastName,
                user.username, user.email, '', '3489'))
            .thenThrow(UnauthorizedTokenException());

        final result = await authRepo.registerUser(user.firstName,
            user.lastName, user.username, user.email, '', '3489');

        verify(remoteDataSource.registerUser(user.firstName, user.lastName,
            user.username, user.email, '', '3489'));

        expect(result, Left(UnauthorizedTokenFailure()));
      });

      test(
          'should return [CacheFailure] if the database throws [InvalidDataException]',
          () async {
        when(remoteDataSource.registerUser(user.firstName, user.lastName,
                user.username, user.email, '', '3489'))
            .thenThrow(InvalidDataException(null));

        final result = await authRepo.registerUser(user.firstName,
            user.lastName, user.username, user.email, '', '3489');

        verify(remoteDataSource.registerUser(user.firstName, user.lastName,
            user.username, user.email, '', '3489'));

        expect(result, Left(CacheFailure()));
      });
    });

    group('loginUser', () {
      setUp(() {
        when(remoteDataSource.loginUser('', '')).thenAnswer((_) async => token);
        when(userLocalSource
                .cacheUserId('3fa85f64-5717-4562-b3fc-2c963f66afa6'))
            .thenAnswer((_) async => null);
        when(userLocalSource.cacheUserToken(null))
            .thenAnswer((_) async => null);
        when(userLocalSource.insertUser(UserTable.fromUser(user)))
            .thenAnswer((_) async => null);
        when(remoteDataSource.getUser()).thenAnswer((_) async => user);
      });

      test('should check if the device is online', () async {
        authRepo.loginUser('', '');

        verify(netWorkInfo.isConnected());
        expect(await netWorkInfo.isConnected(), true);
      });

      test('should save [token] if the login done successfully', () async {
        await authRepo.loginUser('', '');

        verify(userLocalSource.cacheUserToken(token));
      });

      test('should save [user] if the login done successfully', () async {
        await authRepo.loginUser('', '');

        verify(userLocalSource.insertUser(UserTable.fromUser(user)));
      });

      test('should save [userId] if the user info has gotten', () async {
        await authRepo.loginUser('', '');

        verify(remoteDataSource.getUser());
        verify(userLocalSource.cacheUserId(user.id));
      });

      test('should return [true] if the remote call success', () async {
        when(remoteDataSource.loginUser('', '')).thenAnswer((_) async => token);

        final result = await authRepo.loginUser('', '');

        expect(result, Right(true));
      });

      test(
          'should return [NonFieldsFailure] if the remote call throw [NonFieldsException]',
          () async {
        final nonFieldsFailure = NonFieldsFailure(
          errors: ['Unable to log in with provided credentials.'],
        );

        when(remoteDataSource.loginUser('', ''))
            .thenThrow(NonFieldsException(message: fixture('non_fields.json')));

        final result = await authRepo.loginUser('', '');

        expect(result, Left(nonFieldsFailure));
      });

      test(
          'should return [UnknownFailure] if the remote call throws [UnknownException]',
          () async {
        when(remoteDataSource.loginUser('', '')).thenThrow(UnknownException());

        final result = await authRepo.loginUser('', '');

        verify(remoteDataSource.loginUser('', ''));

        expect(result, Left(UnknownFailure()));
      });

      test(
          'should return [UnauthorizedTokenFailure] if the remote call throws [UnauthorizedTokenException]',
          () async {
        when(remoteDataSource.loginUser('', ''))
            .thenThrow(UnauthorizedTokenException());

        final result = await authRepo.loginUser('', '');

        verify(remoteDataSource.loginUser('', ''));

        expect(result, Left(UnauthorizedTokenFailure()));
      });

      test(
          'should return [CacheFailure] if the database throws [InvalidDataException]',
          () async {
        when(remoteDataSource.loginUser('', ''))
            .thenThrow(InvalidDataException(null));

        final result = await authRepo.loginUser('', '');

        verify(remoteDataSource.loginUser('', ''));

        expect(result, Left(CacheFailure()));
      });
    });

    group('forgotPassword', () {
      test('should check if the device is online', () async {
        authRepo.forgotPassword('');

        verify(netWorkInfo.isConnected());
        expect(await netWorkInfo.isConnected(), true);
      });
      test('should return a string if call is successful', () async {
        when(remoteDataSource.forgotPassword('')).thenAnswer((_) async => '');

        final result = await authRepo.forgotPassword('');

        expect(result, Right(''));
      });

      test('should return [UnknownFailure] if call throws [UnknownException]',
          () async {
        when(remoteDataSource.forgotPassword('')).thenThrow(UnknownException());

        final result = await authRepo.forgotPassword('');

        expect(result, Left(UnknownFailure()));
      });
    });

    group('getUser', () {
      test('should check if the device is online', () async {
        authRepo.getUser();

        verify(netWorkInfo.isConnected());
        expect(await netWorkInfo.isConnected(), true);
      });

      test(
          'should return [UnauthorizedTokenFailure] if call throws [UnauthorizedTokenException]',
          () async {
        when(remoteDataSource.getUser())
            .thenThrow(UnauthorizedTokenException());

        final result = await authRepo.getUser();

        expect(result, Left(UnauthorizedTokenFailure()));
      });

      test('should return [user] if call is success', () async {
        when(remoteDataSource.getUser()).thenAnswer((_) async => user);

        final result = await authRepo.getUser();

        expect(result, Right(user));
      });

      test('should return [UnknownFailure] if call throws [UnknownException]',
          () async {
        when(remoteDataSource.getUser()).thenThrow(UnknownException());

        final result = await authRepo.getUser();

        expect(result, Left(UnknownFailure()));
      });
    });

    group('editUser', () {
      test('should check if the device is online', () async {
        authRepo.editUser(null, null, null, null, null, null, null, null);

        verify(netWorkInfo.isConnected());
        expect(await netWorkInfo.isConnected(), true);
      });

      test('should return [user] if call is success', () async {
        when(remoteDataSource.editUser(
                null, null, null, null, null, null, null, null))
            .thenAnswer((_) async => user);

        final result = await authRepo.editUser(
            null, null, null, null, null, null, null, null);

        expect(result, Right(user));
      });

      test(
          'should return [UserFieldsErrorFailure] if call throws [FieldsException]',
          () async {
        final fieldsFailure = UserFieldsFailure(
          email: ['This field is required.'],
          userName: ['A user with this username is already exists.'],
        );

        final fieldsException =
            FieldsException(body: fixture('registration_fields_error.json'));

        when(remoteDataSource.editUser(
                null, null, null, null, null, null, null, null))
            .thenThrow(fieldsException);

        final result = await authRepo.editUser(
            null, null, null, null, null, null, null, null);

        expect(result, Left(fieldsFailure));
      });

      test(
          'should return [UnauthorizedTokenFailure] if call throws [UnauthorizedTokenException]',
          () async {
        when(remoteDataSource.editUser(
                null, null, null, null, null, null, null, null))
            .thenThrow(UnauthorizedTokenException());

        final result = await authRepo.editUser(
            null, null, null, null, null, null, null, null);

        expect(result, Left(UnauthorizedTokenFailure()));
      });

      test('should return [UnknownFailure] if call throws [UnknownException]',
          () async {
        when(remoteDataSource.editUser(
                null, null, null, null, null, null, null, null))
            .thenThrow(UnknownException());

        final result = await authRepo.editUser(
            null, null, null, null, null, null, null, null);

        expect(result, Left(UnknownFailure()));
      });
    });
  });

  group('device is offline', () {
    setUp(() {
      when(netWorkInfo.isConnected()).thenAnswer((_) async => false);
    });

    group('registerUser', () {
      test('should return false if user has no connection', () async {
        authRepo.registerUser('', '', '', '', '', '');
        verify(netWorkInfo.isConnected());
        expect(await netWorkInfo.isConnected(), false);
      });

      test('should return [noInternetFailure] if user has no connection',
          () async {
        final result = await authRepo.registerUser('', '', '', '', '', '');

        expect(result, Left(NoInternetFailure()));
      });
    });

    group('loginUser', () {
      test('should return [NoInternetFailure] if user has no connection',
          () async {
        final result = await authRepo.loginUser('', '');

        expect(result, Left(NoInternetFailure()));
      });
    });

    group('forgotPassword', () {
      test('should return false if user has no connection', () async {
        authRepo.forgotPassword('');
        verify(netWorkInfo.isConnected());
        expect(await netWorkInfo.isConnected(), false);
      });

      test('should return [noInternetFailure] if user has no connection',
          () async {
        final result = await authRepo.forgotPassword('');

        expect(result, Left(NoInternetFailure()));
      });
    });

    group('getUser', () {
      test('should return false if user has no connection', () async {
        authRepo.getUser();
        verify(netWorkInfo.isConnected());
        expect(await netWorkInfo.isConnected(), false);
      });

      test('should return [noInternetFailure] if user has no connection',
          () async {
        final result = await authRepo.getUser();

        expect(result, Left(NoInternetFailure()));
      });
    });

    group('editUser', () {
      test('should return false if user has no connection', () async {
        authRepo.editUser(null, null, null, null, null, null, null, null);
        verify(netWorkInfo.isConnected());
        expect(await netWorkInfo.isConnected(), false);
      });

      test('should return [noInternetFailure] if user has no connection',
          () async {
        final result = await authRepo.editUser(
            null, null, null, null, null, null, null, null);

        expect(result, Left(NoInternetFailure()));
      });
    });
  });
}
