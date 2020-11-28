import 'package:moor_flutter/moor_flutter.dart';
import 'package:perminda/data/db/app_database/app_database.dart';
import 'package:perminda/data/db/models/user/user_table.dart';
import 'package:perminda/data/db/models/user_notification/notification_table.dart';

part 'user_notification_dao.g.dart';

@UseDao(tables: [UserNotificationTable, UserTable])
class UserNotificationDao extends DatabaseAccessor<AppDatabase>
    with _$UserNotificationDaoMixin {
  UserNotificationDao(AppDatabase db) : super(db);

  Future<int> insertUserNotification(
          UserNotificationTableCompanion userNotification) =>
      into(userNotificationTable)
          .insert(userNotification, mode: InsertMode.insertOrReplace);

  /// There's a relation between user and his notifcations [one-to-many]
  /// in this query we don't need the user info
  /// So we brought only his notifications based on his id
  Stream<List<NotificationData>> watchUserNotifications(String userId) {
    return (select(userNotificationTable)
          ..where((userNotificationTable) =>
              userNotificationTable.user.equals(userId)))
        .watch();
  }
}
