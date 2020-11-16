part of 'register_bloc.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

class RegisterClicked extends RegisterEvent {
  final String firstName;
  final String lastName;
  final String username;
  final String email;
  final String phone;
  final String password;

  RegisterClicked({
    this.firstName,
    this.lastName,
    this.username,
    this.email,
    this.phone,
    this.password,
  });
}
