import 'dart:convert';
import 'dart:io';

import 'package:perminda/core/constants/sensetive_constants.dart';
import 'package:perminda/core/errors/exception.dart';
import 'package:perminda/data/remote_models/product_image/product_image.dart';
import 'package:http/http.dart' as http;

abstract class ProductImageRemoteSource {
  Future<ProductImage> getProductImage(String id);

  Future<ProductImage> addProductImage(
    File image,
    int type,
    String productId,
  );

  Future<ProductImage> editProductImage(
    String id,
    File image,
    int type,
    String productId,
  );

  Future<bool> deleteProductImage(String id);
}

class ProductImageRemoteSourceImpl extends ProductImageRemoteSource {
  final http.Client client;

  ProductImageRemoteSourceImpl({this.client});

  @override
  Future<ProductImage> addProductImage(
      File image, int type, String productId) async {
    final response = await client.post(
      '$baseUrl/api/product-image/',
      body: {
        'image': image,
        'type': type,
        'product': productId,
      },
      headers: {'Authorization': token},
    );

    if (response.statusCode == 201) {
      return ProductImage.fromJson(json.decode(response.body));
    } else if (response.statusCode == 400) {
      throw FieldsException(body: response.body);
    } else if (response.statusCode == 401) {
      throw UnauthorizedTokenException();
    } else if (response.statusCode == 403) {
      throw NotAllowedPermissionException();
    } else {
      throw UnknownException();
    }
  }

  @override
  Future<bool> deleteProductImage(String id) async {
    final response = await client.delete(
      '$baseUrl/api/product-image/$id/',
      headers: {'Authorization': token},
    );

    if (response.statusCode == 204) {
      return true;
    } else if (response.statusCode == 401) {
      throw UnauthorizedTokenException();
    } else if (response.statusCode == 403) {
      throw NotAllowedPermissionException();
    } else if (response.statusCode == 404) {
      throw ItemNotFoundException();
    } else {
      throw UnknownException();
    }
  }

  @override
  Future<ProductImage> editProductImage(
      String id, File image, int type, String productId) async {
    final response = await client.put(
      '$baseUrl/api/product-image/$id/',
      body: {
        'image': image,
        'type': type,
        'product': productId,
      },
      headers: {'Authorization': token},
    );

    if (response.statusCode == 200) {
      return ProductImage.fromJson(json.decode(response.body));
    } else if (response.statusCode == 400) {
      throw FieldsException(body: response.body);
    } else if (response.statusCode == 401) {
      throw UnauthorizedTokenException();
    } else if (response.statusCode == 403) {
      throw NotAllowedPermissionException();
    } else if (response.statusCode == 404) {
      throw ItemNotFoundException();
    } else {
      throw UnknownException();
    }
  }

  @override
  Future<ProductImage> getProductImage(String id) async {
    final response = await client.get(
      '$baseUrl/api/product-image/$id/',
    );

    if (response.statusCode == 200) {
      return ProductImage.fromJson(json.decode(response.body));
    } else if (response.statusCode == 404) {
      throw ItemNotFoundException();
    } else {
      throw UnknownException();
    }
  }
}
