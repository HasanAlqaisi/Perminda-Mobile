import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {}

class FieldsFailure implements Failure {
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
  String toString() {
    return """
    first name: $firstName
    last name: $lastName
    username: $userName
    email: $email
    password: $password
    """;
  }

  @override
  List<Object> get props => [firstName, lastName, userName, email, password];

  @override
  bool get stringify => false;
}

class UnknownFailure implements Failure {
  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}
