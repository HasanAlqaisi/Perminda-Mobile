import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:perminda/core/errors/exception.dart';
import 'package:perminda/core/errors/failure.dart';
import 'package:perminda/core/network/network_info.dart';
import 'package:perminda/data/data_sources/user_notifications/notifications_local_source.dart';
import 'package:perminda/data/data_sources/user_notifications/notifications_remote_source.dart';
import 'package:perminda/data/db/models/user_notification/notification_table.dart';
import 'package:perminda/data/remote_models/user_notifications/results.dart';
import 'package:perminda/data/remote_models/user_notifications/user_notifications.dart';
import 'package:perminda/data/repos/user_notifications/user_notifications_repo_impl.dart';

import '../../../fixtures/fixture_reader.dart';

class MockNetworkInfo extends Mock implements NetWorkInfo {}

class MockRemoteSource extends Mock implements NotificationsRemoteSource {}

class MockLocalSource extends Mock implements NotificationsLocalSource {}

void main() {
  MockNetworkInfo netWorkInfo;
  MockRemoteSource remoteSource;
  MockLocalSource localSource;
  UserNotificationsRepoImpl repo;

  setUp(() {
    netWorkInfo = MockNetworkInfo();
    remoteSource = MockRemoteSource();
    localSource = MockLocalSource();
    repo = UserNotificationsRepoImpl(
      netWorkInfo: netWorkInfo,
      remoteSource: remoteSource,
      localSource: localSource,
    );
  });

  group('device is online', () {
    setUp(() {
      when(netWorkInfo.isConnected()).thenAnswer((_) async => true);
    });

    group('getNotifications', () {
      final userNotifications = UserNotifications.fromJson(
          json.decode(fixture('user_notifications.json')));

      test('should user has an internet connection', () async {
        when(remoteSource.getNotificatons(repo.offset))
            .thenAnswer((_) async => userNotifications);

        await repo.getNotifications();

        verify(netWorkInfo.isConnected());
        expect(await netWorkInfo.isConnected(), true);
      });

      test('should cache list of [UserNotifications] in the databasee',
          () async {
        when(remoteSource.getNotificatons(repo.offset))
            .thenAnswer((_) async => userNotifications);

        when(localSource.insertUserNotifications(
            UserNotificationTable.fromNotificationsResult(
          userNotifications.results,
        ))).thenAnswer((_) async => null);

        await repo.getNotifications();

        verify(localSource.insertUserNotifications(any));
      });

      test('should cache the offset', () async {
        when(remoteSource.getNotificatons(repo.offset))
            .thenAnswer((_) async => userNotifications);

        await repo.getNotifications();

        expect(repo.offset, 400);
      });

      test('should return list of [UserNotification] if remote call is success',
          () async {
        when(remoteSource.getNotificatons(repo.offset))
            .thenAnswer((_) async => userNotifications);

        final result = await repo.getNotifications();

        expect(result, Right(userNotifications));
      });

      test(
          'should return [UnauthorizedTokenFailure] if remote call throws [UnauthorizedTokenException]',
          () async {
        when(remoteSource.getNotificatons(repo.offset))
            .thenThrow(UnauthorizedTokenException());

        final result = await repo.getNotifications();

        expect(result, Left(UnauthorizedTokenFailure()));
      });

      test(
          'shuold return [UnknownFailure] if remote call throws [UnknownException]',
          () async {
        when(remoteSource.getNotificatons(repo.offset))
            .thenThrow(UnknownException());
        final result = await repo.getNotifications();
        expect(result, Left(UnknownFailure()));
      });
    });

    group('editNotification', () {
      final userNotification = UserNotificationsReusult.fromJson(
          json.decode(fixture('user_notification.json')));

      test('should user has an internet connection', () async {
        when(remoteSource.editNotification(userNotification.id))
            .thenAnswer((_) async => userNotification);

        await repo.editNotification(userNotification.id);

        verify(netWorkInfo.isConnected());
        expect(await netWorkInfo.isConnected(), true);
      });

      test('should return [UserNotification] if remote call is success',
          () async {
        when(remoteSource.editNotification(userNotification.id))
            .thenAnswer((_) async => userNotification);

        final result = await repo.editNotification(userNotification.id);

        expect(result, Right(userNotification));
      });

      test('should cache [UserNotifications] in the databasee', () async {
        when(remoteSource.editNotification(userNotification.id))
            .thenAnswer((_) async => userNotification);

        when(localSource.insertUserNotifications(
            UserNotificationTable.fromNotificationsResult(
                [userNotification]))).thenAnswer((_) async => null);

        await repo.editNotification(userNotification.id);

        verify(localSource.insertUserNotifications(any));
      });

      test(
          'should return [ItemNotFoundFailure] if remote call throws [ItemNotFoundException]',
          () async {
        when(remoteSource.editNotification(userNotification.id))
            .thenThrow(ItemNotFoundException());

        final result = await repo.editNotification(userNotification.id);

        expect(result, Left(ItemNotFoundFailure()));
      });

      test(
          'shuold return [UnauthorizedTokenFailure] if remote call throws [UnauthorizedTokenException]',
          () async {
        when(remoteSource.editNotification(userNotification.id))
            .thenThrow(UnauthorizedTokenException());

        final result = await repo.editNotification(userNotification.id);

        expect(result, Left(UnauthorizedTokenFailure()));
      });

      test(
          'shuold return [UnknownFailure] if remote call throws [UnknownException]',
          () async {
        when(remoteSource.editNotification(userNotification.id))
            .thenThrow(UnknownException());
        final result = await repo.editNotification(userNotification.id);
        expect(result, Left(UnknownFailure()));
      });
    });

    group('deleteNotification', () {
      test('should user has an internet connection', () async {
        await repo.deleteNotification('');
        verify(netWorkInfo.isConnected());
        expect(await netWorkInfo.isConnected(), true);
      });

      test('should return [true] if remote call is success', () async {
        when(remoteSource.deleteNotification('')).thenAnswer((_) async => true);

        final result = await repo.deleteNotification('');

        expect(result, Right(true));
      });

      test(
          'should return [ItemNotFoundFailure] if remote call throws [ItemNotFoundException]',
          () async {
        when(remoteSource.deleteNotification(''))
            .thenThrow(ItemNotFoundException());

        final result = await repo.deleteNotification('');

        expect(result, Left(ItemNotFoundFailure()));
      });

      test(
          'shuold return [UnauthorizedTokenFailure] if remote call throws [UnauthorizedTokenException]',
          () async {
        when(remoteSource.deleteNotification(''))
            .thenThrow(UnauthorizedTokenException());

        final result = await repo.deleteNotification('');

        expect(result, Left(UnauthorizedTokenFailure()));
      });

      test(
          'shuold return [UnknownFailure] if remote call throws [UnknownException]',
          () async {
        when(remoteSource.deleteNotification('')).thenThrow(UnknownException());

        final result = await repo.deleteNotification('');

        expect(result, Left(UnknownFailure()));
      });
    });
  });

  group('device is offline', () {
    setUp(() {
      when(netWorkInfo.isConnected()).thenAnswer((_) async => false);
    });

    group('getNotifications', () {
      test('should return false if user has no internet connection', () async {
        await repo.getNotifications();
        verify(netWorkInfo.isConnected());
        expect(await netWorkInfo.isConnected(), false);
      });

      test('should return [NoInternetFailure] if user has no internet',
          () async {
        final result = await repo.getNotifications();
        expect(result, Left(NoInternetFailure()));
      });
    });

    group('editNotification', () {
      test('should return false if user has no internet connection', () async {
        await repo.editNotification('');
        verify(netWorkInfo.isConnected());
        expect(await netWorkInfo.isConnected(), false);
      });

      test('should return [NoInternetFailure] if user has no internet',
          () async {
        final result = await repo.editNotification('');
        expect(result, Left(NoInternetFailure()));
      });
    });

    group('deleteNotification', () {
      test('should return false if user has no internet connection', () async {
        await repo.deleteNotification('');
        verify(netWorkInfo.isConnected());
        expect(await netWorkInfo.isConnected(), false);
      });

      test('should return [NoInternetFailure] if user has no internet',
          () async {
        final result = await repo.deleteNotification('');
        expect(result, Left(NoInternetFailure()));
      });
    });
  });
}
