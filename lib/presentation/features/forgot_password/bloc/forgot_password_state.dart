part of 'forgot_password_bloc.dart';

abstract class ForgotPasswordState extends Equatable {
  const ForgotPasswordState();

  @override
  List<Object> get props => [];
}

class ForgotPasswordInitial extends ForgotPasswordState {}

class Loading extends ForgotPasswordState {}

class Success extends ForgotPasswordState {}

class Error extends ForgotPasswordState {
  final Failure failure;

  Error({this.failure});
}
