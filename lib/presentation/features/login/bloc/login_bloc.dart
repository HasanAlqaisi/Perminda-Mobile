import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:perminda/core/errors/failure.dart';
import 'package:perminda/domain/usecases/auth/login_user.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginUserUseCase loginUserUseCase;

  LoginBloc({this.loginUserUseCase}) : super(LoginInitialState());

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is LoginClicked) {
      yield LoginInProgress();

      final result = await loginUserUseCase(event.username, event.password);

      yield result.fold(
          (failure) => LoginError(failure: failure), (token) => LoginSuccess());
    }
  }
}
