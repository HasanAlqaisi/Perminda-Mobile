import 'dart:convert';

import 'package:perminda/core/constants/sensetive_constants.dart';
import 'package:perminda/core/errors/exception.dart';
import 'package:http/http.dart' as http;
import 'package:perminda/data/remote_models/brands/brands.dart';
import 'package:perminda/data/remote_models/brands/results.dart';

abstract class BrandsRemoteSource {
  Future<Brands> getBrands(int offset);
  Future<BrandsResult> getBrandById(String id);
}

class BrandsRemoteSourceImpl extends BrandsRemoteSource {
  final http.Client client;

  BrandsRemoteSourceImpl({this.client});

  @override
  Future<BrandsResult> getBrandById(String id) async {
    final response = await client.get('$baseUrl/api/brand/$id/');

    if (response.statusCode == 200) {
      return BrandsResult.fromJson(json.decode(response.body));
    } else if (response.statusCode == 404) {
      throw ItemNotFoundException();
    } else {
      throw UnknownException();
    }
  }

  @override
  Future<Brands> getBrands(int offset) async {
    final response =
        await client.get('$baseUrl/api/brand?limit=10&offset=$offset');

    if (response.statusCode == 200) {
      return Brands.fromJson(json.decode(response.body));
    } else {
      throw UnknownException();
    }
  }
}
