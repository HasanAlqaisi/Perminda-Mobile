import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'results.g.dart';

@JsonSerializable(explicitToJson: true)
class UserNotificationsReusult extends Equatable {
  final String id;
  @JsonKey(nullable: true)
  final String message;
  @JsonKey(name: 'read')
  final bool hasRead;
  @JsonKey(name: 'date_sent')
  final String dateSent;
  @JsonKey(name: 'user')
  final String userId;

  UserNotificationsReusult(
      this.id, this.message, this.hasRead, this.dateSent, this.userId);

  factory UserNotificationsReusult.fromJson(Map<String, dynamic> json) =>
      _$UserNotificationsReusultFromJson(json);

  Map<String, dynamic> toJson() => _$UserNotificationsReusultToJson(this);

  @override
  List<Object> get props => [id, message, hasRead, dateSent, userId];
}
