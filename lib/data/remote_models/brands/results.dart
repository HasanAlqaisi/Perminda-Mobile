import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'results.g.dart';

@JsonSerializable(explicitToJson: true)
class BrandsResult extends Equatable {
  @JsonKey(name: 'pk')
  final String id;
  final String name;
  @JsonKey(name: 'logo', nullable: true)
  final String imageUrl;

  BrandsResult(this.id, this.name, this.imageUrl);

  factory BrandsResult.fromJson(Map<String, dynamic> json) =>
      _$BrandsResultFromJson(json);

  Map<String, dynamic> toJson() => _$BrandsResultToJson(this);

  @override
  List<Object> get props => [id, name, imageUrl];
}
