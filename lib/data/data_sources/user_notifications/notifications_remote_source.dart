import 'dart:convert';

import 'package:perminda/core/constants/sensetive_constants.dart';
import 'package:perminda/core/errors/exception.dart';
import 'package:perminda/data/remote_models/user_notifications/user_notification.dart';
import 'package:http/http.dart' as http;

abstract class NotificationsRemoteSource {
  Future<List<UserNotification>> getNotificatons();

  Future<UserNotification> editNotification(String id);

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
  Future<UserNotification> editNotification(String id) async {
    final response = await client.put('$baseUrl/api/user-notification/$id/',
        headers: {'Authorization': token});

    if (response.statusCode == 200) {
      return UserNotification.fromJson(json.decode(response.body));
    } else if (response.statusCode == 401) {
      throw UnauthorizedTokenException();
    } else if (response.statusCode == 404) {
      throw ItemNotFoundException();
    } else {
      throw UnknownException();
    }
  }

  @override
  Future<List<UserNotification>> getNotificatons() async {
    final response =
        await client.get('$baseUrl/api/user-notification/', headers: {
      'Authorization': token,
    });

    if (response.statusCode == 200) {
      return (json.decode(response.body) as List)
          .map((notification) => UserNotification.fromJson(notification))
          .toList();
    } else if (response.statusCode == 401) {
      throw UnauthorizedTokenException();
    } else {
      throw UnknownException();
    }
  }
}
