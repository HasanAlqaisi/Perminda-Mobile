import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:perminda/data/remote_models/favourites/results.dart';

part 'favourites.g.dart';

@JsonSerializable()
class Favourites extends Equatable {
  final int count;
  @JsonKey(name: 'next', nullable: true)
  final String nextPage;
  @JsonKey(name: 'previous', nullable: true)
  final String previousPage;
  final List<FavouritesResult> results;

  Favourites(this.count, this.nextPage, this.previousPage, this.results);

  factory Favourites.fromJson(Map<String, dynamic> json) =>
      _$FavouritesFromJson(json);

  Map<String, dynamic> toJson() => _$FavouritesToJson(this);

  @override
  List<Object> get props => [count, nextPage, previousPage, results];
}
