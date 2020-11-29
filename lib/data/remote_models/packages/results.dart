import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'results.g.dart';

@JsonSerializable(explicitToJson: true)
class PackagesResult extends Equatable {
  @JsonKey(name: 'pk')
  final String id;
  final String title;
  final String image;
  final List<String> products;
  final bool active;
  @JsonKey(name: 'date_created')
  final String dateCreated;

  PackagesResult(
    this.id,
    this.title,
    this.image,
    this.products,
    this.active,
    this.dateCreated,
  );

  factory PackagesResult.fromJson(Map<String, dynamic> json) =>
      _$PackagesResultFromJson(json);

  Map<String, dynamic> toJson() => _$PackagesResultToJson(this);

  @override
  List<Object> get props {
    return [
      id,
      title,
      image,
      products,
      active,
      dateCreated,
    ];
  }
}
