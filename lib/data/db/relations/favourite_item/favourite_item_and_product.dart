import 'package:equatable/equatable.dart';

import 'package:perminda/data/db/app_database/app_database.dart';
import 'package:perminda/data/db/relations/category/category_and_parent.dart';

class FavouriteItemAndProduct extends Equatable {
  final FavouriteItemData favouriteItem;
  final ProductData product;
  final CategoryAndParent category;
  final BrandData brand;
  final ShopData shop;

  FavouriteItemAndProduct(
      {this.favouriteItem, this.product, this.category, this.brand, this.shop});

  @override
  List<Object> get props {
    return [
      favouriteItem,
      product,
      category,
      brand,
      shop,
    ];
  }

  @override
  bool get stringify => true;
}
