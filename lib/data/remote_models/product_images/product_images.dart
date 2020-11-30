import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:perminda/data/remote_models/product_images/results.dart';

part 'product_images.g.dart';

@JsonSerializable()
class ProductImages extends Equatable {
  final int count;
  @JsonKey(name: 'next', nullable: true)
  final String nextPage;
  @JsonKey(name: 'previous', nullable: true)
  final String previousPage;
  final List<ImagesResult> results;

  ProductImages(this.count, this.nextPage, this.previousPage, this.results);

  factory ProductImages.fromJson(Map<String, dynamic> json) =>
      _$ProductImagesFromJson(json);

  Map<String, dynamic> toJson() => _$ProductImagesToJson(this);

  @override
  List<Object> get props => [count, nextPage, previousPage, results];
}
