import 'dart:convert';

import 'package:perminda/core/api_helpers/api.dart';
import 'package:perminda/core/constants/sensetive_constants.dart';
import 'package:perminda/core/errors/exception.dart';
import 'package:perminda/data/remote_models/orders/orders.dart';
import 'package:perminda/data/remote_models/orders/order_params.dart';
import 'package:perminda/data/remote_models/orders/results.dart';
import 'package:http/http.dart' as http;

abstract class OrdersRemoteSource {
  Future<Orders> getOrders(int offset);

  Future<OrdersResult> addOrder(
    String address,
    List<OrderParams> orderParams,
  );

  Future<OrdersResult> editOrder(String id, String address);
}

class OrdersRemoteSourceImpl extends OrdersRemoteSource {
  final http.Client client;

  OrdersRemoteSourceImpl({this.client});

  @override
  Future<OrdersResult> addOrder(
    String address,
    List<OrderParams> orderParams,
  ) async {
    var url = API.orderUrlProvider(orderParams);

    final response = await client.post(
      url,
      headers: {'Authorization': token},
      body: {'address': address},
    );

    if (response.statusCode == 201) {
      return OrdersResult.fromJson(json.decode(response.body));
    } else if (response.statusCode == 401) {
      throw UnauthorizedTokenException();
    } else if (response.statusCode == 400) {
      throw FieldsException(body: response.body);
    } else {
      throw UnknownException(message: response.body);
    }
  }

  @override
  Future<OrdersResult> editOrder(String id, String address) async {
    final response = await client.put(
      '$baseUrl/api/order/',
      headers: {'Authorization': token},
      body: {'address': address},
    );

    if (response.statusCode == 200) {
      return OrdersResult.fromJson(json.decode(response.body));
    } else if (response.statusCode == 401) {
      throw UnauthorizedTokenException();
    } else if (response.statusCode == 400) {
      throw FieldsException(body: response.body);
    } else if (response.statusCode == 404) {
      throw ItemNotFoundException();
    } else {
      throw UnknownException(message: response.body);
    }
  }

  @override
  Future<Orders> getOrders(int offset) async {
    final response = await client.get(
      '$baseUrl/api/order?limit=10&offset=$offset',
      headers: {'Authorization': token},
    );

    if (response.statusCode == 200) {
      return Orders.fromJson(json.decode(response.body));
    } else if (response.statusCode == 401) {
      throw UnauthorizedTokenException();
    } else {
      throw UnknownException(message: response.body);
    }
  }
}
