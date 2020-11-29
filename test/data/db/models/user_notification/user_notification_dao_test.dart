import 'package:flutter_test/flutter_test.dart';
import 'package:moor_ffi/moor_ffi.dart';
import 'package:perminda/data/db/app_database/app_database.dart';

import '../../dummy_models.dart';

void main() {
  AppDatabase db;

  setUp(() {
    db = AppDatabase(VmDatabase.memory());
  });

  tearDown(() async {
    db.close();
  });

  group('watchUserNotifications', () {
    test('should return list of [NotificationData] in a correct way', () async {
      db.userDao.insertUser(DummyModels.user1);
      db.userDao.insertUser(DummyModels.user2);
      db.userNotificationDao
          .insertUserNotifications([DummyModels.user1Notification1]);
      db.userNotificationDao
          .insertUserNotifications([DummyModels.user1Notification2]);
      db.userNotificationDao
          .insertUserNotifications([DummyModels.user2Notification1]);
      db.userNotificationDao
          .insertUserNotifications([DummyModels.user2Notification2]);

      final result = db.userNotificationDao
          .watchUserNotifications(DummyModels.user2.id.value);

      (await result.first).forEach((notification) {
        print('notification ${notification.toString()}');
      });
    });
  });
}
