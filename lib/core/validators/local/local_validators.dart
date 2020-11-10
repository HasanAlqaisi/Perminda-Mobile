import 'package:perminda/core/constants/constants.dart';

class LocalValidators {
  static String emailValidation(String email) {
    if (email.trim().isEmpty) return enterEmailMessage;
    if (!email.contains('@')) return enterValidEmailMessage;
    return null;
  }

  static String passwordValidation(String password) {
    if (password.trim().isEmpty) return enterPasswordMessage;
    return null;
  }

  static String usernameValidation(String username) {
    if (username.trim().isEmpty) return enterUsernameMessage;
    if (username.contains(' ')) return spacesInUsernameMessage;
    return null;
  }
}
