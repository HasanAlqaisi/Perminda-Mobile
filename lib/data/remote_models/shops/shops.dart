import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:perminda/data/remote_models/categories/results.dart';
import 'package:perminda/data/remote_models/reviews/results.dart';
import 'package:perminda/data/remote_models/shops/results.dart';

part 'shops.g.dart';

@JsonSerializable()
class Shops extends Equatable {
  final int count;
  @JsonKey(name: 'next', nullable: true)
  final String nextPage;
  @JsonKey(name: 'previous', nullable: true)
  final String previousPage;
  final List<ShopsResult> results;

  Shops(this.count, this.nextPage, this.previousPage, this.results);

  factory Shops.fromJson(Map<String, dynamic> json) => _$ShopsFromJson(json);

  Map<String, dynamic> toJson() => _$ShopsToJson(this);

  @override
  List<Object> get props => [count, nextPage, previousPage, results];
}
