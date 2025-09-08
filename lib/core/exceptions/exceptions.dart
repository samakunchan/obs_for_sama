class OBSException implements Exception {
  OBSException(this.message);
  final String message;

  @override
  String toString() =>
      '''
  \n----------------
  \nClass : [$this]
  \nMessage : $message
  \n----------------\n
  ''';
}

class CacheException extends OBSException {
  CacheException(super.message);
}

class OBSServerException extends OBSException {
  OBSServerException(super.message);
}

class OBSSoundException extends OBSException {
  OBSSoundException(super.message);
}

class OBSScenesException extends OBSException {
  OBSScenesException(super.message);
}

class OBSSourcesException extends OBSException {
  OBSSourcesException(super.message);
}

class OBSStatusException extends OBSException {
  OBSStatusException(super.message);
}
