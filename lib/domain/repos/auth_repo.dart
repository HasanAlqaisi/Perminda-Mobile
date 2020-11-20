import 'package:dartz/dartz.dart';
import 'package:perminda/core/errors/failure.dart';
import 'package:perminda/data/remote_models/auth/user.dart';

abstract class AuthRepo {
  Future<Either<Failure, User>> registerUser(
    String firstName,
    String lastName,
    String username,
    String email,
    String phone,
    String password,
  );

  Future<Either<Failure, String>> loginUser(String username, String password);

  Future<Either<Failure, String>> forgotPassword(String email);

  Future<Either<Failure, User>> getUser();

  Future<Either<Failure, User>> editUser(
    String firstName,
    String lastName,
    String username,
    String email,
    String phone,
    String password,
    String image,
    String address,
  );
}
