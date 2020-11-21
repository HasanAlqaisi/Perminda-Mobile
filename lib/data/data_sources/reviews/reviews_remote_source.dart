import 'dart:convert';

import 'package:perminda/core/constants/sensetive_constants.dart';
import 'package:perminda/core/errors/exception.dart';
import 'package:perminda/data/remote_models/reviews/review.dart';
import 'package:http/http.dart' as http;

abstract class ReviewsRemoteSource {
  Future<List<Review>> getReviews(String productId);

  Future<Review> addReview(
    int rate,
    String message,
    String productId,
  );

  Future<Review> editReview(
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
  Future<Review> addReview(int rate, String message, String productId) async {
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
      return Review.fromJson(json.decode(response.body));
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
  Future<Review> editReview(
      String reviewId, int rate, String message, String productId) async {
    final response = await client.put(
      '$baseUrl/api/review/$reviewId/',
      headers: {'Authorization': token},
    );

    if (response.statusCode == 200) {
      return Review.fromJson(json.decode(response.body));
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
  Future<List<Review>> getReviews(String productId) async {
    final response = await client.get(
      '$baseUrl/api/review/',
      headers: {'product': productId},
    );

    if (response.statusCode == 200) {
      return (json.decode(response.body) as List)
          .map((review) => Review.fromJson(review))
          .toList();
    } else {
      throw UnknownException();
    }
  }
}
