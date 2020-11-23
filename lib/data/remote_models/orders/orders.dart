import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:perminda/data/remote_models/orders/results.dart';

part 'orders.g.dart';

@JsonSerializable()
class Orders extends Equatable {
  final int count;
  @JsonKey(name: 'next', nullable: true)
  final String nextPage;
  @JsonKey(name: 'previous', nullable: true)
  final String previousPage;
  final List<OrdersResult> results;

  Orders(this.count, this.nextPage, this.previousPage, this.results);

  factory Orders.fromJson(Map<String, dynamic> json) => _$OrdersFromJson(json);

  Map<String, dynamic> toJson() => _$OrdersToJson(this);

  @override
  List<Object> get props => [count, nextPage, previousPage, results];
}
