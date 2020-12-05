import 'dart:convert';

import 'package:perminda/core/constants/sensetive_constants.dart';
import 'package:perminda/core/errors/exception.dart';
import 'package:perminda/data/remote_models/favourites/favourites.dart';
import 'package:perminda/data/remote_models/favourites/results.dart';
import 'package:http/http.dart' as http;

abstract class FavouritesRemoteSource {
  Future<Favourites> getFavourites(int offset);

  Future<FavouritesResult> addFavourite(String productId);

  Future<bool> deleteFavourite(String id);
}

class FavouritesRemoteSourceImpl extends FavouritesRemoteSource {
  final http.Client client;

  FavouritesRemoteSourceImpl({this.client});

  @override
  Future<FavouritesResult> addFavourite(String productId) async {
    final response = await client.post(
      '$baseUrl/api/favourite/',
      headers: {'Authorization': kToken},
      body: {'product': productId},
    );

    if (response.statusCode == 201) {
      return FavouritesResult.fromJson(json.decode(response.body));
    } else if (response.statusCode == 400) {
      throw FieldsException(body: response.body);
    } else if (response.statusCode == 401) {
      throw UnauthorizedTokenException();
    } else {
      throw UnknownException(message: response.body);
    }
  }

  @override
  Future<bool> deleteFavourite(String id) async {
    final response = await client.delete(
      '$baseUrl/api/favourite/$id/',
      headers: {'Authorization': kToken},
    );

    if (response.statusCode == 204) {
      return true;
    } else if (response.statusCode == 404) {
      throw ItemNotFoundException();
    } else if (response.statusCode == 401) {
      throw UnauthorizedTokenException();
    } else {
      throw UnknownException(message: response.body);
    }
  }

  @override
  Future<Favourites> getFavourites(int offset) async {
    final response = await client.get(
      '$baseUrl/api/favourite?limit=10&offset=$offset',
      headers: {'Authorization': kToken},
    );

    if (response.statusCode == 200) {
      return Favourites.fromJson(json.decode(response.body));
    } else if (response.statusCode == 401) {
      throw UnauthorizedTokenException();
    } else {
      throw UnknownException(message: response.body);
    }
  }
}
