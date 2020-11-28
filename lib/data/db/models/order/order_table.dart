import 'package:moor_flutter/moor_flutter.dart';

@DataClassName('OrderData')
class OrderTable extends Table {
  TextColumn get id => text()();
  TextColumn get user => text().customConstraint('REFERENCES user_table(id)')();
  TextColumn get address => text()();
  RealColumn get productCosts => real()();
  RealColumn get shippingFee => real()();
  IntColumn get stage => integer()();
  DateTimeColumn get dateSent => dateTime().nullable()();
  DateTimeColumn get datePrepared => dateTime().nullable()();
  DateTimeColumn get lastShipped => dateTime().nullable()();
  DateTimeColumn get lastRecieved => dateTime().nullable()();

  @override
  String get tableName => 'order_table';

  @override
  Set<Column> get primaryKey => {id};
}