part of 'forgot_password_bloc.dart';

abstract class ForgotPasswordEvent extends Equatable {
  const ForgotPasswordEvent();

  @override
  List<Object> get props => [];
}

class ConfirmClicked extends ForgotPasswordEvent {
  final String email;

  ConfirmClicked({this.email});
}
