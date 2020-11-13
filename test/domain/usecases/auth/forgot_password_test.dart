import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:perminda/domain/repos/auth_repo.dart';
import 'package:perminda/domain/usecases/auth/forgot_password.dart';

class MockAuthRepo extends Mock implements AuthRepo {}

void main() {
  MockAuthRepo authRepo;
  ForgotPassUseCase forgotPassUseCase;

  setUp(() {
    authRepo = MockAuthRepo();
    forgotPassUseCase = ForgotPassUseCase(authRepo: authRepo);
  });

  group('forgotPassword', () {
    test('should call [forgotPassword] from [AuthRepo]', () async {
      await forgotPassUseCase('');

      verify(authRepo.forgotPassword(''));
    });
  });
}
