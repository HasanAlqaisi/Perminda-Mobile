import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:perminda/core/errors/exception.dart';
import 'package:perminda/core/errors/failure.dart';
import 'package:perminda/core/network/network_info.dart';
import 'package:perminda/data/data_sources/orders/orders_remote_source.dart';
import 'package:perminda/data/remote_models/orders/orders.dart';
import 'package:perminda/data/remote_models/orders/results.dart';
import 'package:perminda/data/repos/orders/orders_repo_impl.dart';

import '../../../fixtures/fixture_reader.dart';

class MockNetworkInfo extends Mock implements NetWorkInfo {}

class MockRemoteSource extends Mock implements OrdersRemoteSource {}

void main() {
  MockNetworkInfo netWorkInfo;
  MockRemoteSource remoteSource;
  OrdersRepoImpl repo;

  final orders = Orders.fromJson(json.decode(fixture('orders.json')));

  final order = OrdersResult.fromJson(json.decode(fixture('order.json')));

  setUp(() {
    netWorkInfo = MockNetworkInfo();
    remoteSource = MockRemoteSource();
    repo = OrdersRepoImpl(netWorkInfo: netWorkInfo, remoteSource: remoteSource);
  });

  group('device is online', () {
    setUp(() {
      when(netWorkInfo.isConnected()).thenAnswer((_) async => true);
    });

    group('addOrder', () {
      test('should user has an internet connection', () async {
        await repo.addOrder(null, null);
        verify(netWorkInfo.isConnected());
        expect(await netWorkInfo.isConnected(), true);
      });

      test('should return [OrdersReult] if remote call is success', () async {
        when(remoteSource.addOrder(null, null)).thenAnswer((_) async => order);

        final result = await repo.addOrder(null, null);

        expect(result, Right(order));
      });

      test(
          'shuold return [OrdersFieldsFailure] if remote call throws [FieldsException]',
          () async {
        when(remoteSource.addOrder(null, null)).thenThrow(
            FieldsException(body: fixture('orders_fields_error.json')));
        final result = await repo.addOrder(null, null);
        expect(
            result,
            Left(OrdersFieldsFailure.fromFieldsException(json.decode(
              fixture('orders_fields_error.json'),
            ))));
      });

      test(
          'shuold return [UnauthorizedTokenFailure] if remote call throws [UnauthorizedTokenException]',
          () async {
        when(remoteSource.addOrder(null, null))
            .thenThrow(UnauthorizedTokenException());
        final result = await repo.addOrder(null, null);
        expect(result, Left(UnauthorizedTokenFailure()));
      });

      test(
          'shuold return [UnknownFailure] if remote call throws [UnknownException]',
          () async {
        when(remoteSource.addOrder(null, null)).thenThrow(UnknownException());
        final result = await repo.addOrder(null, null);
        expect(result, Left(UnknownFailure()));
      });
    });

    group('editOrder', () {
      test('should user has an internet connection', () async {
        await repo.editOrder(null, null);
        verify(netWorkInfo.isConnected());
        expect(await netWorkInfo.isConnected(), true);
      });

      test('should return [OrdersReult] if remote call is success', () async {
        when(remoteSource.editOrder(null, null)).thenAnswer((_) async => order);

        final result = await repo.editOrder(null, null);

        expect(result, Right(order));
      });

      test(
          'shuold return [OrdersFieldsFailure] if remote call throws [FieldsException]',
          () async {
        when(remoteSource.editOrder(null, null)).thenThrow(
            FieldsException(body: fixture('orders_fields_error.json')));
        final result = await repo.editOrder(null, null);
        expect(
            result,
            Left(OrdersFieldsFailure.fromFieldsException(json.decode(
              fixture('orders_fields_error.json'),
            ))));
      });

      test(
          'shuold return [UnauthorizedTokenFailure] if remote call throws [UnauthorizedTokenException]',
          () async {
        when(remoteSource.editOrder(null, null))
            .thenThrow(UnauthorizedTokenException());
        final result = await repo.editOrder(null, null);
        expect(result, Left(UnauthorizedTokenFailure()));
      });

      test(
          'shuold return [ItemNotFoundFailure] if remote call throws [ItemNotFoundException]',
          () async {
        when(remoteSource.editOrder(null, null))
            .thenThrow(ItemNotFoundException());
        final result = await repo.editOrder(null, null);
        expect(result, Left(ItemNotFoundFailure()));
      });

      test(
          'shuold return [UnknownFailure] if remote call throws [UnknownException]',
          () async {
        when(remoteSource.editOrder(null, null)).thenThrow(UnknownException());
        final result = await repo.editOrder(null, null);
        expect(result, Left(UnknownFailure()));
      });
    });

    group('getOrders', () {
      test('should user has an internet connection', () async {
        when(remoteSource.getOrders(repo.offset))
            .thenAnswer((_) async => orders);

        await repo.getOrders();
        verify(netWorkInfo.isConnected());
        expect(await netWorkInfo.isConnected(), true);
      });

      test('should return [Orders] if remote call is success', () async {
        when(remoteSource.getOrders(repo.offset))
            .thenAnswer((_) async => orders);

        final result = await repo.getOrders();

        expect(result, Right(orders));
      });

      test(
          'shuold return [UnauthorizedTokenFailure] if remote call throws [UnauthorizedTokenException]',
          () async {
        when(remoteSource.getOrders(repo.offset))
            .thenThrow(UnauthorizedTokenException());
        final result = await repo.getOrders();
        expect(result, Left(UnauthorizedTokenFailure()));
      });

      test(
          'shuold return [UnknownFailure] if remote call throws [UnknownException]',
          () async {
        when(remoteSource.getOrders(repo.offset)).thenThrow(UnknownException());
        final result = await repo.getOrders();
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
        await repo.addOrder(null, null);
        verify(netWorkInfo.isConnected());
        expect(await netWorkInfo.isConnected(), false);
      });

      test(
          'should return [NoInternetFailure] if user has no internet connection',
          () async {
        final result = await repo.addOrder(null, null);

        expect(result, Left(NoInternetFailure()));
      });
    });

    group('editOrder', () {
      test('should return false if user has no internet connection', () async {
        await repo.editOrder(null, null);
        verify(netWorkInfo.isConnected());
        expect(await netWorkInfo.isConnected(), false);
      });

      test(
          'should return [NoInternetFailure] if user has no internet connection',
          () async {
        final result = await repo.editOrder(null, null);

        expect(result, Left(NoInternetFailure()));
      });
    });

    group('getOrders', () {
      test('should return false if user has no internet connection', () async {
        await repo.getOrders();
        verify(netWorkInfo.isConnected());
        expect(await netWorkInfo.isConnected(), false);
      });

      test(
          'should return [NoInternetFailure] if user has no internet connection',
          () async {
        final result = await repo.getOrders();

        expect(result, Left(NoInternetFailure()));
      });
    });
  });
}
