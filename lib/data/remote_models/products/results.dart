import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'results.g.dart';

@JsonSerializable(explicitToJson: true)
class ProductsResult extends Equatable {
  @JsonKey(name: 'pk')
  final String id;
  @JsonKey(name: 'shop')
  final String shopId;
  @JsonKey(name: 'category')
  final String categoryId;
  @JsonKey(nullable: true, name: 'brand')
  final String brandId;
  final String name;
  final double price;
  final int sale;
  final String overview;
  final int deliveryTime;
  final double rate;
  final int buyers;
  final int nfReviews;
  final bool active;
  final int quantity;
  final String dateAdded;
  final String dateFirstActivated;
  final String lastUpdate;

  ProductsResult(
      {this.id,
      this.shopId,
      this.categoryId,
      this.brandId,
      this.name,
      this.price,
      this.sale,
      this.overview,
      this.deliveryTime,
      this.rate,
      this.buyers,
      this.nfReviews,
      this.active,
      this.quantity,
      this.dateAdded,
      this.dateFirstActivated,
      this.lastUpdate});

  factory ProductsResult.fromJson(Map<String, dynamic> json) =>
      _$ProductsResultFromJson(json);

  Map<String, dynamic> toJson() => _$ProductsResultToJson(this);

  @override
  List<Object> get props {
    return [
      id,
      shopId,
      categoryId,
      brandId,
      name,
      price,
      sale,
      overview,
      deliveryTime,
      rate,
      buyers,
      nfReviews,
      active,
      quantity,
      dateAdded,
      dateFirstActivated,
      lastUpdate,
    ];
  }

  @override
  bool get stringify => true;
}
