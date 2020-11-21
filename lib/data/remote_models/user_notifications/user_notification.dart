import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_notification.g.dart';

@JsonSerializable()
class UserNotification extends Equatable {
  final String id;
  @JsonKey(nullable: true)
  final String message;
  @JsonKey(name: 'read')
  final bool hasRead;
  @JsonKey(name: 'date_sent')
  final String dateSent;
  @JsonKey(name: 'user')
  final String userId;

  UserNotification(
      this.id, this.message, this.hasRead, this.dateSent, this.userId);

  factory UserNotification.fromJson(Map<String, dynamic> json) =>
      _$UserNotificationFromJson(json);

  Map<String, dynamic> toJson() => _$UserNotificationToJson(this);

  @override
  List<Object> get props => [id, message, hasRead, dateSent, userId];
}
