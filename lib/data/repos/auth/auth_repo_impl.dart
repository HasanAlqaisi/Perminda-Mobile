import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:moor_flutter/moor_flutter.dart';
import 'package:perminda/core/errors/exception.dart';

import 'package:perminda/core/errors/failure.dart';
import 'package:perminda/core/network/network_info.dart';
import 'package:perminda/data/data_sources/auth/local_source.dart';
import 'package:perminda/data/data_sources/auth/remote_data_source.dart';
import 'package:perminda/data/db/models/user/user_table.dart';
import 'package:perminda/data/remote_models/auth/user.dart';
import 'package:perminda/domain/repos/auth_repo.dart';

class AuthRepoImpl extends AuthRepo {
  final NetWorkInfo netWorkInfo;
  final AuthRemoteDataSource remoteDataSource;
  final UserLocalSource userLocalSource;

  AuthRepoImpl({this.netWorkInfo, this.remoteDataSource, this.userLocalSource});

  @override
  Future<Either<Failure, bool>> registerUser(
    String firstName,
    String lastName,
    String username,
    String email,
    String phone,
    String password,
  ) async {
    if (await netWorkInfo.isConnected()) {
      try {
        final registration = await remoteDataSource.registerUser(
            firstName, lastName, username, email, phone, password);
        await userLocalSource.cacheUserId(registration.id);
        final result = await remoteDataSource.loginUser(username, password);
        await userLocalSource.cacheUserToken(result);
        await userLocalSource.insertUser(UserTable.fromUser(registration));
        return Right(true);
      } on FieldsException catch (error) {
        return Left(
            UserFieldsFailure.fromFieldsException(json.decode(error.body)));
      } on UnknownException {
        return Left(UnknownFailure());
      } on UnauthorizedTokenException {
        return Left(UnauthorizedTokenFailure());
      } on InvalidDataException {
        return Left(CacheFailure());
      }
    } else {
      return Left(NoInternetFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> loginUser(
      String username, String password) async {
    if (await netWorkInfo.isConnected()) {
      try {
        final result = await remoteDataSource.loginUser(username, password);
        await userLocalSource.cacheUserToken(result);
        // Get user info to save it in the database.
        final userCall = await getUser();
        return userCall.fold((failure) {
          return Left(failure);
        }, (user) async {
          await userLocalSource.cacheUserId(user?.id);
          await userLocalSource.insertUser(UserTable.fromUser(user));
          return Right(true);
        });
      } on NonFieldsException catch (error) {
        return Left(NonFieldsFailure.fromNonFieldsException(
            json.decode(error.message)));
      } on UnknownException catch (error) {
        print(error.message);
        return Left(UnknownFailure());
      } on UnauthorizedTokenException {
        return Left(UnauthorizedTokenFailure());
      } on InvalidDataException {
        return Left(CacheFailure());
      }
    } else {
      return Left(NoInternetFailure());
    }
  }

  @override
  Future<Either<Failure, String>> forgotPassword(String email) async {
    if (await netWorkInfo.isConnected()) {
      try {
        final result = await remoteDataSource.forgotPassword(email);
        return Right(result);
      } on UnknownException {
        return Left(UnknownFailure());
      }
    } else {
      return Left(NoInternetFailure());
    }
  }

  @override
  Future<Either<Failure, User>> editUser(
      String firstName,
      String lastName,
      String username,
      String email,
      String phone,
      String password,
      String image,
      String address) async {
    if (await netWorkInfo.isConnected()) {
      try {
        final result = await remoteDataSource.editUser(firstName, lastName,
            username, email, phone, password, image, address);

        await userLocalSource.insertUser(UserTable.fromUser(result));

        return Right(result);
      } on UnauthorizedTokenException {
        return Left(UnauthorizedTokenFailure());
      } on FieldsException catch (fieldsError) {
        return Left(
          UserFieldsFailure.fromFieldsException(json.decode(fieldsError.body)),
        );
      } on UnknownException {
        return Left(UnknownFailure());
      }
    } else {
      return Left(NoInternetFailure());
    }
  }

  @override
  Future<Either<Failure, User>> getUser() async {
    if (await netWorkInfo.isConnected()) {
      try {
        final result = await remoteDataSource.getUser();

        await userLocalSource.insertUser(UserTable.fromUser(result));

        return Right(result);
      } on UnauthorizedTokenException {
        return Left(UnauthorizedTokenFailure());
      } on UnknownException {
        return Left(UnknownFailure());
      }
    } else {
      return Left(NoInternetFailure());
    }
  }
}
