import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:perminda/data/remote_models/brands/results.dart';

part 'brands.g.dart';

@JsonSerializable()
class Brands extends Equatable {
  final int count;
  @JsonKey(name: 'next', nullable: true)
  final String nextPage;
  @JsonKey(name: 'previous', nullable: true)
  final String previousPage;
  final List<BrandsResult> results;

  Brands(this.count, this.nextPage, this.previousPage, this.results);

  factory Brands.fromJson(Map<String, dynamic> json) => _$BrandsFromJson(json);

  Map<String, dynamic> toJson() => _$BrandsToJson(this);

  @override
  List<Object> get props => [count, nextPage, previousPage, results];
}
