import 'dart:convert';

import 'package:perminda/core/constants/sensetive_constants.dart';
import 'package:perminda/core/errors/exception.dart';
import 'package:perminda/data/remote_models/shops/shop.dart';
import 'package:http/http.dart' as http;

abstract class ShopsRemoteSource {
  Future<List<Shop>> getShops();

  Future<Shop> getShopById(String id);
}

class ShopsRemoteSourceImpl extends ShopsRemoteSource {
  final http.Client client;

  ShopsRemoteSourceImpl({this.client});

  @override
  Future<List<Shop>> getShops() async {
    final response = await client.get('$baseUrl/api/shop/');

    if (response.statusCode == 200) {
      return (json.decode(response.body) as List)
          .map((shop) => Shop.fromJson(shop))
          .toList();
    } else {
      throw UnknownException(message: json.decode(response.body));
    }
  }

  @override
  Future<Shop> getShopById(String id) async {
    final response = await client.get('$baseUrl/api/shop/$id');

    if (response.statusCode == 200) {
      return Shop.fromJson(json.decode(response.body));
    } else if (response.statusCode == 404) {
      throw ItemNotFoundException();
    } else {
      throw UnknownException();
    }
  }
}
