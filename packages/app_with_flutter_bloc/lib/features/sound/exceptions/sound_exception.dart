class SoundException implements Exception {
  SoundException(this.message);
  final String message;

  @override
  String toString() => '\n----------------\nClass : [classname]\nMessage : $message\n----------------\n';
}
