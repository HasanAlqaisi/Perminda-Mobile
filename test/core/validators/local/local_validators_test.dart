import 'package:flutter_test/flutter_test.dart';
import 'package:perminda/core/constants/constants.dart';
import 'package:perminda/core/validators/local/local_validators.dart';

void main() {
  group('LocalValidators', () {
    group('emailValidation', () {
      test('should return [$enterEmailMessage] when email is empty', () {
        final result = LocalValidators.emailValidation('');

        expect(result, equals(enterEmailMessage));
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

    group('passwordValidation', () {
      test('should return [$enterPasswordMessage] when password is empty', () {
        final result = LocalValidators.passwordValidation('');

        expect(result, equals(enterPasswordMessage));
      });

      test('should return null when everything is OK', () {
        final result = LocalValidators.passwordValidation('01010101');

        expect(result, equals(null));
      });
    });

    group('usernameValidation', () {
      test('should return [$enterUsernameMessage] when username is empty', () {
        final result = LocalValidators.generalValidation('');

        expect(result, equals(enterUsernameMessage));
      });

      test(
          'should return [$spacesInUsernameMessage] when username contains any spaces',
          () {
        final result = LocalValidators.generalValidation('ha sa n');

        expect(result, equals(spacesInUsernameMessage));
      });

      test('should return null when everything is OK', () {
        final result = LocalValidators.generalValidation('hasan');

        expect(result, equals(null));
      });
    });
  });
}
