import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:obs_for_sama/core/utils/enums.dart';

part 'title_event.dart';
part 'title_state.dart';

class TitleBloc extends Bloc<TitleEvent, TitleState> {
  TitleBloc() : super(TitleInitial()) {
    on<TitleChanged>(_onChangeTitle);
    add(TitleChanged(title: AppText.scenes.label));
  }

  Future<void> _onChangeTitle(TitleChanged event, Emitter<TitleState> emit) async {
    emit(TitleWithValue(title: event.title));
  }
}
