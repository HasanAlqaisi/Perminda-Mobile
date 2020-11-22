import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:perminda/core/errors/exception.dart';
import 'package:perminda/core/errors/failure.dart';
import 'package:perminda/core/network/network_info.dart';
import 'package:perminda/data/data_sources/brands/remote_source.dart';
import 'package:perminda/data/remote_models/brands/brands.dart';
import 'package:perminda/data/remote_models/brands/results.dart';
import 'package:perminda/data/repos/brands/brands_repo_impl.dart';

import '../../../fixtures/fixture_reader.dart';
import '../shops/shops_repo_impl_test.dart';

class MockNetworkInfo extends Mock implements NetWorkInfo {}

class MockRemoteSource extends Mock implements BrandsRemoteSource {}

void main() {
  MockNetWorkInfo netWorkInfo;
  MockRemoteSource remoteSource;
  BrandsRepoImpl brandsRepo;

  setUp(() {
    netWorkInfo = MockNetWorkInfo();
    remoteSource = MockRemoteSource();
    brandsRepo =
        BrandsRepoImpl(netWorkInfo: netWorkInfo, remoteSource: remoteSource);
  });

  group('device is online', () {
    setUp(() {
      when(netWorkInfo.isConnected()).thenAnswer((_) async => true);
    });

    group('getBrands', () {
      final brands = Brands.fromJson(json.decode(fixture('brands.json')));

      test('should user has an internet connection', () async {
        when(remoteSource.getBrands(brandsRepo.offset))
            .thenAnswer((_) async => brands);

        await brandsRepo.getBrands();

        verify(netWorkInfo.isConnected());
        expect(await netWorkInfo.isConnected(), true);
      });

      test('should cache the offset', () async {
        when(remoteSource.getBrands(brandsRepo.offset))
            .thenAnswer((_) async => brands);

        await brandsRepo.getBrands();

        expect(brandsRepo.offset, 400);
      });

      test('shuold return list of [brands] if remote call success', () async {
        when(remoteSource.getBrands(brandsRepo.offset))
            .thenAnswer((_) async => brands);
        final result = await brandsRepo.getBrands();
        expect(result, Right(brands));
      });

      test(
          'shuold return [UnknownFailure] if remote call throws [UnknownException]',
          () async {
        when(remoteSource.getBrands(brandsRepo.offset))
            .thenThrow(UnknownException());
        final result = await brandsRepo.getBrands();
        expect(result, Left(UnknownFailure()));
      });
    });

    group('getBrandById', () {
      final brand = BrandsResult.fromJson(json.decode(fixture('brand.json')));

      test('should user has an internet connection', () async {
        await brandsRepo.getBrandById(null);
        verify(netWorkInfo.isConnected());
        expect(await netWorkInfo.isConnected(), true);
      });

      test('shuold return list of [brands] if remote call success', () async {
        when(remoteSource.getBrandById(null)).thenAnswer((_) async => brand);
        final result = await brandsRepo.getBrandById(null);
        expect(result, Right(brand));
      });

      test(
          'shuold return [ItemNotFoundFailure] if remote call throws [ItemNotFoundException]',
          () async {
        when(remoteSource.getBrandById(null))
            .thenThrow(ItemNotFoundException());
        final result = await brandsRepo.getBrandById(null);
        expect(result, Left(ItemNotFoundFailure()));
      });

      test(
          'shuold return [UnknownFailure] if remote call throws [UnknownException]',
          () async {
        when(remoteSource.getBrandById(null)).thenThrow(UnknownException());
        final result = await brandsRepo.getBrandById(null);
        expect(result, Left(UnknownFailure()));
      });
    });
  });

  group('device is offline', () {
    setUp(() {
      when(netWorkInfo.isConnected()).thenAnswer((_) async => false);
    });

    group('getBrands', () {
      test('should return false if user has no internet connection', () async {
        await brandsRepo.getBrands();
        expect(await netWorkInfo.isConnected(), false);
      });
      test('should return [NoInternetFailure] is user has no connection',
          () async {
        final result = await brandsRepo.getBrands();
        expect(result, Left(NoInternetFailure()));
      });
    });

    group('getBrandById', () {
      test('should return false if user has no internet connection', () async {
        await brandsRepo.getBrandById(null);
        expect(await netWorkInfo.isConnected(), false);
      });
      test('should return [NoInternetFailure] is user has no connection',
          () async {
        final result = await brandsRepo.getBrandById(null);
        expect(result, Left(NoInternetFailure()));
      });
    });
  });
}
