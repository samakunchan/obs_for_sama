import 'package:obs_for_sama/mvvm/data_layer/models/auth_form_model.dart';
import 'package:obs_for_sama/mvvm/data_layer/repository/cache_repository.dart';

class CacheWriteUseCase {
  const CacheWriteUseCase({required this.repository});
  final CacheRepository repository;

  /// Write datas to cache with the [CacheRepository].
  Future<void> write({required AuthFormModel form}) async {
    await repository.setDatasToCache(form: form);
  }
}
