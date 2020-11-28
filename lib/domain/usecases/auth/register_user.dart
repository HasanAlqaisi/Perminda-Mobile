import 'package:dartz/dartz.dart';
import 'package:perminda/core/errors/failure.dart';
import 'package:perminda/data/remote_models/auth/user.dart';
import 'package:perminda/domain/repos/auth_repo.dart';

class RegisterUserUseCase {
  final AuthRepo authRepo;

  RegisterUserUseCase({this.authRepo});

  Future<Either<Failure, bool>> call(
    String firstName,
    String lastName,
    String username,
    String email,
    String phone,
    String password,
  ) async {
    return await authRepo.registerUser(
        firstName, lastName, username, email, phone, password);
  }
}
