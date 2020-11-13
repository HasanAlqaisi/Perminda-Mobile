import 'package:dartz/dartz.dart';
import 'package:perminda/core/errors/failure.dart';
import 'package:perminda/domain/repos/auth_repo.dart';

class ForgotPassUseCase {
  final AuthRepo authRepo;

  ForgotPassUseCase({this.authRepo});

  Future<Either<Failure, String>> call(String email) async {
    return await authRepo.forgotPassword(email);
  }
}
