import 'package:moor_flutter/moor_flutter.dart';
import 'package:perminda/data/db/app_database/app_database.dart';
import 'package:perminda/data/db/models/user_notification/user_notification_dao.dart';

abstract class NotificationsLocalSource {
  Future<int> insertUserNotification(
      UserNotificationTableCompanion userNotification);

  Stream<List<NotificationData>> watchUserNotifications(String userId);
}

class NotificationsLocalSourceImpl extends NotificationsLocalSource {
  final UserNotificationDao userNotificationDao;

  NotificationsLocalSourceImpl({this.userNotificationDao});

  @override
  Future<int> insertUserNotification(
      UserNotificationTableCompanion userNotification) {
    try {
      return userNotificationDao.insertUserNotification(userNotification);
    } on InvalidDataException {
      rethrow;
    }
  }

  @override
  Stream<List<NotificationData>> watchUserNotifications(String userId) {
    return userNotificationDao.watchUserNotifications(userId);
  }
}
