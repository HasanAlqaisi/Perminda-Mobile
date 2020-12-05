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
  final String image;
  final double price;
  final int sale;
  final String overview;
  @JsonKey(name: 'delivery_time')
  final int deliveryTime;
  final double rate;
  final int buyers;
  @JsonKey(name: 'nf_reviews')
  final int nfReviews;
  final bool active;
  final int quantity;
  @JsonKey(name: 'date_added')
  final String dateAdded;
  @JsonKey(nullable: true, name: 'date_first_activated')
  final String dateFirstActivated;
  @JsonKey(name: 'last_update')
  final String lastUpdate;

  ProductsResult(
      {this.id,
      this.shopId,
      this.categoryId,
      this.brandId,
      this.name,
      this.image,
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
      image,
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
