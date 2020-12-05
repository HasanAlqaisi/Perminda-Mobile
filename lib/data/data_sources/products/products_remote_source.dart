import 'dart:convert';

import 'package:perminda/core/constants/sensetive_constants.dart';
import 'package:perminda/core/errors/exception.dart';
import 'package:perminda/data/remote_models/products/products.dart';
import 'package:http/http.dart' as http;

abstract class ProductsRemoteSource {
  /// Offset is the index of results array
  Future<Products> getProducts(
    int offset,
    String shopId,
    String categoryId,
    String brandId,
  );
}

class ProductsRemoteSourceImpl extends ProductsRemoteSource {
  final http.Client client;

  ProductsRemoteSourceImpl({this.client});

  @override
  Future<Products> getProducts(
    int offset,
    String shopId,
    String categoryId,
    String brandId,
  ) async {
    final response = await client.get(
        '$baseUrl/api/product?limit=3&offset=$offset&shop=$shopId&category=$categoryId&brand=$brandId');

    if (response.statusCode == 200) {
      print(
          'Products URL: $baseUrl/api/product?limit=3&offset=$offset&shop=$shopId&category=$categoryId&brand=$brandId');
      return Products.fromJson(json.decode(response.body));
    } else {
      throw UnknownException();
    }
  }
}
