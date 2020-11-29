import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:perminda/core/errors/exception.dart';
import 'package:perminda/core/errors/failure.dart';
import 'package:perminda/core/network/network_info.dart';
import 'package:perminda/data/data_sources/products/products_local_source.dart';
import 'package:perminda/data/data_sources/products/products_remote_source.dart';
import 'package:perminda/data/db/models/product/product_table.dart';
import 'package:perminda/data/remote_models/products/products.dart';
import 'package:perminda/data/repos/products/products_repo_impl.dart';

import '../../../fixtures/fixture_reader.dart';

class MockNetworkInfo extends Mock implements NetWorkInfo {}

class MockRemoteSource extends Mock implements ProductsRemoteSource {}

class MockLocalSource extends Mock implements ProductsLocalSource {}

void main() {
  MockNetworkInfo netWorkInfo;
  MockRemoteSource remoteSource;
  MockLocalSource localSource;
  ProductsRepoImpl repo;

  setUp(() {
    netWorkInfo = MockNetworkInfo();
    remoteSource = MockRemoteSource();
    localSource = MockLocalSource();
    repo = ProductsRepoImpl(
      netWorkInfo: netWorkInfo,
      remoteSource: remoteSource,
      localSource: localSource,
    );
  });

  group('device is online', () {
    setUp(() {
      when(netWorkInfo.isConnected()).thenAnswer((_) async => true);
    });

    group('getProducts', () {
      final productsResult =
          Products.fromJson(json.decode(fixture('products.json')));

      test('should user has an internet connection', () async {
        when(remoteSource.getProducts(repo.offset, null, null, null))
            .thenAnswer((_) async => productsResult);

        await repo.getProducts(null, null, null);

        verify(netWorkInfo.isConnected());
        expect(await netWorkInfo.isConnected(), true);
      });

      test('should cache the offset', () async {
        when(remoteSource.getProducts(repo.offset, null, null, null))
            .thenAnswer((_) async => productsResult);

        await repo.getProducts(null, null, null);

        expect(repo.offset, 400);
      });

      test('should return list of [ProductsReult] if remote call is success',
          () async {
        when(remoteSource.getProducts(repo.offset, null, null, null))
            .thenAnswer((_) async => productsResult);

        final result = await repo.getProducts(null, null, null);

        expect(result, Right(productsResult.results));
      });

      test('should cache list of [Products] in the databasee', () async {
        when(remoteSource.getProducts(repo.offset, null, null, null))
            .thenAnswer((_) async => productsResult);

        when(localSource.insertProducts(
                ProductTable.fromProductsesult(productsResult.results)))
            .thenAnswer((_) async => null);

        await repo.getProducts(null, null, null);

        verify(localSource.insertProducts(any));
      });

      test(
          'shuold return [UnknownFailure] if remote call throws [UnknownException]',
          () async {
        when(remoteSource.getProducts(repo.offset, null, null, null))
            .thenThrow(UnknownException());
        final result = await repo.getProducts(null, null, null);
        expect(result, Left(UnknownFailure()));
      });
    });
  });

  group('device is offline', () {
    setUp(() {
      when(netWorkInfo.isConnected()).thenAnswer((_) async => false);
    });

    group('getProducts', () {
      test('should return false if user has no internet connection', () async {
        await repo.getProducts(null, null, null);
        verify(netWorkInfo.isConnected());
        expect(await netWorkInfo.isConnected(), false);
      });

      test(
          'should return [NoInternetFailure] if user has no internet connection',
          () async {
        final result = await repo.getProducts(null, null, null);

        expect(result, Left(NoInternetFailure()));
      });
    });
  });
}
