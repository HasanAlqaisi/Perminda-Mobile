import 'dart:convert';

import 'package:perminda/core/constants/sensetive_constants.dart';
import 'package:perminda/core/errors/exception.dart';
import 'package:perminda/data/remote_models/categories/category.dart';
import 'package:http/http.dart' as http;

abstract class CategoriesRemoteSource {
  Future<List<Category>> getCategories();
  Future<Category> getCategoryById(String id);
}

class CategoriesRemoteSourceImpl extends CategoriesRemoteSource {
  final http.Client client;

  CategoriesRemoteSourceImpl({this.client});

  @override
  Future<List<Category>> getCategories() async {
    final response = await client.get('$baseUrl/api/category/');

    if (response.statusCode == 200) {
      return (json.decode(response.body) as List)
          .map((category) => Category.fromJson(category))
          .toList();
    } else {
      throw UnknownException();
    }
  }

  @override
  Future<Category> getCategoryById(String id) async {
    final response = await client.get('$baseUrl/api/category/$id/');

    if (response.statusCode == 200) {
      return Category.fromJson(json.decode(response.body));
    } else if (response.statusCode == 404) {
      throw ItemNotFoundException(
        message: json.decode(response.body)['detail'],
      );
    } else {
      throw UnknownException();
    }
  }
}
