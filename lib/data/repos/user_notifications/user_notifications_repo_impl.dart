import 'package:perminda/core/errors/exception.dart';
import 'package:perminda/core/network/network_info.dart';
import 'package:perminda/data/data_sources/user_notifications/notifications_remote_source.dart';
import 'package:perminda/data/remote_models/user_notifications/user_notification.dart';
import 'package:perminda/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:perminda/domain/repos/user_notifications_repo.dart';

class UserNotificationsRepoImpl extends UserNotificationsRepo {
  final NetWorkInfo netWorkInfo;
  final NotificationsRemoteSource remoteSource;

  UserNotificationsRepoImpl({this.netWorkInfo, this.remoteSource});

  @override
  Future<Either<Failure, bool>> deleteNotification(String id) async {
    if (await netWorkInfo.isConnected()) {
      try {
        final result = await remoteSource.deleteNotification(id);
        return Right(result);
      } on UnauthorizedTokenException {
        return Left(UnauthorizedTokenFailure());
      } on ItemNotFoundException {
        return Left(ItemNotFoundFailure());
      } on UnknownException catch (e) {
        print(e);
        return Left(UnknownFailure());
      }
    } else {
      return Left(NoInternetFailure());
    }
  }

  @override
  Future<Either<Failure, UserNotification>> editNotification(String id) async {
    if (await netWorkInfo.isConnected()) {
      try {
        final result = await remoteSource.editNotification(id);
        return Right(result);
      } on UnauthorizedTokenException {
        return Left(UnauthorizedTokenFailure());
      } on ItemNotFoundException {
        return Left(ItemNotFoundFailure());
      } on UnknownException catch (e) {
        print(e);
        return Left(UnknownFailure());
      }
    } else {
      return Left(NoInternetFailure());
    }
  }

  @override
  Future<Either<Failure, List<UserNotification>>> getNotifications() async {
    if (await netWorkInfo.isConnected()) {
      try {
        final result = await remoteSource.getNotificatons();
        return Right(result);
      } on UnauthorizedTokenException {
        return Left(UnauthorizedTokenFailure());
      } on UnknownException catch (e) {
        print(e);
        return Left(UnknownFailure());
      }
    } else {
      return Left(NoInternetFailure());
    }
  }
}
