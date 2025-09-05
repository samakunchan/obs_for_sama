import 'package:flutter/foundation.dart';
import 'package:obs_for_sama/features/cache/models/o_b_s_model.dart';
import 'package:obs_for_sama/features/cache/repositories/cache_repository.dart';
import 'package:obs_websocket/obs_websocket.dart';

class OBSSingleton {
  // Fabrique pour retourner l'unique instance
  factory OBSSingleton() {
    return _instance;
  }
  // Constructeur privé pour empêcher la création d'instances multiples
  OBSSingleton._internal();

  // Instance statique et privée de la classe
  static final OBSSingleton _instance = OBSSingleton._internal();

  // L'instance ObsWebSocket
  ObsWebSocket? _obs;

  // Méthode pour obtenir l'instance ObsWebSocket
  // si elle n'est pas encore initialisée
  Future<ObsWebSocket?> get obs async {
    if (_obs == null) {
      // final ServerRepository serverRepository = ServerRepository();
      // final OBSModel obsModel = await serverRepository.getLocalDataForSettings();
      final OBSModel obsModel = await CacheRepository.instance.obdModel;
      final bool isCacheDatasEmpty = obsModel.toJson().entries.every(
        (MapEntry<String, Object?> test) => test.value != null,
      );

      // Si le cache n'est pas vide
      if (isCacheDatasEmpty) {
        if (kDebugMode) {
          print('Instance du singleton ObsWebSocket');
        }

        // Attend que la connexion soit établie
        _obs = await ObsWebSocket.connect(
          'ws://${obsModel.localIp}:${obsModel.localPort}',
          password: obsModel.localPassword,
          // fallbackEventHandler: fallBackEvent,
        );
      }
    }

    return _obs;
  }
}
