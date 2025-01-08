import 'package:obs_for_sama/mvvm/data_layer/models/auth_form_model.dart';
import 'package:obs_for_sama/mvvm/data_layer/repository/cache_repository.dart';

class CacheReadUseCase {
  const CacheReadUseCase({required this.repository});
  final CacheRepository repository;

  /// Read datas from cache with the [CacheRepository].
  Future<AuthFormModel> read() {
    return repository.getDatasToCache();
  }
}
