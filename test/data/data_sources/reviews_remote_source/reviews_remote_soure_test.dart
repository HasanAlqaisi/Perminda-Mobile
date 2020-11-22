import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:perminda/core/constants/sensetive_constants.dart';
import 'package:perminda/core/errors/exception.dart';
import 'package:http/http.dart' as http;
import 'package:perminda/data/data_sources/reviews/reviews_remote_source.dart';
import 'package:perminda/data/remote_models/reviews/results.dart';
import 'package:perminda/data/remote_models/reviews/reviews.dart';

import '../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  MockHttpClient client;
  ReviewsRemoteSourceImpl remoteSource;
  const int limit = 10;
  int offset = 0;

  setUp(() {
    client = MockHttpClient();
    remoteSource = ReviewsRemoteSourceImpl(client: client);
  });

  group('getReviews', () {
    final reviews = Reviews.fromJson(json.decode(fixture('reviews.json')));

    void do200Response() {
      when(client.get(
              '$baseUrl/api/review?limit=$limit&offset=$offset&product=null'))
          .thenAnswer((_) async => http.Response(fixture('reviews.json'), 200));
    }

    test('should return list of [reviews] if response code is 200', () async {
      do200Response();

      final result = await remoteSource.getReviews(null, offset);

      expect(result, reviews);
    });

    test('should throw [UnknownException] if response code is not expected',
        () {
      when(client.get(
              '$baseUrl/api/review?limit=$limit&offset=$offset&product=null'))
          .thenAnswer((_) async => http.Response(fixture('detail.json'), 500));

      final result = remoteSource.getReviews;
      expect(() => result(null, offset), throwsA(isA<UnknownException>()));
    });
  });

  group('editReview', () {
    final review = ReviewsResult.fromJson(json.decode(fixture('review.json')));

    void do200Response() {
      when(client.put('$baseUrl/api/review/${review.id}/',
              headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(fixture('review.json'), 200));
    }

    test('should returm [review] if response code is 200', () async {
      do200Response();

      final result = await remoteSource.editReview(review.id, 0, '', '');

      expect(result, review);
    });

    test('should throw [UnauthorizedTokenException] if response code is 401',
        () {
      when(client.put('$baseUrl/api/review/${review.id}/',
              headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(fixture('detail.json'), 401));

      final result = remoteSource.editReview;

      expect(() => result(review.id, 0, null, null),
          throwsA(isA<UnauthorizedTokenException>()));
    });

    test('should throw [ItemNotFoundException] if response code is 404', () {
      when(client.put('$baseUrl/api/review/${review.id}/',
              headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(fixture('detail.json'), 404));

      final result = remoteSource.editReview;

      expect(() => result(review.id, 0, null, null),
          throwsA(isA<ItemNotFoundException>()));
    });

    test('should throw [FieldsException] if response code is 400', () {
      when(client.put('$baseUrl/api/review/${review.id}/',
              headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(fixture('detail.json'), 400));

      final result = remoteSource.editReview;

      expect(() => result(review.id, 0, null, null),
          throwsA(isA<FieldsException>()));
    });

    test('should throw [NotAllowedPermissionException] if response code is 403',
        () {
      when(client.put('$baseUrl/api/review/${review.id}/',
              headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(fixture('detail.json'), 403));

      final result = remoteSource.editReview;

      expect(() => result(review.id, 0, null, null),
          throwsA(isA<NotAllowedPermissionException>()));
    });

    test('should throw [UnknownException] if response code is not expected',
        () {
      when(client.put('$baseUrl/api/review/${review.id}/',
              headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(fixture('detail.json'), 500));

      final result = remoteSource.editReview;

      expect(() => result(review.id, 0, null, null),
          throwsA(isA<UnknownException>()));
    });
  });

  group('deleteReviews', () {
    final review = ReviewsResult.fromJson(json.decode(fixture('review.json')));

    void do204Response() {
      when(client.delete('$baseUrl/api/review/${review.id}/',
              headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(fixture('review.json'), 204));
    }

    test('should return [true] if response code is 204', () async {
      do204Response();

      final result = await remoteSource.deleteReview(review.id);

      expect(result, true);
    });

    test('should throw [UnknownException] if response code is not expected',
        () {
      when(client.delete('$baseUrl/api/review/${review.id}/',
              headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(fixture('detail.json'), 500));
      final result = remoteSource.deleteReview;
      expect(() => result(review.id), throwsA(isA<UnknownException>()));
    });

    test('should throw [UnauthorizedTokenException] if response code is 401',
        () {
      when(client.delete('$baseUrl/api/review/${review.id}/',
              headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(fixture('detail.json'), 401));
      final result = remoteSource.deleteReview;
      expect(
          () => result(review.id), throwsA(isA<UnauthorizedTokenException>()));
    });

    test('should throw [ItemNotFoundException] if response code is 404', () {
      when(client.delete('$baseUrl/api/review/${review.id}/',
              headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(fixture('detail.json'), 404));
      final result = remoteSource.deleteReview;
      expect(() => result(review.id), throwsA(isA<ItemNotFoundException>()));
    });
  });

  group('addReview', () {
    final review = ReviewsResult.fromJson(json.decode(fixture('review.json')));

    void do201Response() {
      when(client.post('$baseUrl/api/review/',
              body: anyNamed('body'), headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(fixture('review.json'), 201));
    }

    test('should return [review] if response code is 201', () async {
      do201Response();

      final result = await remoteSource.addReview(
          review.rate, review.message, review.productId);

      expect(result, review);
    });

    test('should throw [FieldsException] if response code is 400', () {
      when(client.post('$baseUrl/api/review/',
              body: anyNamed('body'), headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(fixture('detail.json'), 400));
      final result = remoteSource.addReview;
      expect(() => result(review.rate, review.message, review.productId),
          throwsA(isA<FieldsException>()));
    });

    test('should throw [NotAllowedPermissionException] if response code is 403',
        () {
      when(client.post('$baseUrl/api/review/',
              body: anyNamed('body'), headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(fixture('detail.json'), 403));
      final result = remoteSource.addReview;
      expect(() => result(review.rate, review.message, review.productId),
          throwsA(isA<NotAllowedPermissionException>()));
    });

    test('should throw [UnauthorizedTokenException] if response code is 401',
        () {
      when(client.post('$baseUrl/api/review/',
              body: anyNamed('body'), headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(fixture('detail.json'), 401));
      final result = remoteSource.addReview;
      expect(() => result(review.rate, review.message, review.productId),
          throwsA(isA<UnauthorizedTokenException>()));
    });

    test('should throw [UnknownException] if response code is not expected',
        () {
      when(client.post('$baseUrl/api/review/',
              body: anyNamed('body'), headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(fixture('detail.json'), 500));
      final result = remoteSource.addReview;
      expect(() => result(review.rate, review.message, review.productId),
          throwsA(isA<UnknownException>()));
    });
  });
}
