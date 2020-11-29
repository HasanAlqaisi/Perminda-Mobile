import 'package:moor_flutter/moor_flutter.dart';
import 'package:perminda/data/db/app_database/app_database.dart';
import 'package:perminda/data/db/models/user_notification/user_notification_dao.dart';

abstract class NotificationsLocalSource {
  Future<void> insertUserNotifications(
      List<UserNotificationTableCompanion> userNotifications);

  Stream<List<NotificationData>> watchUserNotifications(String userId);

  Future<int> deleteUserNotificationById(String notificationId);
}

class NotificationsLocalSourceImpl extends NotificationsLocalSource {
  final UserNotificationDao userNotificationDao;

  NotificationsLocalSourceImpl({this.userNotificationDao});

  @override
  Future<void> insertUserNotifications(
      List<UserNotificationTableCompanion> userNotifications) {
    try {
      return userNotificationDao.insertUserNotifications(userNotifications);
    } on InvalidDataException {
      rethrow;
    }
  }

  @override
  Stream<List<NotificationData>> watchUserNotifications(String userId) {
    return userNotificationDao.watchUserNotifications(userId);
  }

  @override
  Future<int> deleteUserNotificationById(String notificationId) {
    return userNotificationDao.deleteUserNotificationById(notificationId);
  }
}
