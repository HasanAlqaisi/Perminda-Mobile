import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:perminda/core/errors/failure.dart';
import 'package:perminda/domain/usecases/auth/login_user.dart';
import 'package:perminda/presentation/features/login/bloc/login_bloc.dart';

class MockLoginUseCase extends Mock implements LoginUserUseCase {}

void main() {
  MockLoginUseCase loginUserUseCase;
  LoginBloc loginBloc;

  setUp(() {
    loginUserUseCase = MockLoginUseCase();
    loginBloc = LoginBloc(loginUserUseCase: loginUserUseCase);
  });

  tearDown(() {
    loginBloc.close();
  });

  group('loginUseCase', () {
    test('should emit [LoginInProgress, LoginSuccess] if call is success]', () {
      when(loginUserUseCase('', '')).thenAnswer((_) async => Right('token'));

      final expectedStates = [LoginInProgress(), LoginSuccess()];

      expectLater(loginBloc.asBroadcastStream(), emitsInOrder(expectedStates));

      loginBloc.add(LoginClicked('', ''));
    });

    test('should emit [LoginInProgress, LoginError] if call is failed]', () {
      when(loginUserUseCase('', ''))
          .thenAnswer((_) async => Left(NonFieldsFailure()));

      final expectedStates = [
        LoginInProgress(),
        LoginError(failure: NonFieldsFailure())
      ];

      expectLater(loginBloc.asBroadcastStream(), emitsInOrder(expectedStates));

      loginBloc.add(LoginClicked('', ''));
    });
  });
}
