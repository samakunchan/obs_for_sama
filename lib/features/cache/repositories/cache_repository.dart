import 'package:flutter/foundation.dart';
import 'package:obs_for_sama/features/cache/models/o_b_s_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  Future<OBSModel> get obdModel async {
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
  }
}
