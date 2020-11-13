import 'package:perminda/core/constants/constants.dart';

class LocalValidators {
  static String emailValidation(String email) {
    if (email.trim().isEmpty) return requireFieldMessage;
    if (!email.contains('@')) return enterValidEmailMessage;
    return null;
  }

  static String generalValidation(String string) {
    if (string.trim().isEmpty) return requireFieldMessage;
    if (string.contains(' ')) return spacesInFieldMessage;
    return null;
  }
}
