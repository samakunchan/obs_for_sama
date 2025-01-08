import 'package:obs_for_sama/core/enums.dart';
import 'package:obs_for_sama/mvvm/data_layer/models/auth_form_model.dart';
import 'package:obs_for_sama/mvvm/data_layer/service/cache_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CacheRepository {
  const CacheRepository({required this.cacheService});
  final CacheService cacheService;

  Future<void> setDatasToCache({required AuthFormModel form}) async {
    final SharedPreferencesWithCache cache = await cacheService.getCacheInstance();
    await cache.setString(SettingsEnum.ip.label, form.ip);
    await cache.setString(SettingsEnum.port.label, form.port);
    await cache.setString(SettingsEnum.password.label, form.password);
  }

  Future<AuthFormModel> getDatasToCache() async {
    final SharedPreferencesWithCache cache = await cacheService.getCacheInstance();
    final String? localIp = cache.getString(ip);
    final String? localPort = cache.getString(port);
    final String? localPassword = cache.getString(password);
    return AuthFormModel(
      ip: localIp ?? noIp,
      port: localPort ?? noPort,
      password: localPassword ?? noPassword,
    );
  }
}
