part of 'login_bloc.dart';

@immutable
abstract class LoginEvent {}

class LoginClicked extends LoginEvent {
  final String username;
  final String password;

  LoginClicked(this.username, this.password);
}
