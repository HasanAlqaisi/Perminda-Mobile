import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'results.g.dart';

@JsonSerializable(explicitToJson: true)
class CartItemsResult extends Equatable {
  @JsonKey(name: 'pk')
  final String id;
  @JsonKey(name: 'user')
  final String userId;
  @JsonKey(name: 'product')
  final String productId;
  final int quantity;

  CartItemsResult(this.id, this.userId, this.productId, this.quantity);

  factory CartItemsResult.fromJson(Map<String, dynamic> json) =>
      _$CartItemsResultFromJson(json);

  Map<String, dynamic> toJson() => _$CartItemsResultToJson(this);

  @override
  List<Object> get props => [id, userId, productId, quantity];
}
