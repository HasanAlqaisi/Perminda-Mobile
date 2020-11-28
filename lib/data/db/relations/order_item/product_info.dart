import 'package:equatable/equatable.dart';

import 'package:perminda/data/db/app_database/app_database.dart';
import 'package:perminda/data/db/relations/category/category_and_parent.dart';

class ProductInfo extends Equatable {
  final ProductData product;
  final CategoryAndParent category;
  final BrandData brand;
  final ShopData shop;

  ProductInfo({this.product, this.category, this.brand, this.shop});

  @override
  List<Object> get props => [product, category, brand, shop];
}
