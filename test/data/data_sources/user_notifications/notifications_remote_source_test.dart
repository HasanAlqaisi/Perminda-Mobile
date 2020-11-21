import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:perminda/core/constants/sensetive_constants.dart';
import 'package:perminda/core/errors/exception.dart';
import 'package:http/http.dart' as http;
import 'package:perminda/data/data_sources/user_notifications/notifications_remote_source.dart';
import 'package:perminda/data/remote_models/user_notifications/user_notification.dart';

import '../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  MockHttpClient client;
  NotificationsRemoteSourceImpl remoteSource;

  setUp(() {
    client = MockHttpClient();
    remoteSource = NotificationsRemoteSourceImpl(client: client);
  });

  void do401Response(String url, bool hasHeader) {
    when(client.get(url, headers: hasHeader ? anyNamed('headers') : null))
        .thenAnswer((_) async => http.Response(fixture('detail.json'), 401));
  }

  void do400Response(String url, bool hasHeader) {
    when(client.get(url, headers: hasHeader ? anyNamed('headers') : null))
        .thenAnswer((_) async => http.Response(fixture('detail.json'), 400));
  }

  group('getNotificatons', () {
    final userNotifcations =
        (json.decode(fixture('user_notifications.json')) as List)
            .map((notif) => UserNotification.fromJson(notif))
            .toList();

    void do200Response() {
      when(client.get(
        '$baseUrl/api/user-notification/',
        headers: anyNamed('headers'),
      )).thenAnswer(
          (_) async => http.Response(fixture('user_notifications.json'), 200));
    }

    test('should return list of [UserNotification] if response code is 200',
        () async {
      do200Response();
      final result = await remoteSource.getNotificatons();

      expect(result, userNotifcations);
    });

    test('should throw [UnauthorizedTokenException] if resonse code is 401',
        () {
      do401Response('$baseUrl/api/user-notification/', true);
      final result = remoteSource.getNotificatons;
      expect(() => result(), throwsA(isA<UnauthorizedTokenException>()));
    });

    test(
        'should throw [UnknownException] if resonse code is neither 200 nor 401',
        () {
      do400Response('$baseUrl/api/user-notification/', true);
      final result = remoteSource.getNotificatons;
      expect(() => result(), throwsA(isA<UnknownException>()));
    });
  });

  final userNotification =
      UserNotification.fromJson(json.decode(fixture('user_notification.json')));
  group('editNotification', () {
    void do200Response(String url, bool hasHeader) {
      when(client.put(url, headers: hasHeader ? anyNamed('headers') : null))
          .thenAnswer((_) async =>
              http.Response(fixture('user_notification.json'), 200));
    }

    test('should return [userNotification] if response code is 200', () async {
      do200Response(
          '$baseUrl/api/user-notification/${userNotification.id}/', true);

      final result = await remoteSource.editNotification(userNotification.id);

      expect(result, userNotification);
    });

    test('should throw [UnauthorizedTokenException] if resonse code is 401',
        () {
      when(client.put('$baseUrl/api/user-notification/${userNotification.id}/',
              headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(fixture('detail.json'), 401));

      final result = remoteSource.editNotification;
      expect(() => result(userNotification.id),
          throwsA(isA<UnauthorizedTokenException>()));
    });

    test('should throw [ItemNotFoundException] if resonse code is 404', () {
      when(client.put('$baseUrl/api/user-notification/${userNotification.id}/',
              headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(fixture('detail.json'), 404));

      final result = remoteSource.editNotification;
      expect(() => result(userNotification.id),
          throwsA(isA<ItemNotFoundException>()));
    });

    test('should throw [UnknownException] if resonse code is not expected', () {
      when(client.put('$baseUrl/api/user-notification/${userNotification.id}/',
              headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(fixture('detail.json'), 400));

      final result = remoteSource.editNotification;
      expect(
          () => result(userNotification.id), throwsA(isA<UnknownException>()));
    });
  });

  group('deleteNotification', () {
    test('should return [true] if response code is 204', () async {
      when(client.delete(
              '$baseUrl/api/user-notification/${userNotification.id}/',
              headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(fixture('detail.json'), 204));

      final result = await remoteSource.deleteNotification(userNotification.id);

      expect(result, true);
    });

    test('should throw [ItemNotFoundException] if resonse code is 404', () {
      when(client.delete(
              '$baseUrl/api/user-notification/${userNotification.id}/',
              headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(fixture('detail.json'), 404));

      final result = remoteSource.deleteNotification;
      expect(() => result(userNotification.id),
          throwsA(isA<ItemNotFoundException>()));
    });

    test('should throw [UnauthorizedTokenException] if resonse code is 401',
        () {
      when(client.delete(
              '$baseUrl/api/user-notification/${userNotification.id}/',
              headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(fixture('detail.json'), 401));

      final result = remoteSource.deleteNotification;
      expect(() => result(userNotification.id),
          throwsA(isA<UnauthorizedTokenException>()));
    });

    test('should throw [UnknownException] if resonse code is not expected', () {
      when(client.delete(
              '$baseUrl/api/user-notification/${userNotification.id}/',
              headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(fixture('detail.json'), 500));

      final result = remoteSource.deleteNotification;
      expect(
          () => result(userNotification.id), throwsA(isA<UnknownException>()));
    });
  });
}
