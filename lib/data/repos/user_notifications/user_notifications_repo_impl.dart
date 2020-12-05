import 'package:perminda/core/api_helpers/api.dart';
import 'package:perminda/core/constants/sensetive_constants.dart';
import 'package:perminda/core/errors/exception.dart';
import 'package:perminda/core/network/network_info.dart';
import 'package:perminda/data/data_sources/user_notifications/notifications_local_source.dart';
import 'package:perminda/data/data_sources/user_notifications/notifications_remote_source.dart';
import 'package:perminda/data/db/models/user_notification/notification_table.dart';
import 'package:perminda/data/remote_models/user_notifications/results.dart';
import 'package:perminda/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:perminda/data/remote_models/user_notifications/user_notifications.dart';
import 'package:perminda/domain/repos/user_notifications_repo.dart';

class UserNotificationsRepoImpl extends UserNotificationsRepo {
  final NetWorkInfo netWorkInfo;
  final NotificationsRemoteSource remoteSource;
  final NotificationsLocalSource localSource;
  int offset = 0;

  UserNotificationsRepoImpl(
      {this.netWorkInfo, this.remoteSource, this.localSource});

  @override
  Future<Either<Failure, bool>> deleteNotification(String id) async {
    if (await netWorkInfo.isConnected()) {
      try {
        final result = await remoteSource.deleteNotification(id);

        await localSource.deleteUserNotificationById(id);

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
  Future<Either<Failure, UserNotificationsReusult>> editNotification(
      String id) async {
    if (await netWorkInfo.isConnected()) {
      try {
        final result = await remoteSource.editNotification(id);

        await localSource.insertUserNotifications(
            UserNotificationTable.fromNotificationsResult([result]));

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
  Future<Either<Failure, UserNotifications>> getNotifications() async {
    if (await netWorkInfo.isConnected()) {
      try {
        final result = await remoteSource.getNotificatons(this.offset);

        if (this.offset == 0) localSource.deleteNotifications(kUserId);

        await localSource.insertUserNotifications(
            UserNotificationTable.fromNotificationsResult(result.results));

        final offset = API.offsetExtractor(result.nextPage);

        cacheOffset(offset);

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

  void cacheOffset(int offset) {
    this.offset = offset;
  }
}
