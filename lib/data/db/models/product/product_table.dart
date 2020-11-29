import 'package:moor_flutter/moor_flutter.dart';
import 'package:perminda/data/db/app_database/app_database.dart';
import 'package:perminda/data/remote_models/products/results.dart';

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
  IntColumn get deliveryTime => integer()();
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

  static List<ProductTableCompanion> fromProductsesult(
      List<ProductsResult> productsResult) {
    return productsResult
        .map(
          (result) => ProductTableCompanion(
            id: Value(result.id),
            shop: Value(result.shopId),
            category: Value(result.categoryId),
            brand: Value(result.brandId),
            name: Value(result.name),
            price: Value(result.price),
            sale: Value(result.sale),
            overview: Value(result.overview),
            deliveryTime: Value(result.deliveryTime),
            rate: Value(result.rate),
            buyers: Value(result.buyers),
            numReviews: Value(result.nfReviews),
            active: Value(result.active),
            quantity: Value(result.quantity),
            dateFirstActive: Value(result.dateFirstActivated != null
                ? DateTime.tryParse(result.dateFirstActivated)
                : null),
            dateAdded: Value(DateTime.tryParse(result.dateAdded)),
            lastUpdate: Value(DateTime.tryParse(result.lastUpdate)),
          ),
        )
        .toList();
  }
}
