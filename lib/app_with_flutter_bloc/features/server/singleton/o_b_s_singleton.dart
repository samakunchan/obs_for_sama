import 'package:flutter/foundation.dart';
import 'package:obs_for_sama/app_with_flutter_bloc/features/cache/models/o_b_s_model.dart';
import 'package:obs_for_sama/app_with_flutter_bloc/features/cache/repositories/cache_repository.dart';
import 'package:obs_websocket/obs_websocket.dart';

class OBSSingleton {
  factory OBSSingleton() {
    return _instance;
  }

  OBSSingleton._internal();

  static final OBSSingleton _instance = OBSSingleton._internal();

  ObsWebSocket? _obs;

  Future<ObsWebSocket?> get obs async {
    if (_obs == null) {
      final OBSModel obsModel = await CacheRepository.instance.obsModel;
      if (kDebugMode) {
        print('LE MODEL ${obsModel.toJson()}');
      }
      final bool isCacheDatasEmpty = obsModel.toJson().entries.every(
        (MapEntry<String, Object?> test) => test.value != null,
      );

      if (isCacheDatasEmpty) {
        if (kDebugMode) {
          print('Instance du singleton ObsWebSocket');
        }

        // Attend que la connexion soit établie
        _obs = await ObsWebSocket.connect(
          'ws://${obsModel.localIp}:${obsModel.localPort}',
          password: obsModel.localPassword,
        );
      }
    }

    return _obs;
  }

  void clearObsInstance() {
    _obs = null;
    if (kDebugMode) {
      print('Instance ObsWebSocket réinitialisée.');
    }
  }
}
