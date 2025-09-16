part of 'server_bloc.dart';

abstract class ServerState extends Equatable {
  const ServerState();
}

final class ServerInitial extends ServerState {
  @override
  List<Object> get props => [];
}

final class ServerIsLoading extends ServerState {
  @override
  String toString() {
    return 'ServerIsLoading';
  }

  @override
  List<Object> get props => [];
}

final class ServerHasError extends ServerState {
  const ServerHasError({required this.errorInstance});
  final Failure errorInstance;

  @override
  String toString() {
    return 'ServerHasError - $errorInstance';
  }

  @override
  List<Object> get props => [errorInstance];
}

final class ServerIsConnected extends ServerState {
  @override
  String toString() {
    return 'ServerIsConnected';
  }

  @override
  List<Object> get props => [];
}

final class ServerIsReloaded extends ServerState {
  @override
  String toString() {
    return 'ServerIsReloaded';
  }

  @override
  List<Object> get props => [];
}

final class ServerIsDisConnected extends ServerState {
  @override
  String toString() {
    return 'ServerIsDisConnected';
  }

  @override
  List<Object> get props => [];
}
