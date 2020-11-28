import 'package:equatable/equatable.dart';
import 'package:perminda/data/db/app_database/app_database.dart';
import 'package:perminda/data/db/relations/category/category_and_parent.dart';

class CartItemAndProduct extends Equatable {
  final CartItemData cartItem;
  final ProductData product;
  final CategoryAndParent category;
  final BrandData brand;
  final ShopData shop;

  CartItemAndProduct(
      {this.cartItem, this.product, this.category, this.brand, this.shop});

  @override
  List<Object> get props {
    return [
      cartItem,
      product,
      category,
      brand,
      shop,
    ];
  }

  @override
  bool get stringify => true;
}
