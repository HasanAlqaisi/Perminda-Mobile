import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:perminda/core/errors/failure.dart';

import '../../fixtures/fixture_reader.dart';

void main() {
  final nonFieldsBody = json.decode(fixture('non_fields.json'));
  final nonFieldsFailure = NonFieldsFailure(
    errors: ['Unable to log in with provided credentials.'],
  );

  test('should convert FieldsException to UserFieldsFailure in a correct way',
      () {
    final registerFieldsBody =
        json.decode(fixture('registration_fields_error.json'));

    final userFieldsFailure = UserFieldsFailure(
      email: ['This field is required.'],
      userName: ['A user with this username is already exists.'],
    );

    final result = UserFieldsFailure.fromFieldsException(registerFieldsBody);
    expect(result, userFieldsFailure);
  });

  test('should convert FieldsException to ReviewFieldsFailure in a correct way',
      () {
    final reviewFieldsBody = json.decode(fixture('review_fields_error.json'));
    final reviewFailure = ReviewFieldsFailure(rate: ['not in range']);

    final result = ReviewFieldsFailure.fromFieldsException(reviewFieldsBody);
    expect(result, reviewFailure);
  });

  test(
      'should convert FieldsException to ProductImageFieldsFailure in a correct way',
      () {
    final productImageFieldsBody =
        json.decode(fixture('product_image_fields_error.json'));

    final producImageFailure =
        ProductImageFieldsFailure(product: ['not correct']);

    final result =
        ProductImageFieldsFailure.fromFieldsException(productImageFieldsBody);

    expect(result, producImageFailure);
  });

  test(
      'should convert FieldsException to CartItemsFieldsFailure in a correct way',
      () {
    final cartItemsFieldsBody =
        json.decode(fixture('cart_items_fields_error.json'));

    final cartItemsFailure = CartItemsFieldsFailure(product: ['not correct']);

    final result =
        CartItemsFieldsFailure.fromFieldsException(cartItemsFieldsBody);

    expect(result, cartItemsFailure);
  });

  test(
      'should convert FieldsException to CartItemsFieldsFailure in a correct way',
      () {
    final favouritesFieldsBody =
        json.decode(fixture('favourite_fields_error.json'));

    final favouritesFailure = FavouritesFieldsFailure(product: ['not correct']);

    final result =
        FavouritesFieldsFailure.fromFieldsException(favouritesFieldsBody);

    expect(result, favouritesFailure);
  });

  test('should convert NonFieldsException to NonFieldsFailure in a correct way',
      () {
    final result = NonFieldsFailure.fromNonFieldsException(nonFieldsBody);
    expect(result, nonFieldsFailure);
  });
}
