import 'dart:convert';

import 'package:perminda/core/constants/sensetive_constants.dart';
import 'package:perminda/core/errors/exception.dart';
import 'package:perminda/data/remote_models/brands/brand.dart';
import 'package:http/http.dart' as http;

abstract class BrandsRemoteSource {
  Future<List<Brand>> getBrands();
  Future<Brand> getBrandById(String id);
}

class BrandsRemoteSourceImpl extends BrandsRemoteSource {
  final http.Client client;

  BrandsRemoteSourceImpl({this.client});

  @override
  Future<Brand> getBrandById(String id) async {
    final response = await client.get('$baseUrl/api/brand/$id/');

    if (response.statusCode == 200) {
      return Brand.fromJson(json.decode(response.body));
    } else if (response.statusCode == 404) {
      throw ItemNotFoundException();
    } else {
      throw UnknownException();
    }
  }

  @override
  Future<List<Brand>> getBrands() async {
    final response = await client.get('$baseUrl/api/brand/');

    if (response.statusCode == 200) {
      return (json.decode(response.body) as List)
          .map((brand) => Brand.fromJson(brand))
          .toList();
    } else {
      throw UnknownException();
    }
  }
}
