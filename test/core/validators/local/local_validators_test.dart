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

    group('phoneHandledValidation', () {
      test('should return phone starts with [+] if user input like [7..]', () {
        final result = LocalValidators.phoneHandledValidation('7709393184');
        expect(result, '+7709393184');
      });

      test('should return phone starts with [+] and zero deleted if user input like [07..]', () {
        final result = LocalValidators.phoneHandledValidation('07709393184');
        expect(result, '+7709393184');
      });

      test('should return phone without zero if user input like [+07..]', () {
        final result = LocalValidators.phoneHandledValidation('+07709393184');
        expect(result, '+7709393184');
      });
    });
  });
}
