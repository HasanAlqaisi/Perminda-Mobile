import 'package:moor_flutter/moor_flutter.dart';
import 'package:perminda/data/db/app_database/app_database.dart';
import 'package:perminda/data/remote_models/orders/results.dart';

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
  DateTimeColumn get dateShipped => dateTime().nullable()();
  DateTimeColumn get dateRecieved => dateTime().nullable()();

  @override
  String get tableName => 'order_table';

  @override
  Set<Column> get primaryKey => {id};

  static List<OrderTableCompanion> fromOrdersResult(
      List<OrdersResult> ordersResult) {
    return ordersResult
        .map(
          (result) => OrderTableCompanion(
            id: Value(result.id),
            user: Value(result.userId),
            address: Value(result.address),
            productCosts: Value(result.productsCost),
            shippingFee: Value(result.shippingFee),
            stage: Value(result.stage),
            datePrepared: Value(result.datePrepared != null
                ? DateTime.tryParse(result.datePrepared)
                : null),
            dateSent: Value(result.dateSent != null
                ? DateTime.tryParse(result.dateSent)
                : null),
            dateRecieved: Value(result.dateReceived != null
                ? DateTime.tryParse(result.dateReceived)
                : null),
            dateShipped: Value(result.dateShipped != null
                ? DateTime.tryParse(result.dateShipped)
                : null),
          ),
        )
        .toList();
  }
}
