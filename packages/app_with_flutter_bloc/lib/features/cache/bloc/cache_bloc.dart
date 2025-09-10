import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/index.dart';
import '../../../core/services/client_service.dart';
import '../dto/cache_d_t_o.dart';
import '../models/o_b_s_model.dart';
import '../repositories/cache_repository.dart';

part 'cache_event.dart';
part 'cache_state.dart';

class CacheBloc extends Bloc<CacheEvent, CacheState> {
  CacheBloc() : super(CacheInitial()) {
    on<CacheInspectionCredentials>(_onCacheInspectionCredentials);
    on<CacheWritten>(_onCacheWritten);
    on<CacheCleared>(_onCacheCleared);
    add(const CacheInspectionCredentials());
  }
  Future<void> _onCacheInspectionCredentials(CacheInspectionCredentials event, Emitter<CacheState> emit) async {
    if (kDebugMode) {
      print('CacheBloc - Inspection du cache');
    }
    emit(CacheIsLoading());
    final Either<Failure, OBSModel> response = await ClientService.baseRequest<OBSModel>(
      getConcrete: () => CacheRepository.instance.obsModel,
    );

    switch (response) {
      case Left():
        emit(CacheHasError(message: response.value.message));
      case Right():
        final bool testCacheValue = response.value.toJson().entries.every(
          (MapEntry<String, Object?> test) => test.value != null,
        );
        if (!testCacheValue) {
          emit(CacheHasError(message: AppMessagesEnum.cacheEmpty.key));
        } else {
          emit(CacheFoundDatas(obsModel: response.value));
        }
        if (kDebugMode) {
          print('Test des valeurs du cache /n${response.value.toJson().entries.every((test) => test.value != null)}');
        }
    }
  }

  Future<void> _onCacheWritten(CacheWritten event, Emitter<CacheState> emit) async {
    emit(CacheIsLoading());
    final Either<Failure, bool> response = await ClientService.baseRequest<bool>(
      getConcrete: () => CacheRepository.instance.setToCache(cacheDTO: event.cacheDTO),
    );

    switch (response) {
      case Left():
        emit(CacheHasError(message: response.value.message));
      case Right():
        emit(CacheIsUpdated());
    }
  }

  Future<void> _onCacheCleared(CacheCleared event, Emitter<CacheState> emit) async {
    final Either<Failure, bool> response = await ClientService.baseRequest<bool>(
      getConcrete: CacheRepository.instance.clearCache,
    );

    switch (response) {
      case Left():
        emit(CacheHasError(message: response.value.message));
      case Right():
        emit(CacheIsCleared());
    }
  }
}
