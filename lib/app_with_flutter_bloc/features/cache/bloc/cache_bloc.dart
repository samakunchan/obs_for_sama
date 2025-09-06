import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:obs_for_sama/app_with_flutter_bloc/features/cache/dto/cache_d_t_o.dart';
import 'package:obs_for_sama/app_with_flutter_bloc/features/cache/models/o_b_s_model.dart';
import 'package:obs_for_sama/app_with_flutter_bloc/features/cache/repositories/cache_repository.dart';
import 'package:obs_for_sama/app_with_flutter_bloc/features/messages/enums/messages_enum.dart';

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
    final OBSModel obsModel = await CacheRepository.instance.obsModel;
    final bool testCacheValue = obsModel.toJson().entries.every((MapEntry<String, Object?> test) => test.value != null);
    if (!testCacheValue) {
      emit(CacheHasError(message: AppMessagesEnum.cacheEmpty.key));
    } else {
      emit(CacheFoundDatas(obsModel: obsModel));
    }
    if (kDebugMode) {
      print('Test des valeurs du cache /n${obsModel.toJson().entries.every((test) => test.value != null)}');
    }
  }

  Future<void> _onCacheWritten(CacheWritten event, Emitter<CacheState> emit) async {
    emit(CacheIsLoading());
    final bool isOK = await CacheRepository.instance.setToCache(cacheDTO: event.cacheDTO);
    if (isOK) {
      emit(CacheIsUpdated());
    }
  }

  Future<void> _onCacheCleared(CacheCleared event, Emitter<CacheState> emit) async {
    final bool isOK = await CacheRepository.instance.clearCache();
    if (isOK) {
      emit(CacheIsCleared());
    }
  }
}
