import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'error_event.dart';
part 'error_state.dart';

class ErrorBloc extends Bloc<ErrorEvent, ErrorState> {
  ErrorBloc() : super(ErrorInitial()) {
    on<ErrorEmitted>(_onEmitError);
    on<ErrorReseted>(_onResetError);
  }

  Future<void> _onEmitError(ErrorEmitted event, Emitter<ErrorState> emit) async {
    emit(ErrorLoading());
    emit(ErrorMessageDisplayed(message: event.message));
  }

  Future<void> _onResetError(ErrorReseted event, Emitter<ErrorState> emit) async {
    emit(ErrorInitial());
  }
}
