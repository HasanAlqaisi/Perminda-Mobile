import 'package:moor_flutter/moor_flutter.dart';
import 'package:perminda/data/db/app_database/app_database.dart';
import 'package:perminda/data/remote_models/shops/results.dart';

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

  static List<ShopTableCompanion> fromShopsResult(
      List<ShopsResult> shopsResult) {
    return shopsResult
        .map(
          (shopResult) => ShopTableCompanion(
            id: Value(shopResult.id),
            user: Value(shopResult.userId),
            name: Value(shopResult.name),
            dateCreated: Value(DateTime.tryParse(shopResult.dateCreated)),
          ),
        )
        .toList();
  }
}
