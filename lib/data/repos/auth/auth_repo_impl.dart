import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:perminda/core/errors/exception.dart';

import 'package:perminda/core/errors/failure.dart';
import 'package:perminda/core/network/network_info.dart';
import 'package:perminda/data/data_sources/auth/remote_data_source.dart';
import 'package:perminda/data/remote_models/auth/user.dart';
import 'package:perminda/domain/repos/auth_repo.dart';

class AuthRepoImpl extends AuthRepo {
  NetWorkInfo netWorkInfo;
  AuthRemoteDataSource remoteDataSource;

  AuthRepoImpl({this.netWorkInfo, this.remoteDataSource});

  @override
  Future<Either<Failure, User>> registerUser(String firstName, String lastName,
      String username, String email, String phone, String password) async {
    if (await netWorkInfo.isConnected()) {
      try {
        final result = await remoteDataSource.registerUser(
            firstName, lastName, username, email, phone, password);
        return Right(result);
      } on FieldsException catch (error) {
        return Left(FieldsFailure.fromFieldsException(json.decode(error.body)));
      } on UnknownException {
        return Left(UnknownFailure());
      }
    } else {
      return Left(NoInternetFailure());
    }
  }

  @override
  Future<Either<Failure, String>> loginUser(
      String username, String password) async {
    if (await netWorkInfo.isConnected()) {
      try {
        final result = await remoteDataSource.loginUser(username, password);
        return Right(result);
      } on NonFieldsException catch (error) {
        return Left(NonFieldsFailure.fromNonFieldsException(
            json.decode(error.message)));
      } on UnknownException catch (error) {
        print(error.message);
        return Left(UnknownFailure());
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
}
