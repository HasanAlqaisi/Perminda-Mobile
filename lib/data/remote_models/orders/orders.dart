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
  @JsonKey(name: 'products_cost')
  final double productsCost;
  @JsonKey(name: 'shipping_fee')
  final double shippingFee;
  final int stage;
  @JsonKey(name: 'date_sent', nullable: true)
  final String dateSent;
  @JsonKey(name: 'date_prepared', nullable: true)
  final String datePrepared;
  @JsonKey(name: 'date_shipped', nullable: true)
  final String dateShipped;
  @JsonKey(name: 'date_received', nullable: true)
  final String dateReceived;

  Orders(
    this.count,
    this.nextPage,
    this.previousPage,
    this.results,
    this.productsCost,
    this.shippingFee,
    this.stage,
    this.dateSent,
    this.datePrepared,
    this.dateShipped,
    this.dateReceived,
  );

  factory Orders.fromJson(Map<String, dynamic> json) => _$OrdersFromJson(json);

  Map<String, dynamic> toJson() => _$OrdersToJson(this);

  @override
  List<Object> get props => [
        count,
        nextPage,
        previousPage,
        results,
        productsCost,
        shippingFee,
        stage,
        dateSent,
        datePrepared,
        dateShipped,
        dateReceived,
      ];
}
