import 'package:moor_flutter/moor_flutter.dart';

@DataClassName('ReviewData')
class ReviewTable extends Table {
  TextColumn get id => text()();
  TextColumn get user => text().customConstraint('REFERENCES user_table(id)')();
  TextColumn get product =>
      text().customConstraint('REFERENCES product_table(id)')();
  IntColumn get rate => integer()();
  TextColumn get message => text().nullable()();
  DateTimeColumn get dateWrote => dateTime()();
  DateTimeColumn get lastUpdate => dateTime()();

  @override
  String get tableName => 'review_table';

  @override
  Set<Column> get primaryKey => {id};
}
