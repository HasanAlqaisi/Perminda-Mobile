import 'package:flutter_test/flutter_test.dart';
import 'package:perminda/core/constants/constants.dart';
import 'package:perminda/core/validators/local/local_validators.dart';

void main() {
  group('LocalValidators', () {
    group('emailValidation', () {
      test('should return [$requireFieldMessage] when email is empty', () {
        final result = LocalValidators.emailValidation('');

        expect(result, equals(requireFieldMessage));
      });

      test(
          'should return [$enterValidEmailMessage] whenemail doesn\'t contain \'@\'',
          () {
        final result = LocalValidators.emailValidation('hasangmail.com');

        expect(result, equals(enterValidEmailMessage));
      });

      test('should return null when everything is OK', () {
        final result = LocalValidators.emailValidation('hasan@gmail.com');

        expect(result, equals(null));
      });
    });

    group('generalValidation', () {
      test('should return [$requireFieldMessage] when password is empty', () {
        final result = LocalValidators.generalValidation('');

        expect(result, equals(requireFieldMessage));
      });

      test('should return null when everything is OK', () {
        final result = LocalValidators.generalValidation('01010101');

        expect(result, equals(null));
      });
    });
  });
}
