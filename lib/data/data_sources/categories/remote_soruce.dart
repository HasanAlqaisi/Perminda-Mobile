import 'dart:convert';

import 'package:perminda/core/constants/sensetive_constants.dart';
import 'package:perminda/core/errors/exception.dart';
import 'package:perminda/data/remote_models/categories/categories.dart';
import 'package:perminda/data/remote_models/categories/results.dart';
import 'package:http/http.dart' as http;

abstract class CategoriesRemoteSource {
  Future<Categories> getCategories(int offset);
  Future<CategoriesResult> getCategoryById(String id);
}

class CategoriesRemoteSourceImpl extends CategoriesRemoteSource {
  final http.Client client;

  CategoriesRemoteSourceImpl({this.client});

  @override
  Future<Categories> getCategories(int offset) async {
    final response =
        await client.get('$baseUrl/api/category?limit=10&offset=$offset');

    if (response.statusCode == 200) {
      return Categories.fromJson(json.decode(response.body));
    } else {
      throw UnknownException();
    }
  }

  @override
  Future<CategoriesResult> getCategoryById(String id) async {
    final response = await client.get('$baseUrl/api/category/$id/');

    if (response.statusCode == 200) {
      return CategoriesResult.fromJson(json.decode(response.body));
    } else if (response.statusCode == 404) {
      throw ItemNotFoundException(
        message: json.decode(response.body)['detail'],
      );
    } else {
      throw UnknownException();
    }
  }
}
