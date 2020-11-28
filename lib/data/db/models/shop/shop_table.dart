import 'package:moor_flutter/moor_flutter.dart';

@DataClassName('ShopData')
class ShopTable extends Table {
  TextColumn get id => text()();
  TextColumn get user => text().customConstraint('REFERENCES user_table(id)')();
  TextColumn get name => text()();
  DateTimeColumn get dateCreated => dateTime()();

  @override
  String get tableName => 'shop_table';

  @override
  Set<Column> get primaryKey => {id};
}
