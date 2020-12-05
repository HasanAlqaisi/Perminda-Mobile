import 'package:dartz/dartz.dart';
import 'package:perminda/core/errors/failure.dart';
import 'package:perminda/domain/repos/auth_repo.dart';

class GetTokenUseCase {
  final AuthRepo authRepo;

  GetTokenUseCase({this.authRepo});

  String call() {
    return authRepo.getUserToken();
  }
}
