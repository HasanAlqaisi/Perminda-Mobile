import 'package:equatable/equatable.dart';

import 'package:perminda/data/db/app_database/app_database.dart';

class UserWithNotifications extends Equatable {
  final UserData user;
  final List<NotificationData> notifications;

  UserWithNotifications({this.user, this.notifications});

  @override
  List<Object> get props => [user, notifications];
}
