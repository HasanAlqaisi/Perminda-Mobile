import 'dart:convert';

import 'package:perminda/core/constants/sensetive_constants.dart';
import 'package:perminda/core/errors/exception.dart';
import 'package:perminda/data/remote_models/auth/user.dart';
import 'package:http/http.dart' as http;

abstract class AuthRemoteDataSource {
  Future<User> registerUser(
    String firstName,
    String lastName,
    String username,
    String email,
    String password,
  );
}

class AuthRemoteDataSourceImpl extends AuthRemoteDataSource {
  http.Client client;

  AuthRemoteDataSourceImpl({this.client});

  @override
  Future<User> registerUser(
    String firstName,
    String lastName,
    String username,
    String email,
    String password,
  ) async {
    final response = await client.post(
      '$baseUrl/accounts/registration/',
      body: {
        'first_name': '$firstName',
        'last_name': '$lastName',
        'username': '$username',
        'email': '$email',
        'password': '$password',
      },
    );
    if (response.statusCode == 201) {
      return User.fromJson(json.decode(response.body));
    } else if (response.statusCode == 400) {
      throw FieldsException(body: response.body);
    } else {
      throw UnknownException(message: response.body);
    }
  }
}
