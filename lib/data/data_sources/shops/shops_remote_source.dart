import 'dart:convert';

import 'package:perminda/core/constants/sensetive_constants.dart';
import 'package:perminda/core/errors/exception.dart';
import 'package:perminda/data/remote_models/shops/results.dart';
import 'package:http/http.dart' as http;
import 'package:perminda/data/remote_models/shops/shops.dart';

abstract class ShopsRemoteSource {
  Future<Shops> getShops(int offset);

  Future<ShopsResult> getShopById(String id);
}

class ShopsRemoteSourceImpl extends ShopsRemoteSource {
  final http.Client client;

  ShopsRemoteSourceImpl({this.client});

  @override
  Future<Shops> getShops(int offset) async {
    final response =
        await client.get('$baseUrl/api/shop?limit=10&offset=$offset');

    if (response.statusCode == 200) {
      return Shops.fromJson(json.decode(response.body));
    } else {
      throw UnknownException(message: json.decode(response.body));
    }
  }

  @override
  Future<ShopsResult> getShopById(String id) async {
    final response = await client.get('$baseUrl/api/shop/$id');

    if (response.statusCode == 200) {
      return ShopsResult.fromJson(json.decode(response.body));
    } else if (response.statusCode == 404) {
      throw ItemNotFoundException();
    } else {
      throw UnknownException();
    }
  }
}
