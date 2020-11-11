class FieldsException implements Exception {
  String body;

  FieldsException({this.body});
}

class UnknownException implements Exception {
  String message;

  UnknownException({this.message});
}
