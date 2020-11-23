import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'results.g.dart';

@JsonSerializable(explicitToJson: true)
class FavouritesResult extends Equatable {
  @JsonKey(name: 'pk')
  final String id;
  @JsonKey(name: 'user')
  final String userId;
  @JsonKey(name: 'product')
  final String productId;

  FavouritesResult(this.id, this.userId, this.productId);

  factory FavouritesResult.fromJson(Map<String, dynamic> json) =>
      _$FavouritesResultFromJson(json);

  Map<String, dynamic> toJson() => _$FavouritesResultToJson(this);

  @override
  List<Object> get props => [id, userId, productId];
}
