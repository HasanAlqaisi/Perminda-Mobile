import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'results.g.dart';

@JsonSerializable(explicitToJson: true)
class ReviewsResult extends Equatable {
  final String id;
  final int rate;
  @JsonKey(nullable: true)
  final String message;
  @JsonKey(name: 'date_wrote')
  final String dateWrote;
  @JsonKey(name: 'last_update')
  final String lastUpdate;
  @JsonKey(name: 'user')
  final String userId;
  @JsonKey(name: 'product')
  final String productId;

  ReviewsResult(this.id, this.rate, this.message, this.dateWrote,
      this.lastUpdate, this.userId, this.productId);

  factory ReviewsResult.fromJson(Map<String, dynamic> json) =>
      _$ReviewsResultFromJson(json);

  Map<String, dynamic> toJson() => _$ReviewsResultToJson(this);

  @override
  List<Object> get props =>
      [id, rate, message, dateWrote, lastUpdate, userId, productId];
}
