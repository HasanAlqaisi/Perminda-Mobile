import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:perminda/core/errors/exception.dart';
import 'package:perminda/core/errors/failure.dart';
import 'package:perminda/core/network/network_info.dart';
import 'package:perminda/data/data_sources/categories/remote_soruce.dart';
import 'package:perminda/data/remote_models/categories/category.dart';
import 'package:perminda/data/repos/categories/categories_repo_impl.dart';

import '../../../fixtures/fixture_reader.dart';
import '../shops/shops_repo_impl_test.dart';

class MockNetworkInfo extends Mock implements NetWorkInfo {}

class MockRemoteSource extends Mock implements CategoriesRemoteSource {}

void main() {
  MockNetWorkInfo netWorkInfo;
  MockRemoteSource remoteSource;
  CategoriesRepoImpl categoriesRepo;

  setUp(() {
    netWorkInfo = MockNetWorkInfo();
    remoteSource = MockRemoteSource();
    categoriesRepo = CategoriesRepoImpl(
        netWorkInfo: netWorkInfo, remoteSource: remoteSource);
  });

  group('device is online', () {
    setUp(() {
      when(netWorkInfo.isConnected()).thenAnswer((_) async => true);
    });

    group('getCategories', () {
      final categories = (json.decode(fixture('categories.json')) as List)
          .map((category) => Category.fromJson(category))
          .toList();
      test('should user has an internet connection', () async {
        await categoriesRepo.getCategories();
        verify(netWorkInfo.isConnected());
        expect(await netWorkInfo.isConnected(), true);
      });

      test('shuold return list of [Category] if remote call success', () async {
        when(remoteSource.getCategories()).thenAnswer((_) async => categories);
        final result = await categoriesRepo.getCategories();
        expect(result, Right(categories));
      });

      test(
          'shuold return [UnknownFailure] if remote call throws [UnknownException]',
          () async {
        when(remoteSource.getCategories()).thenThrow(UnknownException());
        final result = await categoriesRepo.getCategories();
        expect(result, Left(UnknownFailure()));
      });
    });

    group('getCategoryById', () {
      final category =
          Category.fromJson(json.decode(fixture('category.json')));

      test('should user has an internet connection', () async {
        await categoriesRepo.getCategoryById(null);
        verify(netWorkInfo.isConnected());
        expect(await netWorkInfo.isConnected(), true);
      });

      test('shuold return list of [Category] if remote call success', () async {
        when(remoteSource.getCategoryById(null))
            .thenAnswer((_) async => category);
        final result = await categoriesRepo.getCategoryById(null);
        expect(result, Right(category));
      });

      test(
          'shuold return [ItemNotFoundFailure] if remote call throws [ItemNotFoundException]',
          () async {
        when(remoteSource.getCategoryById(null))
            .thenThrow(ItemNotFoundException());
        final result = await categoriesRepo.getCategoryById(null);
        expect(result, Left(ItemNotFoundFailure()));
      });

      test(
          'shuold return [UnknownFailure] if remote call throws [UnknownException]',
          () async {
        when(remoteSource.getCategoryById(null)).thenThrow(UnknownException());
        final result = await categoriesRepo.getCategoryById(null);
        expect(result, Left(UnknownFailure()));
      });
    });
  });

  group('device is offline', () {
    setUp(() {
      when(netWorkInfo.isConnected()).thenAnswer((_) async => false);
    });

    group('getCategories', () {
      test('should return false if user has no internet connection', () async {
        await categoriesRepo.getCategories();
        expect(await netWorkInfo.isConnected(), false);
      });
      test('should return [NoInternetFailure] is user has no connection',
          () async {
        final result = await categoriesRepo.getCategories();
        expect(result, Left(NoInternetFailure()));
      });
    });

    group('getCategoryById', () {
      test('should return false if user has no internet connection', () async {
        await categoriesRepo.getCategoryById(null);
        expect(await netWorkInfo.isConnected(), false);
      });
      test('should return [NoInternetFailure] is user has no connection',
          () async {
        final result = await categoriesRepo.getCategoryById(null);
        expect(result, Left(NoInternetFailure()));
      });
    });
  });
}
