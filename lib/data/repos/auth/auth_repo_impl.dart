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
      String username, String email, String password) async {
    netWorkInfo.isConnected();
    try {
      final result = await remoteDataSource.registerUser(
          firstName, lastName, username, email, password);
      return Right(result);
    } on FieldsException catch (error) {
      return Left(FieldsFailure.fromFieldsException(json.decode(error.body)));
    } on UnknownException {
      return Left(UnknownFailure());
    }
  }
}
