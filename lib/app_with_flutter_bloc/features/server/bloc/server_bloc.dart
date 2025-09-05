import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:obs_for_sama/app_with_flutter_bloc/features/server/repositories/server_repository.dart';
import 'package:obs_for_sama/app_with_flutter_bloc/features/server/services/server_service.dart';
import 'package:obs_for_sama/core/index.dart';

part 'server_event.dart';
part 'server_state.dart';

class ServerBloc extends Bloc<ServerEvent, ServerState> {
  ServerBloc() : super(ServerInitial()) {
    on<ServerConnected>(_onConnectToServer);
    on<ServerReloaded>(_onResetServer);
  }
  // ServerBloc({required Future<OBSManagerModel> manager}) : _manager = manager, super(ServerInitial()) {
  //   on<ServerConnected>(_onConnectToServer);
  //   on<ServerReloaded>(_onResetServer);
  // }

  Future<void> _onConnectToServer(ServerConnected event, Emitter<ServerState> emit) async {
    if (kDebugMode) {
      print('Connexion au serveur');
    }
    emit(ServerIsLoading());

    final Either<String, StatusStream> response = await ServerService.baseRequest<StatusStream>(
      getConcrete: ServerRepository().connectToOBS,
    );
    switch (response) {
      case Left():
        if (kDebugMode) {
          print('Server Bloc Error - ${response.value}');
        }
        emit(ServerHasError(message: response.value));
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

    final Either<String, StatusStream> response = await ServerService.baseRequest<StatusStream>(
      getConcrete: ServerRepository().reload,
    );
    switch (response) {
      case Left():
        emit(ServerHasError(message: response.value));
      case Right():
        if (kDebugMode) {
          print(response.value);
        }
        emit(ServerIsReloaded());
    }
  }
}
