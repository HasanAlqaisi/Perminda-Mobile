import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:perminda/core/errors/failure.dart';
import 'package:perminda/data/remote_models/auth/user.dart';
import 'package:perminda/domain/usecases/auth/register_user.dart';
import 'package:perminda/presentation/features/registration/bloc/register_bloc.dart';

import '../../fixtures/fixture_reader.dart';

class MockRegistrationUseCase extends Mock implements RegisterUserUseCase {}

void main() {
  MockRegistrationUseCase registrationUseCase;
  RegisterBloc registerBloc;

  setUp(() {
    registrationUseCase = MockRegistrationUseCase();
    registerBloc = RegisterBloc(registerUseCase: registrationUseCase);
  });

  tearDown(() {
    registerBloc.close();
  });

  group('registerUseCase', () {
    final user = User.fromJson(json.decode(fixture('user.json')));
    test(
        'should emit [RegisterInProgress, RegisterSuccess] when call is success',
        () {
      when(registrationUseCase(user.firstName, user.lastName, user.username,
              user.email, '', null))
          .thenAnswer((_) async => Right(user));

      final expectedStates = [
        RegisterInProgress(),
        RegisterSuccess(user: user)
      ];

      expectLater(
          registerBloc.asBroadcastStream(), emitsInOrder(expectedStates));

      registerBloc.add(RegisterClicked(
          firstName: user.firstName,
          lastName: user.lastName,
          username: user.username,
          email: user.email,
          phone: '',
          password: null));
    });

    test('should emit [RegisterInProgress, registerError] when call failed',
        () {
      when(registrationUseCase(user.firstName, user.lastName, user.username,
              user.email, '', null))
          .thenAnswer((_) async => Left(FieldsFailure()));

      final expectedStates = [
        RegisterInProgress(),
        RegisterError(FieldsFailure())
      ];

      expectLater(
          registerBloc.asBroadcastStream(), emitsInOrder(expectedStates));

      registerBloc.add(RegisterClicked(
          firstName: user.firstName,
          lastName: user.lastName,
          username: user.username,
          email: user.email,
          phone: '',
          password: null));
    });
  });
}
