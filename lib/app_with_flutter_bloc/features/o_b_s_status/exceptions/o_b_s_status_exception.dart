class OBSStatusStartException implements Exception {
  OBSStatusStartException(this.message);
  final String message;

  @override
  String toString() => '\n----------------\nClass : [OBSStatusStartException]\nMessage : $message\n----------------\n';
}

class OBSStatusStopException implements Exception {
  OBSStatusStopException(this.message);
  final String message;

  @override
  String toString() => '\n----------------\nClass : [OBSStatusStopException]\nMessage : $message\n----------------\n';
}
