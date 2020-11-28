import 'package:moor_flutter/moor_flutter.dart';

@DataClassName('FavouriteItemData')
class FavouriteItemTable extends Table {
  TextColumn get user => text().customConstraint('REFERENCES user_table(id)')();
  TextColumn get product =>
      text().customConstraint('REFERENCES product_table(id)')();

  @override
  String get tableName => 'favourite_item_table';

  @override
  Set<Column> get primaryKey => {user, product};
}
