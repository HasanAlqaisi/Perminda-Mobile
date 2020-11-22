import 'package:dartz/dartz.dart';
import 'package:perminda/core/errors/failure.dart';
import 'package:perminda/data/remote_models/user_notifications/results.dart';
import 'package:perminda/data/remote_models/user_notifications/user_notifications.dart';

abstract class UserNotificationsRepo {
  Future<Either<Failure, UserNotifications>> getNotifications();

  Future<Either<Failure, UserNotificationsReusult>> editNotification(String id);

  Future<Either<Failure, bool>> deleteNotification(String id);
}
