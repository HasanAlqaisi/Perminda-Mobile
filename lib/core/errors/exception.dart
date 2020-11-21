class FieldsException implements Exception {
  final String body;

  FieldsException({this.body});
}

class UnknownException implements Exception {
  final String message;

  UnknownException({this.message});
}

class NonFieldsException implements Exception {
  final String message;

  NonFieldsException({this.message});
}

class ItemNotFoundException implements Exception {
  final String message;

  ItemNotFoundException({this.message});
}

class UnauthorizedTokenException implements Exception {
  final String message;

  UnauthorizedTokenException({this.message});
}

class NotAllowedPermissionException implements Exception {
  final String message;

  NotAllowedPermissionException({this.message});
}
