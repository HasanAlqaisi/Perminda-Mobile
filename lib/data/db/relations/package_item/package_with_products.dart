import 'package:equatable/equatable.dart';
import 'package:perminda/data/db/app_database/app_database.dart';
import 'package:perminda/data/db/relations/order_item/product_info.dart';

class PackageWithProducts extends Equatable {
  final PackageData package;
  final List<ProductInfo> products;

  PackageWithProducts({this.package, this.products});

  @override
  List<Object> get props => [package, products];
}
