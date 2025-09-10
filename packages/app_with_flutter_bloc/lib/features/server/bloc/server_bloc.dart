import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/index.dart';
import '../../../core/services/client_service.dart';
import '../repositories/server_repository.dart';

part 'server_event.dart';
part 'server_state.dart';

class ServerBloc extends Bloc<ServerEvent, ServerState> {
  ServerBloc() : super(ServerInitial()) {
    on<ServerConnected>(_onConnectToServer);
    on<ServerReloaded>(_onResetServer);
  }

  Future<void> _onConnectToServer(ServerConnected event, Emitter<ServerState> emit) async {
    if (kDebugMode) {
      print('Connexion au serveur');
    }
    emit(ServerIsLoading());

    final Either<Failure, StatusStream> response = await ClientService.baseRequest<StatusStream>(
      getConcrete: ServerRepository().connectToOBS,
    );
    switch (response) {
      case Left():
        if (kDebugMode) {
          print('Server Bloc Error - ${response.value}');
        }
        emit(ServerHasError(message: response.value.message));
      case Right():
        if (kDebugMode) {
          print('Server Bloc - ${response.value}');
        }
        emit(ServerIsConnected());
    }
  }

  Future<void> _onResetServer(ServerReloaded event, Emitter<ServerState> emit) async {
    if (kDebugMode) {
      print('Réinitialisation du serveur');
    }
    emit(ServerIsLoading());

    final Either<Failure, StatusStream> response = await ClientService.baseRequest<StatusStream>(
      getConcrete: ServerRepository().reload,
    );
    switch (response) {
      case Left():
        emit(ServerHasError(message: response.value.message));
      case Right():
        if (kDebugMode) {
          print(response.value);
        }
        emit(ServerIsReloaded());
    }
  }
}
