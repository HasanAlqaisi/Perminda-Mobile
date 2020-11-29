import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:perminda/core/errors/exception.dart';
import 'package:perminda/core/errors/failure.dart';
import 'package:perminda/core/network/network_info.dart';
import 'package:perminda/data/data_sources/shops/shops_local_source.dart';
import 'package:perminda/data/data_sources/shops/shops_remote_source.dart';
import 'package:perminda/data/db/models/shop/shop_table.dart';
import 'package:perminda/data/remote_models/shops/results.dart';
import 'package:perminda/data/remote_models/shops/shops.dart';
import 'package:perminda/data/repos/shops/shops_repo_impl.dart';

import '../../../fixtures/fixture_reader.dart';

class MockNetWorkInfo extends Mock implements NetWorkInfo {}

class MockRemoteDataSource extends Mock implements ShopsRemoteSource {}

class MockLocalSource extends Mock implements ShopsLocalSource {}

void main() {
  MockNetWorkInfo netWorkInfo;
  MockRemoteDataSource remoteDataSource;
  MockLocalSource localSource;
  ShopsRepoImpl shopsRepo;

  setUp(() {
    netWorkInfo = MockNetWorkInfo();
    remoteDataSource = MockRemoteDataSource();
    localSource = MockLocalSource();
    shopsRepo = ShopsRepoImpl(
      netWorkInfo: netWorkInfo,
      remoteSource: remoteDataSource,
      localSource: localSource,
    );
  });

  group('device is online', () {
    setUp(() {
      when(netWorkInfo.isConnected()).thenAnswer((_) async => true);
    });
    group('getShops', () {
      final shops = Shops.fromJson(json.decode(fixture('shops.json')));

      test('should check if the device is online', () async {
        when(remoteDataSource.getShops(shopsRepo.offset))
            .thenAnswer((_) async => shops);

        shopsRepo.getShops();

        verify(netWorkInfo.isConnected());
        expect(await netWorkInfo.isConnected(), true);
      });

      test('should cache the offset', () async {
        when(remoteDataSource.getShops(shopsRepo.offset))
            .thenAnswer((_) async => shops);

        await shopsRepo.getShops();

        expect(shopsRepo.offset, 400);
      });

      test('should return list of [Shop] when remote call is success',
          () async {
        when(remoteDataSource.getShops(shopsRepo.offset))
            .thenAnswer((_) async => shops);

        final result = await shopsRepo.getShops();

        expect(result, Right(shops));
      });

      test('should cache the list of [Shop] in the databasee', () async {
        when(remoteDataSource.getShops(shopsRepo.offset))
            .thenAnswer((_) async => shops);

        when(localSource.insertShops(ShopTable.fromShopsResult(shops.results)))
            .thenAnswer((_) async => null);

        await shopsRepo.getShops();
        verify(localSource.insertShops(any));
      });

      test(
          'should return [UnknownFailure] when remote call throws [UnknownException]',
          () async {
        when(remoteDataSource.getShops(shopsRepo.offset))
            .thenThrow(UnknownException());

        final result = await shopsRepo.getShops();

        expect(result, Left(UnknownFailure()));
      });
    });

    group('getShopById', () {
      final shop = ShopsResult.fromJson(json.decode(fixture('shop.json')));

      test('should check if the device is online', () async {
        when(remoteDataSource.getShopById(null)).thenAnswer((_) async => shop);

        shopsRepo.getShopById(null);

        verify(netWorkInfo.isConnected());
        expect(await netWorkInfo.isConnected(), true);
      });

      test('should return [Shop] when remote call is success', () async {
        when(remoteDataSource.getShopById(null)).thenAnswer((_) async => shop);

        final result = await shopsRepo.getShopById(null);

        expect(result, Right(shop));
      });

      test('should cache [Shop] in the databasee', () async {
        when(remoteDataSource.getShopById('')).thenAnswer((_) async => shop);

        when(localSource.insertShops(ShopTable.fromShopsResult([shop])))
            .thenAnswer((_) async => null);

        await shopsRepo.getShopById('');
        verify(localSource.insertShops(any));
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
