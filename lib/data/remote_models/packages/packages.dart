import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:perminda/data/remote_models/packages/results.dart';

part 'packages.g.dart';

@JsonSerializable()
class Packages extends Equatable {
  final int count;
  @JsonKey(name: 'next', nullable: true)
  final String nextPage;
  @JsonKey(name: 'previous', nullable: true)
  final String previousPage;
  final List<PackagesResult> results;
  final bool active;
  @JsonKey(name: 'date_created')
  final String dateCreated;

  Packages(this.count, this.nextPage, this.previousPage, this.results,
      this.active, this.dateCreated);

  factory Packages.fromJson(Map<String, dynamic> json) =>
      _$PackagesFromJson(json);

  Map<String, dynamic> toJson() => _$PackagesToJson(this);

  @override
  List<Object> get props =>
      [count, nextPage, previousPage, results, active, dateCreated];
}
