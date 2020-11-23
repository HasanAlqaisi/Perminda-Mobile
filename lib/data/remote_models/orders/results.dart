import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'results.g.dart';

@JsonSerializable(explicitToJson: true)
class OrdersResult extends Equatable {
  @JsonKey(name: 'pk')
  final String id;
  @JsonKey(name: 'user')
  final String userId;
  final String address;
  final List<String> products;
  @JsonKey(name: 'products_cost')
  final int productsCost;
  @JsonKey(name: 'shipping_fee')
  final int shippingFee;
  final int stage;
  @JsonKey(name: 'date_sent')
  final String dateSent;
  @JsonKey(name: 'date_prepared')
  final String datePrepared;
  @JsonKey(name: 'date_shipped')
  final String dateShipped;
  @JsonKey(name: 'date_received')
  final String dateReceived;

  OrdersResult(
    this.id,
    this.userId,
    this.address,
    this.products,
    this.productsCost,
    this.shippingFee,
    this.stage,
    this.dateSent,
    this.datePrepared,
    this.dateShipped,
    this.dateReceived,
  );

  factory OrdersResult.fromJson(Map<String, dynamic> json) =>
      _$OrdersResultFromJson(json);

  Map<String, dynamic> toJson() => _$OrdersResultToJson(this);

  @override
  List<Object> get props {
    return [
      id,
      userId,
      address,
      products,
      productsCost,
      shippingFee,
      stage,
      dateSent,
      datePrepared,
      dateShipped,
      dateReceived,
    ];
  }
}
