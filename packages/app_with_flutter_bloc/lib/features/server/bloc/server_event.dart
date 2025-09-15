part of 'server_bloc.dart';

abstract class ServerEvent extends Equatable {
  const ServerEvent();
}

final class ServerConnected extends ServerEvent {
  @override
  List<Object> get props => [];
}

final class ServerReloaded extends ServerEvent {
  @override
  List<Object> get props => [];
}

final class ServerDisConnected extends ServerEvent {
  @override
  List<Object> get props => [];
}
