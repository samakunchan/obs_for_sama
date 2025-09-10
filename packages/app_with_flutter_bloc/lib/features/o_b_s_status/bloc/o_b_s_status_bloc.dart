import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/index.dart';
import '../../../core/services/client_service.dart';
import '../repositories/o_b_s_status_repository.dart';

part 'o_b_s_status_event.dart';
part 'o_b_s_status_state.dart';

class OBSStatusBloc extends Bloc<OBSStatusEvent, OBSStatusState> {
  OBSStatusBloc() : super(OBSStatusInitial()) {
    on<OBSStatusStreamStarted>(_onStartStream);
    on<OBSStatusStreamStopped>(_onStopStream);
    on<OBSStatusStreamChanged>(_onChangeStream);
  }

  Future<void> _onStartStream(OBSStatusStreamStarted event, Emitter<OBSStatusState> emit) async {
    if (kDebugMode) {
      print('STREAM IS STARTING');
    }
    final Either<Failure, bool> response = await ClientService.baseRequest<bool>(
      getConcrete: OBSStatusRepository.startStreaming,
    );

    switch (response) {
      case Left():
        emit(OBSStatusHasError(message: response.value.message));
      case Right():
      // Le fallback event fait le reste du travail et est écouté avec [OBSStatusStreamChanged].
    }
  }

  Future<void> _onStopStream(OBSStatusStreamStopped event, Emitter<OBSStatusState> emit) async {
    if (kDebugMode) {
      print('STREAM IS STOPPING');
    }
    final Either<Failure, bool> response = await ClientService.baseRequest<bool>(
      getConcrete: OBSStatusRepository.stopStreaming,
    );

    switch (response) {
      case Left():
        emit(OBSStatusHasError(message: response.value.message));
      case Right():
      // Le fallback event fait le reste du travail et est écouté avec [OBSStatusStreamChanged].
    }
  }

  Future<void> _onChangeStream(OBSStatusStreamChanged event, Emitter<OBSStatusState> emit) async {
    if (event.statusStream == StatusStream.isStarting) {
      emit(OBSStatusIsStarting());
    }
    if (event.statusStream == StatusStream.started) {
      emit(OBSStatusHasStarted());
    }
    if (event.statusStream == StatusStream.isStopping) {
      emit(OBSStatusIsStopping());
    }
    if (event.statusStream == StatusStream.stopped) {
      emit(OBSStatusHasStopped());
    }
  }
}
