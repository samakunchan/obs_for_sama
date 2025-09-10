class Failure {
  Failure(this.message);
  final String message;
}

class NoFailure extends Failure {
  NoFailure(super.message);
}

class SocketFailure extends Failure {
  SocketFailure(super.message);
}

class TimeOutFailure extends Failure {
  TimeOutFailure(super.message);
}

class HostFailure extends Failure {
  HostFailure(super.message);
}

class PortFailure extends Failure {
  PortFailure(super.message);
}

class PasswordFailure extends Failure {
  PasswordFailure(super.message);
}

class CacheFailure extends Failure {
  CacheFailure(super.message);
}

class TitleFailure extends Failure {
  TitleFailure(super.message);
}

class OBSServerFailure extends Failure {
  OBSServerFailure(super.message);
}

class OBSSoundFailure extends Failure {
  OBSSoundFailure(super.message);
}

class OBSScenesFailure extends Failure {
  OBSScenesFailure(super.message);
}

class OBSSourcesFailure extends Failure {
  OBSSourcesFailure(super.message);
}

class OBSStatusFailure extends Failure {
  OBSStatusFailure(super.message);
}

class OBSFailure extends Failure {
  OBSFailure(super.message);
}
