import 'package:dartz/dartz.dart';
import 'package:perminda/core/errors/failure.dart';
import 'package:perminda/domain/repos/auth_repo.dart';

class LoginUserUseCase {
  final AuthRepo authRepo;

  LoginUserUseCase({this.authRepo});

  Future<Either<Failure, String>> call(String username, String password) async {
    return await authRepo.loginUser(username, password);
  }
}
