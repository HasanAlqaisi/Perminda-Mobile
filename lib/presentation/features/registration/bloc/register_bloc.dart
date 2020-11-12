import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:perminda/core/errors/failure.dart';
import 'package:perminda/data/remote_models/auth/user.dart';

import 'package:perminda/domain/usecases/auth/register_user.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterUserUseCase registerUseCase;

  RegisterBloc({this.registerUseCase}) : super(RegisterInitial());

  @override
  Stream<RegisterState> mapEventToState(
    RegisterEvent event,
  ) async* {
    if (event is RegisterClicked) {
      yield* _registerClickedEvent(event);
    }
  }

  Stream<RegisterState> _registerClickedEvent(RegisterClicked event) async* {
    yield RegisterInProgress();

    final result = await registerUseCase(
      event.firstName,
      event.lastName,
      event.username,
      event.email,
      event.password,
    );
    yield result.fold((failure) => RegisterError(failure),
        (user) => RegisterSuccess(user: user));
  }
}
