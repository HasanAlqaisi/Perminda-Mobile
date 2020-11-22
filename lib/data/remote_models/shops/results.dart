import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'results.g.dart';

@JsonSerializable(explicitToJson: true)
class ShopsResult extends Equatable {
  @JsonKey(name: 'pk')
  final String id;
  @JsonKey(name: 'user')
  final String userId;
  final String name;
  @JsonKey(name: 'date_created')
  final String dateCreated;

  ShopsResult({this.id, this.userId, this.name, this.dateCreated});

  factory ShopsResult.fromJson(Map<String, dynamic> json) =>
      _$ShopsResultFromJson(json);

  Map<String, dynamic> toJson() => _$ShopsResultToJson(this);

  @override
  List<Object> get props => [id, userId, name, dateCreated];
}
