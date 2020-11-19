import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'brand.g.dart';

@JsonSerializable()
class Brand extends Equatable {
  @JsonKey(name: 'pk')
  final String id;
  final String name;
  @JsonKey(name: 'logo', nullable: true)
  final String imageUrl;

  Brand(this.id, this.name, this.imageUrl);

  factory Brand.fromJson(Map<String, dynamic> json) => _$BrandFromJson(json);

  Map<String, dynamic> toJson() => _$BrandToJson(this);

  @override
  List<Object> get props => [id, name, imageUrl];
}
