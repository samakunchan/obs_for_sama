import 'package:flutter/foundation.dart';
import 'package:obs_websocket/obs_websocket.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/exceptions/exceptions.dart';
import '../../server/singleton/o_b_s_singleton.dart';
import '../dto/cache_d_t_o.dart';
import '../models/o_b_s_model.dart';

const String ip = 'ip';
const String port = 'port';
const String password = 'password';

class CacheRepository {
  CacheRepository._internal(this._prefsWithCacheFuture) {
    if (kDebugMode) {
      print('CacheRepository Singleton: _internal constructor called with a Future.');
    }
  }

  final Future<SharedPreferencesWithCache> _prefsWithCacheFuture;

  static CacheRepository? _instance;

  // On ignore pour le moment
  // ignore: prefer_constructors_over_static_methods
  static CacheRepository get instance {
    try {
      if (_instance == null) {
        if (kDebugMode) {
          print("CacheRepository Singleton: 'instance' getter creating DEFAULT (REAL) instance.");
        }
        _instance = CacheRepository._internal(
          SharedPreferencesWithCache.create(
            cacheOptions: const SharedPreferencesWithCacheOptions(
              allowList: <String>{
                ip,
                port,
                password,
              },
            ),
          ),
        );
      }
      return _instance!;
    } on Exception {
      throw CacheException('CACHE_INSTANCE_FAIL');
    }
  }

  Future<SharedPreferencesWithCache> get prefsWithCache => _prefsWithCacheFuture;

  static void setTestInstance(Future<SharedPreferencesWithCache> futureInstance) {
    if (kDebugMode) {
      print('CacheRepository Singleton: setTestInstance called.');
    }
    _instance = CacheRepository._internal(futureInstance);
  }

  static void resetInstanceForTest() {
    if (kDebugMode) {
      print('CacheRepository Singleton: resetInstanceForTest called, _instance set to null.');
    }
    _instance = null;
  }

  Future<OBSModel> get obsModel async {
    try {
      final SharedPreferencesWithCache cache = await prefsWithCache;

      final String? localIp = cache.getString(ip);
      final String? localPort = cache.getString(port);
      final String? localPassword = cache.getString(password);
      final OBSModel obsModel = OBSModel(
        localIp: localIp,
        localPort: localPort,
        localPassword: localPassword,
      );

      return obsModel;
    } on Exception {
      throw CacheException('CACHE_EMPTY');
    }
  }

  Future<bool> setToCache({required CacheDTO cacheDTO}) async {
    try {
      final SharedPreferencesWithCache cache = await prefsWithCache;

      await cache.setString(ip, cacheDTO.localIp ?? '');
      await cache.setString(port, cacheDTO.localPort ?? '');
      await cache.setString(password, cacheDTO.localPassword ?? '');

      return true;
    } on Exception {
      throw CacheException('CACHE_ERROR_SETTING');
    }
  }

  Future<bool> clearCache() async {
    try {
      final SharedPreferencesWithCache cache = await prefsWithCache;
      await cache.clear();
      _instance = null;
      final ObsWebSocket? obsWebSocket = await OBSSingleton().obs;
      if (obsWebSocket != null) {
        await obsWebSocket.close();
      }
      OBSSingleton().clearObsInstance();
      return true;
    } on Exception {
      throw CacheException('CACHE_CLEAR_ERROR');
    }
  }
}
