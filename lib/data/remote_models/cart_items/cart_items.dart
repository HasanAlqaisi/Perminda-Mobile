import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:perminda/data/remote_models/cart_items/results.dart';

part 'cart_items.g.dart';

@JsonSerializable()
class CartItems extends Equatable {
  final int count;
  @JsonKey(name: 'next', nullable: true)
  final String nextPage;
  @JsonKey(name: 'previous', nullable: true)
  final String previousPage;
  final List<CartItemsResult> results;

  CartItems(this.count, this.nextPage, this.previousPage, this.results);

  factory CartItems.fromJson(Map<String, dynamic> json) =>
      _$CartItemsFromJson(json);

  Map<String, dynamic> toJson() => _$CartItemsToJson(this);

  @override
  List<Object> get props => [count, nextPage, previousPage, results];
}
