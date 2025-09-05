class ServerException implements Exception {
  ServerException(this.message);
  final String message;

  @override
  String toString() => '\n----------------\nClass : [ServerException]\nMessage : $message\n----------------\n';
}
