import 'package:shared_preferences/shared_preferences.dart';

const String ip = 'IP';
const String port = 'Port';
const String password = 'Password';

const String noIp = 'no ip found to cache';
const String noPort = 'no port found to cache';
const String noPassword = 'no password found to cache';

class CacheService {
  Future<SharedPreferencesWithCache> getCacheInstance() {
    return SharedPreferencesWithCache.create(
      cacheOptions: const SharedPreferencesWithCacheOptions(
        allowList: <String>{ip, port, password},
      ),
    );
  }
}
