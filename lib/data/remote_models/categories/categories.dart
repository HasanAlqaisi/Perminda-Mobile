import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:perminda/data/remote_models/categories/results.dart';

part 'categories.g.dart';

@JsonSerializable()
class Categories extends Equatable {
  final int count;
  @JsonKey(name: 'next', nullable: true)
  final String nextPage;
  @JsonKey(name: 'previous', nullable: true)
  final String previousPage;
  final List<CategoriesResult> results;

  Categories(this.count, this.nextPage, this.previousPage, this.results);

  factory Categories.fromJson(Map<String, dynamic> json) =>
      _$CategoriesFromJson(json);

  Map<String, dynamic> toJson() => _$CategoriesToJson(this);

  @override
  List<Object> get props => [count, nextPage, previousPage, results];
}
