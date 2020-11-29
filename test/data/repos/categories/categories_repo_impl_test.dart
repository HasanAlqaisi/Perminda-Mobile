import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:perminda/core/errors/exception.dart';
import 'package:perminda/core/errors/failure.dart';
import 'package:perminda/core/network/network_info.dart';
import 'package:perminda/data/data_sources/categories/local_source.dart';
import 'package:perminda/data/data_sources/categories/remote_soruce.dart';
import 'package:perminda/data/db/models/category/category_table.dart';
import 'package:perminda/data/remote_models/categories/categories.dart';
import 'package:perminda/data/remote_models/categories/results.dart';
import 'package:perminda/data/repos/categories/categories_repo_impl.dart';

import '../../../fixtures/fixture_reader.dart';
import '../shops/shops_repo_impl_test.dart';

class MockNetworkInfo extends Mock implements NetWorkInfo {}

class MockRemoteSource extends Mock implements CategoriesRemoteSource {}

class MockLocalSource extends Mock implements CategoriesLocalSource {}

void main() {
  MockNetWorkInfo netWorkInfo;
  MockRemoteSource remoteSource;
  MockLocalSource localSource;
  CategoriesRepoImpl categoriesRepo;

  setUp(() {
    netWorkInfo = MockNetWorkInfo();
    remoteSource = MockRemoteSource();
    localSource = MockLocalSource();
    categoriesRepo = CategoriesRepoImpl(
      netWorkInfo: netWorkInfo,
      remoteSource: remoteSource,
      localSource: localSource,
    );
  });

  group('device is online', () {
    setUp(() {
      when(netWorkInfo.isConnected()).thenAnswer((_) async => true);
    });

    group('getCategories', () {
      final categories =
          Categories.fromJson(json.decode(fixture('categories.json')));

      test('should user has an internet connection', () async {
        when(remoteSource.getCategories(categoriesRepo.offset))
            .thenAnswer((_) async => categories);

        await categoriesRepo.getCategories();

        verify(netWorkInfo.isConnected());
        expect(await netWorkInfo.isConnected(), true);
      });

      test('should cache the offset', () async {
        when(remoteSource.getCategories(categoriesRepo.offset))
            .thenAnswer((_) async => categories);

        await categoriesRepo.getCategories();

        expect(categoriesRepo.offset, 400);
      });

      test('shuold return list of [Category] if remote call success', () async {
        when(remoteSource.getCategories(categoriesRepo.offset))
            .thenAnswer((_) async => categories);
        final result = await categoriesRepo.getCategories();
        expect(result, Right(categories));
      });

      test('should cache list of [Category] in the databasee', () async {
        when(remoteSource.getCategories(categoriesRepo.offset))
            .thenAnswer((_) async => categories);

        when(localSource.insertCategories(
                CategoryTable.fromCategoriesResult(categories.results)))
            .thenAnswer((_) async => null);

        await categoriesRepo.getCategories();

        verify(localSource.insertCategories(any));
      });

      test(
          'shuold return [UnknownFailure] if remote call throws [UnknownException]',
          () async {
        when(remoteSource.getCategories(categoriesRepo.offset))
            .thenThrow(UnknownException());
        final result = await categoriesRepo.getCategories();
        expect(result, Left(UnknownFailure()));
      });
    });

    group('getCategoryById', () {
      final category =
          CategoriesResult.fromJson(json.decode(fixture('category.json')));

      setUp(() {
        when(remoteSource.getCategoryById(null))
            .thenAnswer((_) async => category);
      });

      test('should user has an internet connection', () async {
        await categoriesRepo.getCategoryById(null);
        verify(netWorkInfo.isConnected());
        expect(await netWorkInfo.isConnected(), true);
      });

      test('shuold return list of [Category] if remote call success', () async {
        final result = await categoriesRepo.getCategoryById(null);
        expect(result, Right(category));
      });

      test('should cache [Category] in the databasee', () async {
        when(localSource.insertCategories(
                CategoryTable.fromCategoriesResult([category])))
            .thenAnswer((_) async => null);

        await categoriesRepo.getCategoryById(null);

        verify(localSource.insertCategories(any));
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
