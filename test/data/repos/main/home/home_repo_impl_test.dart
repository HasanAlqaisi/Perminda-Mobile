import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:perminda/core/errors/failure.dart';
import 'package:perminda/core/network/network_info.dart';
import 'package:perminda/data/remote_models/categories/categories.dart';
import 'package:perminda/data/remote_models/products/products.dart';
import 'package:perminda/data/repos/main/home/home_repo_impl.dart';
import 'package:perminda/data/remote_models/packages/packages.dart';

import 'package:perminda/domain/repos/brands_repo.dart';
import 'package:perminda/domain/repos/categories_repo.dart';
import 'package:perminda/domain/repos/packages_repo.dart';
import 'package:perminda/domain/repos/products_repo.dart';
import 'package:perminda/domain/repos/shops_repo.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockNetworkInfo extends Mock implements NetWorkInfo {}

class MochShopsRepo extends Mock implements ShopsRepo {}

class MockBrandsRepo extends Mock implements BrandsRepo {}

class MockCategoriesRepo extends Mock implements CategoriesRepo {}

class MockPackagesRepo extends Mock implements PackagesRepo {}

class MockProductsRepo extends Mock implements ProductsRepo {}

void main() {
  MockNetworkInfo netWorkInfo;
  MochShopsRepo shopsRepo;
  MockBrandsRepo brandsRepo;
  MockCategoriesRepo categoriesRepo;
  MockPackagesRepo packagesRepo;
  MockProductsRepo productsRepo;
  HomeRepoImpl repo;

  setUp(() {
    netWorkInfo = MockNetworkInfo();
    shopsRepo = MochShopsRepo();
    brandsRepo = MockBrandsRepo();
    categoriesRepo = MockCategoriesRepo();
    packagesRepo = MockPackagesRepo();
    productsRepo = MockProductsRepo();
    repo = HomeRepoImpl(
      netWorkInfo: netWorkInfo,
      shopsRepo: shopsRepo,
      brandsRepo: brandsRepo,
      categoriesRepo: categoriesRepo,
      packagesRepo: packagesRepo,
      productsRepo: productsRepo,
    );
  });

  group('device is online', () {
    setUp(() {
      when(netWorkInfo.isConnected()).thenAnswer((_) async => true);
    });

    group('triggerPackages', () {
      final packages = Packages.fromJson(json.decode(fixture('packages.json')));

      test('should user has an internet connection', () async {
        when(packagesRepo.getPackages())
            .thenAnswer((_) async => Right(packages));

        await repo.triggerPackages();
        verify(netWorkInfo.isConnected());
        expect(await netWorkInfo.isConnected(), true);
      });

      test('should get the packages', () async {
        when(packagesRepo.getPackages())
            .thenAnswer((_) async => Right(packages));

        await repo.triggerPackages();

        verify(packagesRepo.getPackages());
      });

      test('should return [failure] if there is one', () async {
        when(packagesRepo.getPackages())
            .thenAnswer((_) async => Left(UnknownFailure()));

        final result = await repo.triggerPackages();

        expect(result, UnknownFailure());
      });

      test('should return [null] if there is no failure', () async {
        when(packagesRepo.getPackages())
            .thenAnswer((_) async => Right(packages));

        final result = await repo.triggerPackages();

        expect(result, null);
      });
    });

    group('triggerCategories', () {
      final categories =
          Categories.fromJson(json.decode(fixture('categories.json')));

      test('should user has an internet connection', () async {
        when(categoriesRepo.getCategories())
            .thenAnswer((_) async => Right(categories));

        await repo.triggerCategories();
        verify(netWorkInfo.isConnected());
        expect(await netWorkInfo.isConnected(), true);
      });

      test('should get the categories', () async {
        when(categoriesRepo.getCategories())
            .thenAnswer((_) async => Right(categories));

        await repo.triggerCategories();

        verify(categoriesRepo.getCategories());
      });

      test('should return [failure] if there is one', () async {
        when(categoriesRepo.getCategories())
            .thenAnswer((_) async => Left(UnknownFailure()));

        final result = await repo.triggerCategories();

        expect(result, UnknownFailure());
      });

      test('should return [null] if there is no failure', () async {
        when(categoriesRepo.getCategories())
            .thenAnswer((_) async => Right(categories));

        final result = await repo.triggerCategories();

        expect(result, null);
      });
    });

    group('triggerProductsByCategory', () {
      final products = Products.fromJson(json.decode(fixture('products.json')));

      test('should user has an internet connection', () async {
        when(productsRepo.getProducts(null, null, null))
            .thenAnswer((_) async => Right(products.results));

        await repo.triggerProductsByCategory(null);
        verify(netWorkInfo.isConnected());
        expect(await netWorkInfo.isConnected(), true);
      });

      test('should get the products based on its category', () async {
        when(productsRepo.getProducts(null, null, null))
            .thenAnswer((_) async => Right(products.results));

        await repo.triggerProductsByCategory(null);

        verify(productsRepo.getProducts(null, null, null));
      });

      test('should return [failure] if there is one', () async {
        when(productsRepo.getProducts(null, null, null))
            .thenAnswer((_) async => Left(UnknownFailure()));

        final result = await repo.triggerProductsByCategory(null);

        expect(result, UnknownFailure());
      });

      test('should return [null] if there is no failure', () async {
        when(productsRepo.getProducts(null, null, null))
            .thenAnswer((_) async => Right(products.results));

        final result = await repo.triggerProductsByCategory(null);

        expect(result, null);
      });
    });
  });

  group('device is offline', () {
    setUp(() {
      when(netWorkInfo.isConnected()).thenAnswer((_) async => false);
    });

    group('triggerPackages', () {
      test('should return false if user has no internet connection', () async {
        await repo.triggerPackages();
        verify(netWorkInfo.isConnected());
        expect(await netWorkInfo.isConnected(), false);
      });

      test(
          'should return [NoInternetFailure] if user has no internet connection',
          () async {
        final result = await repo.triggerPackages();

        expect(result, NoInternetFailure());
      });
    });

    group('triggerProductsByCategory', () {
      test('should return false if user has no internet connection', () async {
        await repo.triggerProductsByCategory(null);
        verify(netWorkInfo.isConnected());
        expect(await netWorkInfo.isConnected(), false);
      });

      test(
          'should return [NoInternetFailure] if user has no internet connection',
          () async {
        final result = await repo.triggerProductsByCategory(null);

        expect(result, NoInternetFailure());
      });
    });

    group('triggerCategories', () {
      test('should return false if user has no internet connection', () async {
        await repo.triggerCategories();
        verify(netWorkInfo.isConnected());
        expect(await netWorkInfo.isConnected(), false);
      });

      test(
          'should return [NoInternetFailure] if user has no internet connection',
          () async {
        final result = await repo.triggerCategories();

        expect(result, NoInternetFailure());
      });
    });
  });
}
