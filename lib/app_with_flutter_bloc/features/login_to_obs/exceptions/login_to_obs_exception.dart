class LoginToObsException implements Exception {
  LoginToObsException(this.message);
  final String message;

  @override
  String toString() => '\n----------------\nClass : [LoginToObsException]\nMessage : $message\n----------------\n';
}
