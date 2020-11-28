import 'package:moor_flutter/moor_flutter.dart';

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
}
