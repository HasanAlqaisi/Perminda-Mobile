import 'dart:convert';

import 'package:perminda/core/constants/sensetive_constants.dart';
import 'package:perminda/core/errors/exception.dart';
import 'package:perminda/data/remote_models/reviews/results.dart';
import 'package:http/http.dart' as http;
import 'package:perminda/data/remote_models/reviews/reviews.dart';

abstract class ReviewsRemoteSource {
  Future<Reviews> getReviews(String productId, int offset);

  Future<ReviewsResult> addReview(
    int rate,
    String message,
    String productId,
  );

  Future<ReviewsResult> editReview(
    String reviewId,
    int rate,
    String message,
    String productId,
  );

  Future<bool> deleteReview(String reviewId);
}

class ReviewsRemoteSourceImpl extends ReviewsRemoteSource {
  final http.Client client;

  ReviewsRemoteSourceImpl({this.client});

  @override
  Future<ReviewsResult> addReview(
      int rate, String message, String productId) async {
    final response = await client.post(
      '$baseUrl/api/review/',
      body: {
        'rate': rate,
        'message': message,
        'product': productId,
      },
      headers: {'Authorization': token},
    );

    if (response.statusCode == 201) {
      return ReviewsResult.fromJson(json.decode(response.body));
    } else if (response.statusCode == 400) {
      throw FieldsException();
    } else if (response.statusCode == 403) {
      throw NotAllowedPermissionException();
    } else if (response.statusCode == 401) {
      throw UnauthorizedTokenException();
    } else {
      throw UnknownException();
    }
  }

  @override
  Future<bool> deleteReview(String reviewId) async {
    final response = await client.delete(
      '$baseUrl/api/review/$reviewId/',
      headers: {'Authorization': token},
    );

    if (response.statusCode == 204) {
      return true;
    } else if (response.statusCode == 401) {
      throw UnauthorizedTokenException();
    } else if (response.statusCode == 404) {
      throw ItemNotFoundException();
    } else {
      throw UnknownException();
    }
  }

  @override
  Future<ReviewsResult> editReview(
      String reviewId, int rate, String message, String productId) async {
    final response = await client.put(
      '$baseUrl/api/review/$reviewId/',
      headers: {'Authorization': token},
    );

    if (response.statusCode == 200) {
      return ReviewsResult.fromJson(json.decode(response.body));
    } else if (response.statusCode == 401) {
      throw UnauthorizedTokenException();
    } else if (response.statusCode == 404) {
      throw ItemNotFoundException();
    } else if (response.statusCode == 400) {
      throw FieldsException(body: response.body);
    } else if (response.statusCode == 403) {
      throw NotAllowedPermissionException();
    } else {
      throw UnknownException();
    }
  }

  @override
  Future<Reviews> getReviews(String productId, int offset) async {
    final response = await client.get(
      '$baseUrl/api/review?limit=10&offset=$offset&product=$productId',
    );

    if (response.statusCode == 200) {
      return Reviews.fromJson(json.decode(response.body));
    } else {
      throw UnknownException();
    }
  }
}
