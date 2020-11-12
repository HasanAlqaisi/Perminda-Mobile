import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:perminda/core/errors/failure.dart';

import '../../fixtures/fixture_reader.dart';

void main() {
  final body = json.decode(fixture('registration_fields_error.json'));

  // final fieldsFailure = FieldsFailure(
  //   email: ['This field is required.'],
  //   userName: ['A user with this username is already exists.'],
  // );

  test('should convert FieldsException to FieldsFailure in a correct way', () {
    final result = FieldsFailure.fromFieldsException(body);
    expect(result, isInstanceOf<FieldsFailure>());
  });
}
