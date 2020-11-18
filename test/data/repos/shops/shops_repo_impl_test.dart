import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:perminda/core/errors/exception.dart';
import 'package:perminda/core/errors/failure.dart';
import 'package:perminda/core/network/network_info.dart';
import 'package:perminda/data/data_sources/shops/shops_remote_source.dart';
import 'package:perminda/data/remote_models/shops/shop.dart';
import 'package:perminda/data/repos/shops/shops_repo_impl.dart';

import '../../../fixtures/fixture_reader.dart';

class MockNetWorkInfo extends Mock implements NetWorkInfo {}

class MockRemoteDataSource extends Mock implements ShopsRemoteSource {}

void main() {
  MockNetWorkInfo netWorkInfo;
  MockRemoteDataSource remoteDataSource;
  ShopsRepoImpl shopsRepo;

  setUp(() {
    netWorkInfo = MockNetWorkInfo();
    remoteDataSource = MockRemoteDataSource();
    shopsRepo = ShopsRepoImpl(
      netWorkInfo: netWorkInfo,
      remoteSource: remoteDataSource,
    );
  });

  group('device is online', () {
    setUp(() {
      when(netWorkInfo.isConnected()).thenAnswer((_) async => true);
    });
    group('getShops', () {
      final shops = (json.decode(fixture('shops.json')) as List)
          .map((shop) => Shop.fromJson(shop))
          .toList();

      test('should check if the device is online', () async {
        shopsRepo.getShops();

        verify(netWorkInfo.isConnected());
        expect(await netWorkInfo.isConnected(), true);
      });

      test('should return list of [Shop] when remote call is success',
          () async {
        when(remoteDataSource.getShops()).thenAnswer((_) async => shops);

        final result = await shopsRepo.getShops();

        expect(result, Right(shops));
      });

      test(
          'should return [UnknownFailure] when remote call throws [UnknownException]',
          () async {
        when(remoteDataSource.getShops()).thenThrow(UnknownException());

        final result = await shopsRepo.getShops();

        expect(result, Left(UnknownFailure()));
      });
    });

    group('getShopById', () {
      final shop = Shop.fromJson(json.decode(fixture('shop.json')));

      test('should check if the device is online', () async {
        shopsRepo.getShopById(null);

        verify(netWorkInfo.isConnected());
        expect(await netWorkInfo.isConnected(), true);
      });

      test('should return [Shop] when remote call is success', () async {
        when(remoteDataSource.getShopById(null)).thenAnswer((_) async => shop);

        final result = await shopsRepo.getShopById(null);

        expect(result, Right(shop));
      });

      test(
          'should return [ItemNotFoundFailure] when remote call throws [ItemNotFoundException]',
          () async {
        when(remoteDataSource.getShopById(null))
            .thenThrow(ItemNotFoundException());

        final result = await shopsRepo.getShopById(null);

        expect(result, Left(ItemNotFoundFailure()));
      });

      test(
          'should return [UnknownFailure] when remote call throws [UnknownException]',
          () async {
        when(remoteDataSource.getShopById(null)).thenThrow(UnknownException());

        final result = await shopsRepo.getShopById(null);

        expect(result, Left(UnknownFailure()));
      });
    });
  });

  group('device is offline', () {
    setUp(() {
      when(netWorkInfo.isConnected()).thenAnswer((_) async => false);
    });

    group('getShops', () {
      test('should return [NoInternetFailure] when no internet is available',
          () async {
        final result = await shopsRepo.getShops();
        expect(result, Left(NoInternetFailure()));
      });
    });

    group('getShopById', () {
      test('should return [NoInternetFailure] when no internet is available',
          () async {
        final result = await shopsRepo.getShopById(null);
        expect(result, Left(NoInternetFailure()));
      });
    });
  });
}
