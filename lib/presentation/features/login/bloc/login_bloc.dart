import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:perminda/core/constants/sensetive_constants.dart';
import 'package:perminda/core/errors/failure.dart';
import 'package:perminda/domain/usecases/auth/get_token_use_case.dart';
import 'package:perminda/domain/usecases/auth/login_user.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginUserUseCase loginUserUseCase;
  GetTokenUseCase getTokenUseCase;

  LoginBloc({this.loginUserUseCase, this.getTokenUseCase})
      : super(LoginInitialState());

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is LoginClicked) {
      yield LoginInProgress();

      final result = await loginUserUseCase(event.username, event.password);

      yield result.fold(
          (failure) => LoginError(failure: failure), (_) => LoginSuccess());
    } else if (event is CheckAuthEvent) {
      kToken = getTokenUseCase();
      if (kToken != null) yield AuthedState();
    }
  }
}
