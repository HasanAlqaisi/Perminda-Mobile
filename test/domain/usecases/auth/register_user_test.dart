import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:perminda/data/remote_models/auth/user.dart';
import 'package:perminda/domain/repos/auth_repo.dart';
import 'package:perminda/domain/usecases/auth/register_user.dart';

import '../../../fixtures/fixture_reader.dart';

class MockAuthRepo extends Mock implements AuthRepo {}

void main() {
  MockAuthRepo authRepo;
  RegisterUserUseCase registerUserUseCase;
  User user;

  setUp(() {
    authRepo = MockAuthRepo();
    registerUserUseCase = RegisterUserUseCase(authRepo: authRepo);
    user = User.fromJson(json.decode(fixture('user.json')));
  });

  test('should call [registerUser] from the [AuthRepo]', () {
    registerUserUseCase(
        user.firstName, user.lastName, user.username, user.email, '', '3489');

    verify(authRepo.registerUser(
        user.firstName, user.lastName, user.username, user.email, '', '3489'));
  });
}
