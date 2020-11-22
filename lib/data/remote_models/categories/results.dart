import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'results.g.dart';

@JsonSerializable(explicitToJson: true)
class CategoriesResult extends Equatable {
  @JsonKey(name: 'pk')
  final String id;
  @JsonKey(name: 'parent', nullable: true)
  final String parentId;
  final String name;

  CategoriesResult({this.id, this.parentId, this.name});

  factory CategoriesResult.fromJson(Map<String, dynamic> json) =>
      _$CategoriesResultFromJson(json);

  Map<String, dynamic> toJson() => _$CategoriesResultToJson(this);

  @override
  List<Object> get props => [id, parentId, name];
}
