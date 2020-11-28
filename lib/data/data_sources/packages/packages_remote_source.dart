import 'dart:convert';
import 'package:perminda/core/constants/sensetive_constants.dart';
import 'package:perminda/core/errors/exception.dart';
import 'package:perminda/data/remote_models/packages/packages.dart';
import 'package:http/http.dart' as http;

abstract class PackagesRemoteSource {
  Future<Packages> getPackages(int offset);
}

class PackagesRemoteSourceImpl extends PackagesRemoteSource {
  final http.Client client;

  PackagesRemoteSourceImpl({this.client});

  @override
  Future<Packages> getPackages(int offset) async {
    final response = await client.get(
      '$baseUrl/api/package?limit=10&offset=$offset',
    );

    if (response.statusCode == 200) {
      return Packages.fromJson(json.decode(response.body));
    } else {
      throw UnknownException(message: response.body);
    }
  }
}
