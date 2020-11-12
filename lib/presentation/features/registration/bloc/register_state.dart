part of 'register_bloc.dart';

abstract class RegisterState extends Equatable {
  const RegisterState();

  @override
  List<Object> get props => [];
}

class RegisterInitial extends RegisterState {}

class RegisterInProgress extends RegisterState {}

class RegisterSuccess extends RegisterState {
  final User user;

  RegisterSuccess({this.user});
}

class RegisterError extends RegisterState {
  final Failure failure;

  RegisterError(this.failure);
}
