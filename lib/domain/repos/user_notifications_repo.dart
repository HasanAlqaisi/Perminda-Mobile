import 'package:dartz/dartz.dart';
import 'package:perminda/core/errors/failure.dart';
import 'package:perminda/data/remote_models/user_notifications/user_notification.dart';

abstract class UserNotificationsRepo {
  Future<Either<Failure, List<UserNotification>>> getNotifications();

  Future<Either<Failure, UserNotification>> editNotification(String id);

  Future<Either<Failure, bool>> deleteNotification(String id);
}
