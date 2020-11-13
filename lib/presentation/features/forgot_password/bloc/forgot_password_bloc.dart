import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:perminda/core/errors/failure.dart';
import 'package:perminda/domain/usecases/auth/forgot_password.dart';

part 'forgot_password_event.dart';
part 'forgot_password_state.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  ForgotPassUseCase forgotPassUseCase;

  ForgotPasswordBloc({this.forgotPassUseCase}) : super(ForgotPasswordInitial());

  @override
  Stream<ForgotPasswordState> mapEventToState(
    ForgotPasswordEvent event,
  ) async* {
    if (event is ConfirmClicked) {
      yield Loading();

      final result = await forgotPassUseCase(event.email);

      yield result.fold(
          (failure) => Error(failure: failure), (success) => Success());
    }
  }
}
