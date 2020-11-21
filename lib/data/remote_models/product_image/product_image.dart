import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product_image.g.dart';

@JsonSerializable()
class ProductImage extends Equatable {
  final String id;
  @JsonKey(name: 'image')
  final String imageUrl;
  final int type;
  @JsonKey(name: 'product')
  final String productId;

  ProductImage(this.id, this.imageUrl, this.type, this.productId);

  factory ProductImage.fromJson(Map<String, dynamic> json) =>
      _$ProductImageFromJson(json);

  Map<String, dynamic> toJson() => _$ProductImageToJson(this);

  @override
  List<Object> get props => [id, imageUrl, type, productId];
}
