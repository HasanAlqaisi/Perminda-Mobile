import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:perminda/core/errors/exception.dart';
import 'package:perminda/core/errors/failure.dart';
import 'package:perminda/core/network/network_info.dart';
import 'package:perminda/data/data_sources/reviews/reviews_remote_source.dart';
import 'package:perminda/data/remote_models/reviews/review.dart';
import 'package:perminda/data/repos/reviews/reviews_repo_impl.dart';

import '../../../fixtures/fixture_reader.dart';

class MockNetworkInfo extends Mock implements NetWorkInfo {}

class MockRemoteSource extends Mock implements ReviewsRemoteSource {}

void main() {
  MockNetworkInfo netWorkInfo;
  MockRemoteSource remoteSource;
  ReviewsRepoImpl repo;

  setUp(() {
    netWorkInfo = MockNetworkInfo();
    remoteSource = MockRemoteSource();
    repo =
        ReviewsRepoImpl(netWorkInfo: netWorkInfo, remoteSource: remoteSource);
  });

  group('device is online', () {
    setUp(() {
      when(netWorkInfo.isConnected()).thenAnswer((_) async => true);
    });

    final review = Review.fromJson(json.decode(fixture('review.json')));

    final reviews = (json.decode(fixture('reviews.json')) as List)
        .map((review) => Review.fromJson(review))
        .toList();

    group('addReview', () {
      test('should user has an internet connection', () async {
        await repo.addReview(review.rate, review.message, review.productId);

        verify(netWorkInfo.isConnected());

        expect(await netWorkInfo.isConnected(), true);
      });

      test('should return [review] if remote call is success', () async {
        when(remoteSource.addReview(
                review.rate, review.message, review.productId))
            .thenAnswer((_) async => review);

        final result =
            await repo.addReview(review.rate, review.message, review.productId);

        expect(result, Right(review));
      });

      test(
          'shuold return [NotAllowedPermissionFailure] if remote call throws [NotAllowedPermissionException]',
          () async {
        when(remoteSource.addReview(
                review.rate, review.message, review.productId))
            .thenThrow(NotAllowedPermissionException());

        final result =
            await repo.addReview(review.rate, review.message, review.productId);

        expect(result, Left(NotAllowedPermissionFailure()));
      });

      test(
          'shuold return [UnauthorizedTokenFailure] if remote call throws [UnauthorizedTokenException]',
          () async {
        when(remoteSource.addReview(
                review.rate, review.message, review.productId))
            .thenThrow(UnauthorizedTokenException());

        final result =
            await repo.addReview(review.rate, review.message, review.productId);

        expect(result, Left(UnauthorizedTokenFailure()));
      });

      test(
          'shuold return [ReviewFieldsFailure] if remote call throws [FieldsException]',
          () async {
        final reviewFailure = ReviewFieldsFailure(rate: ['not in range']);

        when(remoteSource.addReview(
                review.rate, review.message, review.productId))
            .thenThrow(FieldsException(body: "{\"rate\": [\"not in range\"]}"));

        final result =
            await repo.addReview(review.rate, review.message, review.productId);

        expect(result, Left(reviewFailure));
      });

      test(
          'shuold return [UnknownFailure] if remote call throws [UnknownException]',
          () async {
        when(remoteSource.addReview(
                review.rate, review.message, review.productId))
            .thenThrow(UnknownException());

        final result =
            await repo.addReview(review.rate, review.message, review.productId);

        expect(result, Left(UnknownFailure()));
      });
    });

    group('deleteReview', () {
      test('should user has an internet connection', () async {
        await repo.deleteReview(review.id);

        verify(netWorkInfo.isConnected());

        expect(await netWorkInfo.isConnected(), true);
      });

      test('should return [true] if remote call is success', () async {
        when(remoteSource.deleteReview(review.id))
            .thenAnswer((_) async => true);

        final result = await repo.deleteReview(review.id);

        expect(result, Right(true));
      });

      test(
          'shuold return [UnauthorizedTokenFailure] if remote call throws [UnauthorizedTokenException]',
          () async {
        when(remoteSource.deleteReview(review.id))
            .thenThrow(UnauthorizedTokenException());

        final result = await repo.deleteReview(review.id);

        expect(result, Left(UnauthorizedTokenFailure()));
      });

      test(
          'shuold return [ItemNotFoundFailure] if remote call throws [ItemNotFoundException]',
          () async {
        when(remoteSource.deleteReview(review.id))
            .thenThrow(ItemNotFoundException());

        final result = await repo.deleteReview(review.id);

        expect(result, Left(ItemNotFoundFailure()));
      });

      test(
          'shuold return [UnknownFailure] if remote call throws [UnknownException]',
          () async {
        when(remoteSource.deleteReview(review.id))
            .thenThrow(UnknownException());

        final result = await repo.deleteReview(review.id);

        expect(result, Left(UnknownFailure()));
      });
    });

    group('getReviews', () {
      test('should user has an internet connection', () async {
        await repo.getReviews('');

        verify(netWorkInfo.isConnected());

        expect(await netWorkInfo.isConnected(), true);
      });

      test('should return list of [review] if remote call is success',
          () async {
        when(remoteSource.getReviews('')).thenAnswer((_) async => reviews);

        final result = await repo.getReviews('');

        expect(result, Right(reviews));
      });

      test(
          'shuold return [UnknownFailure] if remote call throws [UnknownException]',
          () async {
        when(remoteSource.getReviews('')).thenThrow(UnknownException());

        final result = await repo.getReviews('');

        expect(result, Left(UnknownFailure()));
      });
    });

    group('deleteReview', () {
      test('should user has an internet connection', () async {
        await repo.deleteReview(review.id);

        verify(netWorkInfo.isConnected());

        expect(await netWorkInfo.isConnected(), true);
      });

      test('should return [true] if remote call is success', () async {
        when(remoteSource.deleteReview(review.id))
            .thenAnswer((_) async => true);

        final result = await repo.deleteReview(review.id);

        expect(result, Right(true));
      });

      test(
          'shuold return [UnauthorizedTokenFailure] if remote call throws [UnauthorizedTokenException]',
          () async {
        when(remoteSource.deleteReview(review.id))
            .thenThrow(UnauthorizedTokenException());

        final result = await repo.deleteReview(review.id);

        expect(result, Left(UnauthorizedTokenFailure()));
      });

      test(
          'shuold return [ItemNotFoundFailure] if remote call throws [ItemNotFoundException]',
          () async {
        when(remoteSource.deleteReview(review.id))
            .thenThrow(ItemNotFoundException());

        final result = await repo.deleteReview(review.id);

        expect(result, Left(ItemNotFoundFailure()));
      });

      test(
          'shuold return [UnknownFailure] if remote call throws [UnknownException]',
          () async {
        when(remoteSource.deleteReview(review.id))
            .thenThrow(UnknownException());

        final result = await repo.deleteReview(review.id);

        expect(result, Left(UnknownFailure()));
      });
    });
  });

  group('device is offline', () {
    setUp(() {
      when(netWorkInfo.isConnected()).thenAnswer((_) async => false);
    });

    group('addReview', () {
      test('should return false if user has no internet connection', () async {
        await repo.addReview(0, '', '');
        verify(netWorkInfo.isConnected());
        expect(await netWorkInfo.isConnected(), false);
      });

      test(
          'should return [NoInternetFailure] if user has no internet connection',
          () async {
        final result = await repo.addReview(0, '', '');

        expect(result, Left(NoInternetFailure()));
      });
    });

    group('deleteReview', () {
      test('should return false if user has no internet connection', () async {
        await repo.deleteReview('');
        verify(netWorkInfo.isConnected());
        expect(await netWorkInfo.isConnected(), false);
      });

      test(
          'should return [NoInternetFailure] if user has no internet connection',
          () async {
        final result = await repo.deleteReview('');

        expect(result, Left(NoInternetFailure()));
      });
    });

    group('editReview', () {
      test('should return false if user has no internet connection', () async {
        await repo.editReview('', 0, '', '');
        verify(netWorkInfo.isConnected());
        expect(await netWorkInfo.isConnected(), false);
      });

      test(
          'should return [NoInternetFailure] if user has no internet connection',
          () async {
        final result = await repo.editReview('', 0, '', '');

        expect(result, Left(NoInternetFailure()));
      });
    });

    group('getReviews', () {
      test('should return false if user has no internet connection', () async {
        await repo.getReviews('');
        verify(netWorkInfo.isConnected());
        expect(await netWorkInfo.isConnected(), false);
      });

      test(
          'should return [NoInternetFailure] if user has no internet connection',
          () async {
        final result = await repo.getReviews('');

        expect(result, Left(NoInternetFailure()));
      });
    });
  });
}
