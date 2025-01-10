import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String ip = 'IP';
const String port = 'Port';
const String password = 'Password';

/// # [CacheController]
/// Create an instance of `shared_preferences` library. Used [SharedPreferencesWithCache].
/// ## Allowed list
/// - IP
/// - Port
/// - Password
/// ## Exemples
/// ### To save data
/// ```dart
/// final cacheController = Get.put(CacheController());
/// final SharedPreferencesWithCache cache = await cacheController.prefsWithCache;
/// await cache.setString('IP', 'My IP');
/// ```
/// ### To read data
/// ```dart
/// final cacheController = Get.put(CacheController());
/// final SharedPreferencesWithCache cache = await cacheController.prefsWithCache;
/// final String? localIp = cache.getString(ip);
/// print(localIp);
/// ```
class CacheController extends GetxController {
  final Future<SharedPreferencesWithCache> prefsWithCache = SharedPreferencesWithCache.create(
    cacheOptions: const SharedPreferencesWithCacheOptions(
      allowList: <String>{ip, port, password},
    ),
  );
}
