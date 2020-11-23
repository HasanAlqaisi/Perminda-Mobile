import 'dart:convert';

import 'package:perminda/core/constants/sensetive_constants.dart';
import 'package:perminda/core/errors/exception.dart';
import 'package:perminda/data/remote_models/cart_items/cart_items.dart';
import 'package:perminda/data/remote_models/cart_items/results.dart';
import 'package:http/http.dart' as http;

abstract class CartItemsRemoteSource {
  Future<CartItems> getCartItems(int offset);

  Future<CartItemsResult> addCartItem(
    String productId,
    int quantity,
  );

  Future<CartItemsResult> editCartItem(
    String id,
    String productId,
    int quantity,
  );

  Future<bool> deleteCartItem(String id);
}

class CartItemsRemoteSourceImpl extends CartItemsRemoteSource {
  final http.Client client;

  CartItemsRemoteSourceImpl({this.client});

  @override
  Future<CartItemsResult> addCartItem(String productId, int quantity) async {
    final response = await client.post(
      '$baseUrl/api/cart-item/',
      headers: {'Authorization': token},
      body: {'product': productId, 'quantity': quantity},
    );

    if (response.statusCode == 201) {
      return CartItemsResult.fromJson(json.decode(response.body));
    } else if (response.statusCode == 401) {
      throw UnauthorizedTokenException();
    } else if (response.statusCode == 400) {
      throw FieldsException(body: response.body);
    } else {
      throw UnknownException(message: response.body);
    }
  }

  @override
  Future<bool> deleteCartItem(String id) async {
    final response = await client.delete(
      '$baseUrl/api/cart-item/$id/',
      headers: {'Authorization': token},
    );

    if (response.statusCode == 204) {
      return true;
    } else if (response.statusCode == 401) {
      throw UnauthorizedTokenException();
    } else if (response.statusCode == 404) {
      throw ItemNotFoundException();
    } else {
      throw UnknownException(message: response.body);
    }
  }

  @override
  Future<CartItemsResult> editCartItem(
      String id, String productId, int quantity) async {
    final response = await client.put(
      '$baseUrl/api/cart-item/$id/',
      headers: {'Authorization': token},
      body: {'product': productId, 'quantity': quantity},
    );

    if (response.statusCode == 200) {
      return CartItemsResult.fromJson(json.decode(response.body));
    } else if (response.statusCode == 401) {
      throw UnauthorizedTokenException();
    } else if (response.statusCode == 404) {
      throw ItemNotFoundException();
    } else if (response.statusCode == 400) {
      throw FieldsException(body: response.body);
    } else {
      throw UnknownException(message: response.body);
    }
  }

  @override
  Future<CartItems> getCartItems(int offset) async {
    final response = await client.get(
      '$baseUrl/api/cart-item?limit=10&offset=$offset',
      headers: {'Authorization': token},
    );

    if (response.statusCode == 200) {
      return CartItems.fromJson(json.decode(response.body));
    } else if (response.statusCode == 401) {
      throw UnauthorizedTokenException();
    } else {
      throw UnknownException();
    }
  }
}
