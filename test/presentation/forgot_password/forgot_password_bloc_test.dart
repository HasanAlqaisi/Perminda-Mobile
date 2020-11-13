import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:perminda/core/errors/failure.dart';
import 'package:perminda/domain/usecases/auth/forgot_password.dart';
import 'package:perminda/presentation/features/forgot_password/bloc/forgot_password_bloc.dart';

class MockForgotPassUseCase extends Mock implements ForgotPassUseCase {}

void main() {
  MockForgotPassUseCase forgotPassUseCase;
  ForgotPasswordBloc forgotPassBloc;

  setUp(() {
    forgotPassUseCase = MockForgotPassUseCase();
    forgotPassBloc = ForgotPasswordBloc(forgotPassUseCase: forgotPassUseCase);
  });

  tearDown(() {
    forgotPassBloc.close();
  });

  group('ConfirmClicked', () {
    test('should emit [Loading, Success] when call is success', () {
      when(forgotPassUseCase('')).thenAnswer((_) async => Right(''));

      final expectedStates = [Loading(), Success()];

      expectLater(
          forgotPassBloc.asBroadcastStream(), emitsInOrder(expectedStates));

      forgotPassBloc.add(ConfirmClicked(email: ''));
    });

    test('should emit [Loading, Error] when call failed',
        () {
      when(forgotPassUseCase('')).thenAnswer((_) async => Left(UnknownFailure()));

      final expectedStates = [Loading(), Error()];

      expectLater(
          forgotPassBloc.asBroadcastStream(), emitsInOrder(expectedStates));

      forgotPassBloc.add(ConfirmClicked(email: ''));
    });
  });
}
