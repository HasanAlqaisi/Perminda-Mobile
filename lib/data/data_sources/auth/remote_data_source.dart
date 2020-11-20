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
    String phone,
    String password,
  );

  Future<String> loginUser(String username, String password);

  Future<String> forgotPassword(String email);

  Future<User> getUser();

  Future<User> editUser(
    String firstName,
    String lastName,
    String username,
    String email,
    String phone,
    String password,
    String image,
    String address,
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
    String phone,
    String password,
  ) async {
    final response = await client.post(
      '$baseUrl/api/accounts/registration/',
      body: {
        'first_name': '$firstName',
        'last_name': '$lastName',
        'username': '$username',
        'email': '$email',
        'phone_number': '$phone',
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

  @override
  Future<String> loginUser(String username, String password) async {
    final response = await client.post(
      '$baseUrl/api/accounts/login/',
      body: {
        'username': username,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body)['key'];
    } else if (response.statusCode == 400) {
      throw NonFieldsException(message: response.body);
    } else {
      throw UnknownException(message: response.body);
    }
  }

  @override
  Future<String> forgotPassword(String email) async {
    final response = await client
        .post('$baseUrl/api/accounts/password/reset/', body: {'email': email});

    if (response.statusCode == 200) {
      return json.decode(response.body)['detail'];
    } else {
      print('ERROR ${response.statusCode} =>>' + response.body);
      throw UnknownException(message: response.body);
    }
  }

  @override
  Future<User> editUser(
      String firstName,
      String lastName,
      String username,
      String email,
      String phone,
      String password,
      String image,
      String address) async {
    final response = await client.put(
      '$baseUrl/api/accounts/user/',
      headers: {'Authorization': '$token'},
      body: {
        'first_name': firstName,
        'last_name': lastName,
        'username': username,
        'email': email,
        'phone_number': phone,
        'password': password,
        'address': address,
        'image': image,
      },
    );

    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else if (response.statusCode == 400) {
      throw FieldsException(body: response.body);
    } else if (response.statusCode == 401) {
      throw UnauthorizedTokenException();
    } else {
      throw UnknownException();
    }
  }

  @override
  Future<User> getUser() async {
    final response = await client.get(
      '$baseUrl/api/accounts/user/',
      headers: {'Authorization': '$token'},
    );

    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else if (response.statusCode == 401) {
      throw UnauthorizedTokenException();
    } else {
      throw UnknownException();
    }
  }
}
