import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'shop.g.dart';

@JsonSerializable()
class Shop extends Equatable {
  @JsonKey(name: 'pk')
  final String id;
  @JsonKey(name: 'user')
  final String userId;
  final String name;
  @JsonKey(name: 'date_created')
  final String dateCreated;

  Shop({this.id, this.userId, this.name, this.dateCreated});

  factory Shop.fromJson(Map<String, dynamic> json) => _$ShopFromJson(json);

  Map<String, dynamic> toJson() => _$ShopToJson(this);

  @override
  List<Object> get props => [id, userId, name, dateCreated];
}
