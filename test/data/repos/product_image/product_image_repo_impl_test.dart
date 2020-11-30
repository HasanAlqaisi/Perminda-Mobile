import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:perminda/core/errors/exception.dart';
import 'package:perminda/core/errors/failure.dart';
import 'package:perminda/core/network/network_info.dart';
import 'package:perminda/data/data_sources/product_image/local_source.dart';
import 'package:perminda/data/data_sources/product_image/remote_source.dart';
import 'package:perminda/data/db/models/product_image/product_image_table.dart';
import 'package:perminda/data/remote_models/product_images/product_images.dart';
import 'package:perminda/data/remote_models/product_images/results.dart';
import 'package:perminda/data/repos/product_image/product_image_repo_impl.dart';

import '../../../fixtures/fixture_reader.dart';

class MockNetworkInfo extends Mock implements NetWorkInfo {}

class MockRemoteSource extends Mock implements ProductImageRemoteSource {}

class MockLocalSource extends Mock implements ProductImageLocalSource {}

void main() {
  MockNetworkInfo netWorkInfo;
  MockRemoteSource remoteSource;
  MockLocalSource localSource;
  ProductImageRepoImpl repo;

  setUp(() {
    netWorkInfo = MockNetworkInfo();
    remoteSource = MockRemoteSource();
    localSource = MockLocalSource();
    repo = ProductImageRepoImpl(
      netWorkInfo: netWorkInfo,
      remoteSource: remoteSource,
      localSource: localSource,
    );
  });

  group('device is online', () {
    setUp(() {
      when(netWorkInfo.isConnected()).thenAnswer((_) async => true);
    });

    final productImages =
        ProductImages.fromJson(json.decode(fixture('product_images.json')));

    final productImage =
        ImagesResult.fromJson(json.decode(fixture('product_image.json')));

    group('addProductImage', () {
      test('should user has an internet connection', () async {
        when(remoteSource.addProductImage(null, null, null))
            .thenAnswer((_) async => productImage);
        await repo.addProductImage(null, null, null);
        verify(netWorkInfo.isConnected());
        expect(await netWorkInfo.isConnected(), true);
      });

      test('should return [productImage] if remote call is success', () async {
        when(remoteSource.addProductImage(null, null, null))
            .thenAnswer((_) async => productImage);

        final result = await repo.addProductImage(null, null, null);

        expect(result, Right(productImage));
      });

      test('should cache [productImage] in the databasee', () async {
        when(remoteSource.addProductImage(null, null, null))
            .thenAnswer((_) async => productImage);

        when(localSource.insertProductImages(
                ProductImageTable.fromImagesResult([productImage])))
            .thenAnswer((_) async => null);

        await repo.addProductImage(null, null, null);

        verify(localSource.insertProductImages(any));
      });

      test(
          'shuold return [UnauthorizedTokenFailure] if remote call throws [UnauthorizedTokenException]',
          () async {
        when(remoteSource.addProductImage(null, null, null))
            .thenThrow(UnauthorizedTokenException());
        final result = await repo.addProductImage(null, null, null);
        expect(result, Left(UnauthorizedTokenFailure()));
      });

      test(
          'shuold return [NotAllowedPermissionFailure] if remote call throws [NotAllowedPermissionException]',
          () async {
        when(remoteSource.addProductImage(null, null, null))
            .thenThrow(NotAllowedPermissionException());
        final result = await repo.addProductImage(null, null, null);
        expect(result, Left(NotAllowedPermissionFailure()));
      });

      test(
          'shuold return [ProductImageFieldsFailure] if remote call throws [FieldsException]',
          () async {
        final producImageFailure =
            ProductImageFieldsFailure(product: ['not correct']);

        when(remoteSource.addProductImage(null, null, null)).thenThrow(
            FieldsException(body: "{\"product\": [\"not correct\"]}"));

        final result = await repo.addProductImage(null, null, null);

        expect(result, Left(producImageFailure));
      });

      test(
          'shuold return [UnknownFailure] if remote call throws [UnknownException]',
          () async {
        when(remoteSource.addProductImage(null, null, null))
            .thenThrow(UnknownException());
        final result = await repo.addProductImage(null, null, null);
        expect(result, Left(UnknownFailure()));
      });
    });

    group('editProductImage', () {
      test('should user has an internet connection', () async {
        when(remoteSource.editProductImage(null, null, null, null))
            .thenAnswer((_) async => productImage);

        await repo.editProductImage(null, null, null, null);
        verify(netWorkInfo.isConnected());
        expect(await netWorkInfo.isConnected(), true);
      });

      test('should return [productImage] if remote call is success', () async {
        when(remoteSource.editProductImage(null, null, null, null))
            .thenAnswer((_) async => productImage);

        final result = await repo.editProductImage(null, null, null, null);

        expect(result, Right(productImage));
      });

      test('should cache [productImage] in the databasee', () async {
        when(remoteSource.editProductImage(null, null, null, null))
            .thenAnswer((_) async => productImage);

        when(localSource.insertProductImages(
                ProductImageTable.fromImagesResult([productImage])))
            .thenAnswer((_) async => null);

        await repo.editProductImage(null, null, null, null);

        verify(localSource.insertProductImages(any));
      });

      test(
          'shuold return [UnauthorizedTokenFailure] if remote call throws [UnauthorizedTokenException]',
          () async {
        when(remoteSource.editProductImage(null, null, null, null))
            .thenThrow(UnauthorizedTokenException());
        final result = await repo.editProductImage(null, null, null, null);
        expect(result, Left(UnauthorizedTokenFailure()));
      });

      test(
          'shuold return [NotAllowedPermissionFailure] if remote call throws [NotAllowedPermissionException]',
          () async {
        when(remoteSource.editProductImage(null, null, null, null))
            .thenThrow(NotAllowedPermissionException());
        final result = await repo.editProductImage(null, null, null, null);
        expect(result, Left(NotAllowedPermissionFailure()));
      });

      test(
          'shuold return [ProductImageFieldsFailure] if remote call throws [FieldsException]',
          () async {
        final producImageFailure =
            ProductImageFieldsFailure(product: ['not correct']);

        when(remoteSource.editProductImage(null, null, null, null)).thenThrow(
            FieldsException(body: "{\"product\": [\"not correct\"]}"));

        final result = await repo.editProductImage(null, null, null, null);

        expect(result, Left(producImageFailure));
      });

      test(
          'shuold return [UnknownFailure] if remote call throws [UnknownException]',
          () async {
        when(remoteSource.editProductImage(null, null, null, null))
            .thenThrow(UnknownException());
        final result = await repo.editProductImage(null, null, null, null);
        expect(result, Left(UnknownFailure()));
      });

      test(
          'shuold return [ItemNotFoundFailure] if remote call throws [ItemNotFoundException]',
          () async {
        when(remoteSource.editProductImage(null, null, null, null))
            .thenThrow(ItemNotFoundException());
        final result = await repo.editProductImage(null, null, null, null);
        expect(result, Left(ItemNotFoundFailure()));
      });
    });

    group('getProductImage', () {
      test('should user has an internet connection', () async {
        when(remoteSource.getProductImage(null))
            .thenAnswer((_) async => productImage);

        await repo.getProductImage(null);
        verify(netWorkInfo.isConnected());
        expect(await netWorkInfo.isConnected(), true);
      });

      test('should return [ProductImage] if remote call is success', () async {
        when(remoteSource.getProductImage(null))
            .thenAnswer((_) async => productImage);

        final result = await repo.getProductImage(null);

        expect(result, Right(productImage));
      });

      test('should cache [productImage] in the databasee', () async {
        when(remoteSource.getProductImage(null))
            .thenAnswer((_) async => productImage);

        when(localSource.insertProductImages(
                ProductImageTable.fromImagesResult([productImage])))
            .thenAnswer((_) async => null);

        await repo.getProductImage(null);

        verify(localSource.insertProductImages(any));
      });

      test(
          'shuold return [ItemNotFoundFailure] if remote call throws [ItemNotFoundException]',
          () async {
        when(remoteSource.getProductImage(null))
            .thenThrow(ItemNotFoundException());

        final result = await repo.getProductImage(null);

        expect(result, Left(ItemNotFoundFailure()));
      });

      test(
          'shuold return [UnknownFailure] if remote call throws [UnknownException]',
          () async {
        when(remoteSource.getProductImage(null)).thenThrow(UnknownException());

        final result = await repo.getProductImage(null);

        expect(result, Left(UnknownFailure()));
      });
    });

    group('deleteProductImage', () {
      test('should user has an internet connection', () async {
        await repo.deleteProductImage(null);
        verify(netWorkInfo.isConnected());
        expect(await netWorkInfo.isConnected(), true);
      });

      test('should return [true] if remote call is success', () async {
        when(remoteSource.deleteProductImage(null))
            .thenAnswer((_) async => true);

        final result = await repo.deleteProductImage(null);

        expect(result, Right(true));
      });

      test('should delete [productImage] from database', () async {
        when(remoteSource.deleteProductImage(null))
            .thenAnswer((_) async => true);

        when(localSource.deleteProductImageById(null))
            .thenAnswer((_) async => null);

        await repo.deleteProductImage(null);
        verify(localSource.deleteProductImageById(any));
      });

      test(
          'shuold return [UnauthorizedTokenFailure] if remote call throws [UnauthorizedTokenException]',
          () async {
        when(remoteSource.deleteProductImage(null))
            .thenThrow(UnauthorizedTokenException());
        final result = await repo.deleteProductImage(null);
        expect(result, Left(UnauthorizedTokenFailure()));
      });

      test(
          'shuold return [NotAllowedPermissionFailure] if remote call throws [NotAllowedPermissionException]',
          () async {
        when(remoteSource.deleteProductImage(null))
            .thenThrow(NotAllowedPermissionException());
        final result = await repo.deleteProductImage(null);
        expect(result, Left(NotAllowedPermissionFailure()));
      });

      test(
          'shuold return [ItemNotFoundFailure] if remote call throws [ItemNotFoundException]',
          () async {
        when(remoteSource.deleteProductImage(null))
            .thenThrow(ItemNotFoundException());

        final result = await repo.deleteProductImage(null);

        expect(result, Left(ItemNotFoundFailure()));
      });

      test(
          'shuold return [UnknownFailure] if remote call throws [UnknownException]',
          () async {
        when(remoteSource.deleteProductImage(null))
            .thenThrow(UnknownException());

        final result = await repo.deleteProductImage(null);

        expect(result, Left(UnknownFailure()));
      });

      test(
          'shuold return [ItemNotFoundFailure] if remote call throws [ItemNotFoundException]',
          () async {
        when(remoteSource.editProductImage(null, null, null, null))
            .thenThrow(ItemNotFoundException());
        final result = await repo.editProductImage(null, null, null, null);
        expect(result, Left(ItemNotFoundFailure()));
      });
    });

    group('getImagesOfProduct', () {
      test('should user has an internet connection', () async {
        when(remoteSource.getImagesOfProduct(null, repo.offset))
            .thenAnswer((_) async => productImages);

        await repo.getImagesOfProduct(null);
        verify(netWorkInfo.isConnected());
        expect(await netWorkInfo.isConnected(), true);
      });

      test('should return [ProductImages] if remote call is success', () async {
        when(remoteSource.getImagesOfProduct(null, repo.offset))
            .thenAnswer((_) async => productImages);

        final result = await repo.getImagesOfProduct(null);

        expect(result, Right(productImages));
      });

      test('should cache the offset', () async {
        when(remoteSource.getImagesOfProduct(null, repo.offset))
            .thenAnswer((_) async => productImages);

        await repo.getImagesOfProduct(null);

        expect(repo.offset, 400);
      });

      test('should cache list of [productImage] in the databasee', () async {
        when(remoteSource.getImagesOfProduct(null, repo.offset))
            .thenAnswer((_) async => productImages);

        when(localSource.insertProductImages(
                ProductImageTable.fromImagesResult(productImages.results)))
            .thenAnswer((_) async => null);

        await repo.getImagesOfProduct(null);

        verify(localSource.insertProductImages(any));
      });

      test(
          'shuold return [UnknownFailure] if remote call throws [UnknownException]',
          () async {
        when(remoteSource.getImagesOfProduct(null, repo.offset))
            .thenThrow(UnknownException());

        final result = await repo.getImagesOfProduct(null);

        expect(result, Left(UnknownFailure()));
      });
    });
  });

  group('device is offline', () {
    setUp(() {
      when(netWorkInfo.isConnected()).thenAnswer((_) async => false);
      group('addProductImage', () {
        test('should return false if user has no internet connection',
            () async {
          await repo.addProductImage(null, null, null);
          verify(netWorkInfo.isConnected());
          expect(await netWorkInfo.isConnected(), false);
        });

        test(
            'should return [NoInternetFailure] if user has no internet connection',
            () async {
          final result = await repo.addProductImage(null, null, null);

          expect(result, Left(NoInternetFailure()));
        });
      });

      group('editProductImage', () {
        test('should return false if user has no internet connection',
            () async {
          await repo.editProductImage(null, null, null, null);
          verify(netWorkInfo.isConnected());
          expect(await netWorkInfo.isConnected(), false);
        });

        test(
            'should return [NoInternetFailure] if user has no internet connection',
            () async {
          final result = await repo.editProductImage(null, null, null, null);

          expect(result, Left(NoInternetFailure()));
        });
      });

      group('deleteProductImage', () {
        test('should return false if user has no internet connection',
            () async {
          await repo.deleteProductImage(null);
          verify(netWorkInfo.isConnected());
          expect(await netWorkInfo.isConnected(), false);
        });

        test(
            'should return [NoInternetFailure] if user has no internet connection',
            () async {
          final result = await repo.deleteProductImage(null);

          expect(result, Left(NoInternetFailure()));
        });
      });
      group('getProductImage', () {
        test('should return false if user has no internet connection',
            () async {
          await repo.getProductImage(null);
          verify(netWorkInfo.isConnected());
          expect(await netWorkInfo.isConnected(), false);
        });

        test(
            'should return [NoInternetFailure] if user has no internet connection',
            () async {
          final result = await repo.getProductImage(null);

          expect(result, Left(NoInternetFailure()));
        });
      });

      group('getImagesOfProduct', () {
        test('should return false if user has no internet connection',
            () async {
          await repo.getImagesOfProduct(null);
          verify(netWorkInfo.isConnected());
          expect(await netWorkInfo.isConnected(), false);
        });

        test(
            'should return [NoInternetFailure] if user has no internet connection',
            () async {
          final result = await repo.getImagesOfProduct(null);

          expect(result, Left(NoInternetFailure()));
        });
      });
    });
  });
}
