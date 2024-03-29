import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:perminda/core/errors/exception.dart';
import 'package:perminda/core/errors/failure.dart';
import 'package:perminda/core/network/network_info.dart';
import 'package:perminda/data/data_sources/cart_items/cart_items_local_source.dart';
import 'package:perminda/data/data_sources/cart_items/cart_items_remote_source.dart';
import 'package:perminda/data/db/models/cart_item/cart_item_table.dart';
import 'package:perminda/data/remote_models/cart_items/cart_items.dart';
import 'package:perminda/data/remote_models/cart_items/results.dart';
import 'package:perminda/data/repos/cart_items/cart_items_repo_impl.dart';

import '../../../fixtures/fixture_reader.dart';

class MockNetworkInfo extends Mock implements NetWorkInfo {}

class MockRemoteSource extends Mock implements CartItemsRemoteSource {}

class MockLocalSource extends Mock implements CartItemsLocalSource {}

void main() {
  MockNetworkInfo netWorkInfo;
  MockRemoteSource remoteSource;
  CartItemsLocalSource localSource;
  CartItemsRepoImpl repo;

  final cartItem =
      CartItemsResult.fromJson(json.decode(fixture('cart_item.json')));

  final cartItems = CartItems.fromJson(json.decode(fixture('cart_items.json')));

  setUp(() {
    netWorkInfo = MockNetworkInfo();
    remoteSource = MockRemoteSource();
    localSource = MockLocalSource();
    repo = CartItemsRepoImpl(
      netWorkInfo: netWorkInfo,
      remoteSource: remoteSource,
      localSource: localSource,
    );
  });

  group('device is online', () {
    setUp(() {
      when(netWorkInfo.isConnected()).thenAnswer((_) async => true);
    });

    group('addCartItem', () {
      setUp(() {
        when(remoteSource.addCartItem(null, null))
            .thenAnswer((_) async => cartItem);
      });

      test('should user has an internet connection', () async {
        await repo.addCartItem(null, null);
        verify(netWorkInfo.isConnected());
        expect(await netWorkInfo.isConnected(), true);
      });

      test('should return [CartItemsResult] when remote call is success',
          () async {
        final result = await repo.addCartItem(null, null);

        expect(result, Right(cartItem));
      });

      test('should cache [CartItemsResult] in the databasee', () async {
        when(localSource
                .insertCartItems(CartItemTable.fromCartItemsResult([cartItem])))
            .thenAnswer((_) async => null);

        await repo.addCartItem(null, null);

        verify(localSource.insertCartItems(any));
      });

      test(
          'shuold return [UnauthorizedTokenFailure] if remote call throws [UnauthorizedTokenException]',
          () async {
        when(remoteSource.addCartItem(null, null))
            .thenThrow(UnauthorizedTokenException());

        final result = await repo.addCartItem(null, null);

        expect(result, Left(UnauthorizedTokenFailure()));
      });

      test(
          'shuold return [CartItemsFieldsFailure] if remote call throws [FieldsException]',
          () async {
        final cartItemsFailure =
            CartItemsFieldsFailure(product: ['not correct']);

        when(remoteSource.addCartItem(null, null)).thenThrow(
            FieldsException(body: "{\"product\": [\"not correct\"]}"));

        final result = await repo.addCartItem(null, null);

        expect(result, Left(cartItemsFailure));
      });

      test(
          'shuold return [UnknownFailure] if remote call throws [UnknownException]',
          () async {
        when(remoteSource.addCartItem(null, null))
            .thenThrow(UnknownException());

        final result = await repo.addCartItem(null, null);

        expect(result, Left(UnknownFailure()));
      });
    });

    group('deleteCartItem', () {
      test('should user has an internet connection', () async {
        when(remoteSource.deleteCartItem(null)).thenAnswer((_) async => true);
        await repo.deleteCartItem(null);
        verify(netWorkInfo.isConnected());
        expect(await netWorkInfo.isConnected(), true);
      });

      test('should return [true] when remote call is success', () async {
        when(remoteSource.deleteCartItem(null)).thenAnswer((_) async => true);

        final result = await repo.deleteCartItem(null);

        expect(result, Right(true));
      });

      test('should delete [cartItem] from database', () async {
        when(remoteSource.deleteCartItem(null)).thenAnswer((_) async => true);

        when(localSource.deleteCartItemById(null))
            .thenAnswer((_) async => null);

        await repo.deleteCartItem(null);
        verify(localSource.deleteCartItemById(any));
      });

      test(
          'shuold return [UnauthorizedTokenFailure] if remote call throws [UnauthorizedTokenException]',
          () async {
        when(remoteSource.deleteCartItem(null))
            .thenThrow(UnauthorizedTokenException());

        final result = await repo.deleteCartItem(null);

        expect(result, Left(UnauthorizedTokenFailure()));
      });

      test(
          'shuold return [ItemNotFoundFailure] if remote call throws [ItemNotFoundException]',
          () async {
        when(remoteSource.deleteCartItem(null))
            .thenThrow(ItemNotFoundException());

        final result = await repo.deleteCartItem(null);

        expect(result, Left(ItemNotFoundFailure()));
      });

      test(
          'shuold return [UnknownFailure] if remote call throws [UnknownException]',
          () async {
        when(remoteSource.deleteCartItem(null)).thenThrow(UnknownException());

        final result = await repo.deleteCartItem(null);

        expect(result, Left(UnknownFailure()));
      });
    });

    group('editCartItem', () {
      setUp(() {
        when(remoteSource.editCartItem(null, null, null))
            .thenAnswer((_) async => cartItem);
      });

      test('should user has an internet connection', () async {
        await repo.editCartItem(null, null, null);
        verify(netWorkInfo.isConnected());
        expect(await netWorkInfo.isConnected(), true);
      });

      test('should return [CartItemsResult] when remote call is success',
          () async {
        final result = await repo.editCartItem(null, null, null);

        expect(result, Right(cartItem));
      });

      test('should cache [cartItem] in the databasee', () async {
        when(localSource
                .insertCartItems(CartItemTable.fromCartItemsResult([cartItem])))
            .thenAnswer((_) async => null);

        await repo.editCartItem(null, null, null);

        verify(localSource.insertCartItems(any));
      });

      test(
          'shuold return [UnauthorizedTokenFailure] if remote call throws [UnauthorizedTokenException]',
          () async {
        when(remoteSource.editCartItem(null, null, null))
            .thenThrow(UnauthorizedTokenException());

        final result = await repo.editCartItem(null, null, null);

        expect(result, Left(UnauthorizedTokenFailure()));
      });

      test(
          'shuold return [CartItemsFieldsFailure] if remote call throws [FieldsException]',
          () async {
        final cartItemsFailure =
            CartItemsFieldsFailure(product: ['not correct']);

        when(remoteSource.editCartItem(null, null, null)).thenThrow(
            FieldsException(body: "{\"product\": [\"not correct\"]}"));

        final result = await repo.editCartItem(null, null, null);

        expect(result, Left(cartItemsFailure));
      });

      test(
          'shuold return [ItemNotFoundFailure] if remote call throws [ItemNotFoundException]',
          () async {
        when(remoteSource.editCartItem(null, null, null))
            .thenThrow(ItemNotFoundException());

        final result = await repo.editCartItem(null, null, null);

        expect(result, Left(ItemNotFoundFailure()));
      });

      test(
          'shuold return [UnknownFailure] if remote call throws [UnknownException]',
          () async {
        when(remoteSource.addCartItem(null, null))
            .thenThrow(UnknownException());

        final result = await repo.addCartItem(null, null);

        expect(result, Left(UnknownFailure()));
      });
    });

    group('getCartItems', () {
      test('should user has an internet connection', () async {
        when(remoteSource.getCartItems(repo.offset))
            .thenAnswer((_) async => cartItems);

        await repo.getCartItems();

        verify(netWorkInfo.isConnected());
        expect(await netWorkInfo.isConnected(), true);
      });

      test('should cache the offset', () async {
        when(remoteSource.getCartItems(repo.offset))
            .thenAnswer((_) async => cartItems);

        await repo.getCartItems();

        expect(repo.offset, 400);
      });

      test('should return [CartItems] when remote call is success', () async {
        when(remoteSource.getCartItems(repo.offset))
            .thenAnswer((_) async => cartItems);

        final result = await repo.getCartItems();

        expect(result, Right(cartItems));
      });

      test('should cache [CartItems] in the databasee', () async {
        when(remoteSource.getCartItems(repo.offset))
            .thenAnswer((_) async => cartItems);

        when(localSource.insertCartItems(
                CartItemTable.fromCartItemsResult(cartItems.results)))
            .thenAnswer((_) async => null);

        await repo.getCartItems();

        verify(localSource.insertCartItems(any));
      });

      test(
          'shuold return [UnauthorizedTokenFailure] if remote call throws [UnauthorizedTokenException]',
          () async {
        when(remoteSource.getCartItems(repo.offset))
            .thenThrow(UnauthorizedTokenException());

        final result = await repo.getCartItems();

        expect(result, Left(UnauthorizedTokenFailure()));
      });

      test(
          'shuold return [UnknownFailure] if remote call throws [UnknownException]',
          () async {
        when(remoteSource.getCartItems(repo.offset))
            .thenThrow(UnknownException());

        final result = await repo.getCartItems();

        expect(result, Left(UnknownFailure()));
      });
    });
  });

  group('device is offline', () {
    setUp(() {
      when(netWorkInfo.isConnected()).thenAnswer((_) async => false);
    });

    group('addCartItem', () {
      test('should return false if user has no internet connection', () async {
        await repo.addCartItem(null, null);
        verify(netWorkInfo.isConnected());
        expect(await netWorkInfo.isConnected(), false);
      });

      test(
          'should return [NoInternetFailure] if user has no internet connection',
          () async {
        final result = await repo.addCartItem(null, null);

        expect(result, Left(NoInternetFailure()));
      });
    });

    group('deleteCartItem', () {
      test('should return false if user has no internet connection', () async {
        await repo.deleteCartItem(null);
        verify(netWorkInfo.isConnected());
        expect(await netWorkInfo.isConnected(), false);
      });

      test(
          'should return [NoInternetFailure] if user has no internet connection',
          () async {
        final result = await repo.deleteCartItem(null);

        expect(result, Left(NoInternetFailure()));
      });
    });

    group('editCartItem', () {
      test('should return false if user has no internet connection', () async {
        await repo.editCartItem(null, null, null);
        verify(netWorkInfo.isConnected());
        expect(await netWorkInfo.isConnected(), false);
      });

      test(
          'should return [NoInternetFailure] if user has no internet connection',
          () async {
        final result = await repo.editCartItem(null, null, null);

        expect(result, Left(NoInternetFailure()));
      });
    });

    group('getCartItems', () {
      test('should return false if user has no internet connection', () async {
        await repo.getCartItems();
        verify(netWorkInfo.isConnected());
        expect(await netWorkInfo.isConnected(), false);
      });

      test(
          'should return [NoInternetFailure] if user has no internet connection',
          () async {
        final result = await repo.getCartItems();

        expect(result, Left(NoInternetFailure()));
      });
    });
  });
}
