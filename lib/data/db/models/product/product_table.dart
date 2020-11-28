import 'package:moor_flutter/moor_flutter.dart';

@DataClassName('ProductData')
class ProductTable extends Table {
  TextColumn get id => text()();
  TextColumn get shop => text().customConstraint('REFERENCES shop_table(id)')();
  TextColumn get category =>
      text().customConstraint('REFERENCES category_table(id)')();
  TextColumn get brand =>
      text().nullable().customConstraint('NULL REFERENCES brand_table(id)')();
  TextColumn get name => text()();
  RealColumn get price => real()();
  IntColumn get sale => integer()();
  TextColumn get overview => text()();
  DateTimeColumn get deliveryTime => dateTime()();
  RealColumn get rate => real()();
  IntColumn get buyers => integer()();
  IntColumn get numReviews => integer()();
  BoolColumn get active => boolean().withDefault(Constant(false))();
  IntColumn get quantity => integer()();
  DateTimeColumn get dateAdded => dateTime()();
  DateTimeColumn get dateFirstActive => dateTime().nullable()();
  DateTimeColumn get lastUpdate => dateTime()();

  @override
  String get tableName => 'product_table';

  @override
  Set<Column> get primaryKey => {id};
}
