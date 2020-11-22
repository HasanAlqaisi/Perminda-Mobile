import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:perminda/data/remote_models/user_notifications/results.dart';

part 'user_notifications.g.dart';

@JsonSerializable()
class UserNotifications extends Equatable {
  final int count;
  @JsonKey(name: 'next', nullable: true)
  final String nextPage;
  @JsonKey(name: 'previous', nullable: true)
  final String previousPage;
  final List<UserNotificationsReusult> results;

  UserNotifications(this.count, this.nextPage, this.previousPage, this.results);

  factory UserNotifications.fromJson(Map<String, dynamic> json) =>
      _$UserNotificationsFromJson(json);

  Map<String, dynamic> toJson() => _$UserNotificationsToJson(this);

  @override
  List<Object> get props => [count, nextPage, previousPage, results];
}
