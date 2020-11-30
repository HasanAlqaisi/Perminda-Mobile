import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'results.g.dart';

@JsonSerializable(explicitToJson: true)
class ImagesResult extends Equatable {
  @JsonKey(name: 'pk')
  final String id;
  @JsonKey(name: 'product')
  final String productId;
  @JsonKey(name: 'image')
  final String imageUrl;
  final int type;

  ImagesResult(
    this.id,
    this.productId,
    this.imageUrl,
    this.type,
  );

  factory ImagesResult.fromJson(Map<String, dynamic> json) =>
      _$ImagesResultFromJson(json);

  Map<String, dynamic> toJson() => _$ImagesResultToJson(this);

  @override
  List<Object> get props => [id, productId, imageUrl, type];
}
