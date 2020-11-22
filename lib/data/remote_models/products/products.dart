import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:perminda/data/remote_models/products/results.dart';

part 'products.g.dart';

@JsonSerializable()
class Products extends Equatable {
  @JsonKey(name: 'count')
  final int resultPerPage;
  @JsonKey(nullable: true, name: 'next')
  final String nextPage;
  @JsonKey(nullable: true, name: 'previous')
  final String previousPage;
  final List<ProductsResult> results;

  Products(
      {this.resultPerPage, this.nextPage, this.previousPage, this.results});

  factory Products.fromJson(Map<String, dynamic> json) =>
      _$ProductsFromJson(json);

  Map<String, dynamic> toJson() => _$ProductsToJson(this);

  @override
  List<Object> get props => [resultPerPage, nextPage, previousPage, results];

  @override
  bool get stringify => true;
}
