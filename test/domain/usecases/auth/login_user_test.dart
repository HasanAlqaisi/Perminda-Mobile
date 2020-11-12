import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:perminda/domain/repos/auth_repo.dart';
import 'package:perminda/domain/usecases/auth/login_user.dart';

class MockAuthRepo extends Mock implements AuthRepo {}

void main() {
  MockAuthRepo authRepo;
  LoginUserUseCase loginUserUseCase;

  setUp(() {
    authRepo = MockAuthRepo();
    loginUserUseCase = LoginUserUseCase(authRepo: authRepo);
  });

  test('should call [loginUser] from [AuthRepo]', () {
    loginUserUseCase('', '');

    verify(authRepo.loginUser('', ''));
  });
}
