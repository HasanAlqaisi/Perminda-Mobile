import 'package:equatable/equatable.dart';

import 'package:perminda/data/db/app_database/app_database.dart';

class ProductAndCategoryAndBrandAndShop extends Equatable {
  final ProductData product;
  final CategoryData category;
  final BrandData brand;
  final ShopData shop;

  ProductAndCategoryAndBrandAndShop(
      {this.product, this.category, this.brand, this.shop});

  @override
  List<Object> get props => [product, category, brand, shop];

  @override
  bool get stringify => true;
}
