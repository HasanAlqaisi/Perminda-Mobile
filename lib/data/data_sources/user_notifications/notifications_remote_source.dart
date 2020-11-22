import 'dart:convert';

import 'package:perminda/core/constants/sensetive_constants.dart';
import 'package:perminda/core/errors/exception.dart';
import 'package:perminda/data/remote_models/user_notifications/results.dart';
import 'package:http/http.dart' as http;
import 'package:perminda/data/remote_models/user_notifications/user_notifications.dart';

abstract class NotificationsRemoteSource {
  Future<UserNotifications> getNotificatons(int offset);

  Future<UserNotificationsReusult> editNotification(String id);

  Future<bool> deleteNotification(String id);
}

class NotificationsRemoteSourceImpl extends NotificationsRemoteSource {
  final http.Client client;

  NotificationsRemoteSourceImpl({this.client});

  @override
  Future<bool> deleteNotification(String id) async {
    final response = await client.delete('$baseUrl/api/user-notification/$id/',
        headers: {'Authorization': token});

    if (response.statusCode == 204) {
      return true;
    } else if (response.statusCode == 401) {
      throw UnauthorizedTokenException();
    } else if (response.statusCode == 404) {
      throw ItemNotFoundException();
    } else {
      throw UnknownException();
    }
  }

  @override
  Future<UserNotificationsReusult> editNotification(String id) async {
    final response = await client.put('$baseUrl/api/user-notification/$id/',
        headers: {'Authorization': token});

    if (response.statusCode == 200) {
      return UserNotificationsReusult.fromJson(json.decode(response.body));
    } else if (response.statusCode == 401) {
      throw UnauthorizedTokenException();
    } else if (response.statusCode == 404) {
      throw ItemNotFoundException();
    } else {
      throw UnknownException();
    }
  }

  @override
  Future<UserNotifications> getNotificatons(int offset) async {
    final response = await client.get(
        '$baseUrl/api/user-notification?limit=10&offset=$offset',
        headers: {
          'Authorization': token,
        });

    if (response.statusCode == 200) {
      return UserNotifications.fromJson(json.decode(response.body));
    } else if (response.statusCode == 401) {
      throw UnauthorizedTokenException();
    } else {
      throw UnknownException();
    }
  }
}
