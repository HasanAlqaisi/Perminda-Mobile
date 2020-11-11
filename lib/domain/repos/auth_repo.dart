import 'package:dartz/dartz.dart';
import 'package:perminda/core/errors/failure.dart';
import 'package:perminda/data/remote_models/auth/user.dart';

abstract class AuthRepo {
  Future<Either<Failure, User>> registerUser(
    String firstName,
    String lastName,
    String username,
    String email,
    String password,
  );
}
