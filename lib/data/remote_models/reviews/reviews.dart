import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:perminda/data/remote_models/categories/results.dart';
import 'package:perminda/data/remote_models/reviews/results.dart';

part 'reviews.g.dart';

@JsonSerializable()
class Reviews extends Equatable {
  final int count;
  @JsonKey(name: 'next', nullable: true)
  final String nextPage;
  @JsonKey(name: 'previous', nullable: true)
  final String previousPage;
  final List<ReviewsResult> results;

  Reviews(this.count, this.nextPage, this.previousPage, this.results);

  factory Reviews.fromJson(Map<String, dynamic> json) =>
      _$ReviewsFromJson(json);

  Map<String, dynamic> toJson() => _$ReviewsToJson(this);

  @override
  List<Object> get props => [count, nextPage, previousPage, results];
}
