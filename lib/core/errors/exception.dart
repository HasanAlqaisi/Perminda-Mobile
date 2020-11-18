class FieldsException implements Exception {
  String body;

  FieldsException({this.body});
}

class UnknownException implements Exception {
  String message;

  UnknownException({this.message});
}

class NonFieldsException implements Exception {
  String message;

  NonFieldsException({this.message});
}

class ItemNotFoundException implements Exception {
  String message;

  ItemNotFoundException({this.message});
}
