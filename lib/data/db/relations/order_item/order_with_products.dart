import 'package:equatable/equatable.dart';

import 'package:perminda/data/db/app_database/app_database.dart';
import 'package:perminda/data/db/relations/order_item/product_info.dart';

class OrderWithProducts extends Equatable {
  final OrderData order;
  final List<ProductInfo> products;

  OrderWithProducts({this.order, this.products});

  @override
  List<Object> get props => [order, products];
}
