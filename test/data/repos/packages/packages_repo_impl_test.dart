import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:perminda/core/errors/exception.dart';
import 'package:perminda/core/errors/failure.dart';
import 'package:perminda/core/network/network_info.dart';
import 'package:perminda/data/data_sources/packages/packages_local_source.dart';
import 'package:perminda/data/db/models/package/package_table.dart';
import 'package:perminda/data/repos/packages/packages_repo_impl.dart';
import 'package:perminda/data/data_sources/packages/packages_remote_source.dart';
import 'package:perminda/data/remote_models/packages/packages.dart';

import '../../../fixtures/fixture_reader.dart';

class MockNetworkInfo extends Mock implements NetWorkInfo {}

class MockRemoteSource extends Mock implements PackagesRemoteSource {}

class MockLocalSource extends Mock implements PackagesLocalSource {}

void main() {
  MockNetworkInfo netWorkInfo;
  MockRemoteSource remoteSource;
  MockLocalSource localSource;
  PackagesRepoImpl repo;

  final packages = Packages.fromJson(json.decode(fixture('packages.json')));

  setUp(() {
    netWorkInfo = MockNetworkInfo();
    remoteSource = MockRemoteSource();
    localSource = MockLocalSource();
    repo = PackagesRepoImpl(
      netWorkInfo: netWorkInfo,
      remoteSource: remoteSource,
      localSource: localSource,
    );
  });

  group('device is online', () {
    setUp(() {
      when(netWorkInfo.isConnected()).thenAnswer((_) async => true);
    });

    group('getPackages', () {
      test('should user has an internet connection', () async {
        when(remoteSource.getPackages(repo.offset))
            .thenAnswer((_) async => packages);

        await repo.getPackages();
        verify(netWorkInfo.isConnected());
        expect(await netWorkInfo.isConnected(), true);
      });

      test('should return [Packages] if remote call is success', () async {
        when(remoteSource.getPackages(repo.offset))
            .thenAnswer((_) async => packages);

        final result = await repo.getPackages();

        expect(result, Right(packages));
      });

      test('should delete old packages from database', () async {
        when(remoteSource.getPackages(repo.offset))
            .thenAnswer((_) async => packages);
            
        when(localSource.deletePackages()).thenAnswer((_) async => null);

        await repo.getPackages();

        verify(localSource.deletePackages());
      });

      test('should cache the offset', () async {
        when(remoteSource.getPackages(repo.offset))
            .thenAnswer((_) async => packages);

        await repo.getPackages();

        expect(repo.offset, 400);
      });

      test('should cache [Packages] in the databasee', () async {
        when(remoteSource.getPackages(repo.offset))
            .thenAnswer((_) async => packages);

        when(localSource.insertPackages(
                PackageTable.fromPackagesResult(packages.results)))
            .thenAnswer((_) async => null);

        await repo.getPackages();

        verify(localSource.insertPackages(any));
      });

      test(
          'shuold return [UnknownFailure] if remote call throws [UnknownException]',
          () async {
        when(remoteSource.getPackages(repo.offset))
            .thenThrow(UnknownException());
        final result = await repo.getPackages();
        expect(result, Left(UnknownFailure()));
      });
    });
  });

  group('device is offline', () {
    setUp(() {
      when(netWorkInfo.isConnected()).thenAnswer((_) async => false);
    });

    group('addOrder', () {
      test('should return false if user has no internet connection', () async {
        await repo.getPackages();
        verify(netWorkInfo.isConnected());
        expect(await netWorkInfo.isConnected(), false);
      });

      test(
          'should return [NoInternetFailure] if user has no internet connection',
          () async {
        final result = await repo.getPackages();

        expect(result, Left(NoInternetFailure()));
      });
    });
  });
}
