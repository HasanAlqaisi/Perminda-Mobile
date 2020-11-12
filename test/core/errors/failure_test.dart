import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:perminda/core/errors/failure.dart';

import '../../fixtures/fixture_reader.dart';

void main() {
  final fieldsBody = json.decode(fixture('registration_fields_error.json'));
  final nonFieldsBody = json.decode(fixture('non_fields.json'));

  final fieldsFailure = FieldsFailure(
    email: ['This field is required.'],
    userName: ['A user with this username is already exists.'],
  );

  final nonFieldsFailure = NonFieldsFailure(
    errors: ['Unable to log in with provided credentials.'],
  );

  test('should convert FieldsException to FieldsFailure in a correct way', () {
    final result = FieldsFailure.fromFieldsException(fieldsBody);
    expect(result, fieldsFailure);
  });

  test('should convert NonFieldsException to NonFieldsFailure in a correct way',
      () {
    final result = NonFieldsFailure.fromNonFieldsException(nonFieldsBody);
    expect(result, nonFieldsFailure);
  });
}
