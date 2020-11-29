import 'package:moor_flutter/moor_flutter.dart';
import 'package:perminda/data/db/app_database/app_database.dart';
import 'package:perminda/data/remote_models/user_notifications/results.dart';

@DataClassName('NotificationData')
class UserNotificationTable extends Table {
  TextColumn get id => text()();
  TextColumn get user => text().customConstraint('REFERENCES user_table(id)')();
  TextColumn get message => text()();
  BoolColumn get read => boolean().withDefault(Constant(false))();
  DateTimeColumn get dateSent => dateTime()();

  @override
  String get tableName => 'user_notif_table';

  @override
  Set<Column> get primaryKey => {id};

  static List<UserNotificationTableCompanion> fromNotificationsResult(
      List<UserNotificationsReusult> notificatoinsResult) {
    return notificatoinsResult
        .map(
          (result) => UserNotificationTableCompanion(
            id: Value(result.id),
            user: Value(result.userId),
            message: Value(result.message),
            read: Value(result.hasRead),
            dateSent: Value(DateTime.tryParse(result.dateSent)),
          ),
        )
        .toList();
  }
}
