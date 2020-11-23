import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:perminda/core/errors/exception.dart';
import 'package:perminda/core/errors/failure.dart';
import 'package:perminda/core/network/network_info.dart';
import 'package:perminda/data/data_sources/favourites/favourites_remote_source.dart';
import 'package:perminda/data/remote_models/favourites/favourites.dart';
import 'package:perminda/data/remote_models/favourites/results.dart';
import 'package:perminda/data/repos/favourites/favourites_repo_impl.dart';

import '../../../fixtures/fixture_reader.dart';

class MockNetworkInfo extends Mock implements NetWorkInfo {}

class MockRemoteSource extends Mock implements FavouritesRemoteSource {}

void main() {
  MockNetworkInfo netWorkInfo;
  MockRemoteSource remoteSource;
  FavouritesRepoImpl repo;

  final favourites =
      Favourites.fromJson(json.decode(fixture('favourites.json')));

  final favourite =
      FavouritesResult.fromJson(json.decode(fixture('favourite.json')));

  setUp(() {
    netWorkInfo = MockNetworkInfo();
    remoteSource = MockRemoteSource();
    repo = FavouritesRepoImpl(
        netWorkInfo: netWorkInfo, remoteSource: remoteSource);
  });

  group('device is online', () {
    setUp(() {
      when(netWorkInfo.isConnected()).thenAnswer((_) async => true);
    });

    group('addFavourite', () {
      test('should user has an internet connection', () async {
        await repo.addFavourite(null);
        verify(netWorkInfo.isConnected());
        expect(await netWorkInfo.isConnected(), true);
      });

      test('should return [FavouritesResult] if remote call is success',
          () async {
        when(remoteSource.addFavourite(null))
            .thenAnswer((_) async => favourite);

        final result = await repo.addFavourite(null);

        expect(result, Right(favourite));
      });

      test(
          'shuold return [FavouritesFieldsFailure] if remote call throws [FieldsException]',
          () async {
        when(remoteSource.addFavourite(null)).thenThrow(
            FieldsException(body: fixture('favourite_fields_error.json')));

        final result = await repo.addFavourite(null);

        expect(
          result,
          Left(FavouritesFieldsFailure.fromFieldsException(json.decode(
            fixture('favourite_fields_error.json'),
          ))),
        );
      });

      test(
          'shuold return [UnauthorizedTokenFailure] if remote call throws [UnauthorizedTokenException]',
          () async {
        when(remoteSource.addFavourite(null))
            .thenThrow(UnauthorizedTokenException());

        final result = await repo.addFavourite(null);

        expect(result, Left(UnauthorizedTokenFailure()));
      });

      test(
          'shuold return [UnknownFailure] if remote call throws [UnknownException]',
          () async {
        when(remoteSource.addFavourite(null)).thenThrow(UnknownException());
        final result = await repo.addFavourite(null);
        expect(result, Left(UnknownFailure()));
      });
    });

    group('deleteFavourite', () {
      test('should user has an internet connection', () async {
        await repo.deleteFavourite(null);
        verify(netWorkInfo.isConnected());
        expect(await netWorkInfo.isConnected(), true);
      });

      test('should return [true] if remote call is success', () async {
        when(remoteSource.deleteFavourite(null)).thenAnswer((_) async => true);

        final result = await repo.deleteFavourite(null);

        expect(result, Right(true));
      });

      test(
          'shuold return [UnauthorizedTokenFailure] if remote call throws [UnauthorizedTokenException]',
          () async {
        when(remoteSource.deleteFavourite(null))
            .thenThrow(UnauthorizedTokenException());

        final result = await repo.deleteFavourite(null);

        expect(result, Left(UnauthorizedTokenFailure()));
      });

      test(
          'shuold return [ItemNotFoundFailure] if remote call throws [ItemNotFoundException]',
          () async {
        when(remoteSource.deleteFavourite(null))
            .thenThrow(ItemNotFoundException());

        final result = await repo.deleteFavourite(null);

        expect(result, Left(ItemNotFoundFailure()));
      });

      test(
          'shuold return [UnknownFailure] if remote call throws [UnknownException]',
          () async {
        when(remoteSource.addFavourite(null)).thenThrow(UnknownException());
        final result = await repo.addFavourite(null);
        expect(result, Left(UnknownFailure()));
      });
    });

    group('getFavourites', () {
      test('should user has an internet connection', () async {
        when(remoteSource.getFavourites(repo.offset))
            .thenAnswer((_) async => favourites);

        await repo.getFavourites(repo.offset);

        verify(netWorkInfo.isConnected());
        expect(await netWorkInfo.isConnected(), true);
      });

      test('should cache the offset', () async {
        when(remoteSource.getFavourites(repo.offset))
            .thenAnswer((_) async => favourites);

        await repo.getFavourites(repo.offset);

        expect(repo.offset, 400);
      });

      test('should return [Favourites] if remote call is success', () async {
        when(remoteSource.getFavourites(repo.offset))
            .thenAnswer((_) async => favourites);

        final result = await repo.getFavourites(repo.offset);

        expect(result, Right(favourites));
      });

      test(
          'shuold return [UnauthorizedTokenFailure] if remote call throws [UnauthorizedTokenException]',
          () async {
        when(remoteSource.getFavourites(repo.offset))
            .thenThrow(UnauthorizedTokenException());

        final result = await repo.getFavourites(repo.offset);

        expect(result, Left(UnauthorizedTokenFailure()));
      });

      test(
          'shuold return [UnknownFailure] if remote call throws [UnknownException]',
          () async {
        when(remoteSource.getFavourites(repo.offset))
            .thenThrow(UnknownException());
        final result = await repo.getFavourites(repo.offset);
        expect(result, Left(UnknownFailure()));
      });
    });
  });

  group('device is offline', () {
    setUp(() {
      when(netWorkInfo.isConnected()).thenAnswer((_) async => false);
    });

    group('addFavourite', () {
      test('should return false if user has no internet connection', () async {
        await repo.addFavourite(null);
        verify(netWorkInfo.isConnected());
        expect(await netWorkInfo.isConnected(), false);
      });

      test(
          'should return [NoInternetFailure] if user has no internet connection',
          () async {
        final result = await repo.addFavourite(null);

        expect(result, Left(NoInternetFailure()));
      });
    });

    group('deleteFavourite', () {
      test('should return false if user has no internet connection', () async {
        await repo.deleteFavourite(null);
        verify(netWorkInfo.isConnected());
        expect(await netWorkInfo.isConnected(), false);
      });

      test(
          'should return [NoInternetFailure] if user has no internet connection',
          () async {
        final result = await repo.deleteFavourite(null);

        expect(result, Left(NoInternetFailure()));
      });
    });

    group('getFavourites', () {
      test('should return false if user has no internet connection', () async {
        await repo.getFavourites(repo.offset);
        verify(netWorkInfo.isConnected());
        expect(await netWorkInfo.isConnected(), false);
      });

      test(
          'should return [NoInternetFailure] if user has no internet connection',
          () async {
        final result = await repo.getFavourites(repo.offset);

        expect(result, Left(NoInternetFailure()));
      });
    });
  });
}
