import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'category.g.dart';

@JsonSerializable()
class Category extends Equatable {
  @JsonKey(name: 'pk')
  final String id;
  @JsonKey(name: 'parent', nullable: true)
  final String parentId;
  final String name;

  Category({this.id, this.parentId, this.name});

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryToJson(this);

  @override
  List<Object> get props => [id, parentId, name];
}
