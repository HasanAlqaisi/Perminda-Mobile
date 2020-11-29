import 'package:moor_flutter/moor_flutter.dart';
import 'package:perminda/data/db/app_database/app_database.dart';
import 'package:perminda/data/db/models/user/user_table.dart';
import 'package:perminda/data/db/models/user_notification/notification_table.dart';

part 'user_notification_dao.g.dart';

@UseDao(tables: [UserNotificationTable, UserTable])
class UserNotificationDao extends DatabaseAccessor<AppDatabase>
    with _$UserNotificationDaoMixin {
  UserNotificationDao(AppDatabase db) : super(db);

  Future<void> insertUserNotifications(
      List<UserNotificationTableCompanion> notifications) async {
    await batch((batch) {
      batch.insertAllOnConflictUpdate(userNotificationTable, notifications);
    });
  }

  /// There's a relation between user and his notifcations [one-to-many]
  /// in this query we don't need the user info
  /// So we brought only his notifications based on his id
  Stream<List<NotificationData>> watchUserNotifications(String userId) {
    return (select(userNotificationTable)
          ..where((userNotificationTable) =>
              userNotificationTable.user.equals(userId)))
        .watch();
  }

  Future<int> deleteUserNotifications(String userId) =>
      (delete(userNotificationTable)..where((tbl) => tbl.user.equals(userId)))
          .go();

  Future<int> deleteUserNotificationById(String notificationId) =>
      (delete(userNotificationTable)
            ..where((tbl) => tbl.id.equals(notificationId)))
          .go();
}
