import 'package:equatable/equatable.dart';

abstract class Failure {}

class FieldsFailure extends Equatable implements Failure {
  final List<String> firstName;
  final List<String> lastName;
  final List<String> userName;
  final List<String> email;
  final List<String> password;

  FieldsFailure({
    this.firstName,
    this.lastName,
    this.userName,
    this.email,
    this.password,
  });

  factory FieldsFailure.fromFieldsException(Map<String, dynamic> body) {
    return FieldsFailure(
      email: body['email']?.cast<String>() as List<String>,
      firstName: body['first_name']?.cast<String>() as List<String> ?? null,
      lastName: body['last_name']?.cast<String>() as List<String> ?? null,
      password: body['password']?.cast<String>() as List<String> ?? null,
      userName: body['username']?.cast<String>() as List<String> ?? null,
    );
  }

  @override
  List<Object> get props => [firstName, lastName, userName, email, password];

  @override
  bool get stringify => true;
}

class UnknownFailure extends Equatable implements Failure {
  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

class NoInternetFailure extends Equatable implements Failure {
  @override
  List<Object> get props => [];
}
