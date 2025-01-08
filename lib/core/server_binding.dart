import 'package:get/get.dart';
import 'package:obs_for_sama/core/controllers/auth_obs_form_controller.dart';
import 'package:obs_for_sama/core/controllers/error_controller.dart';
import 'package:obs_for_sama/mvvm/data_layer/repository/auth_repository.dart';
import 'package:obs_for_sama/mvvm/data_layer/repository/cache_repository.dart';
import 'package:obs_for_sama/mvvm/data_layer/repository/o_b_s_repository.dart';
import 'package:obs_for_sama/mvvm/data_layer/service/auth_service.dart';
import 'package:obs_for_sama/mvvm/data_layer/service/cache_service.dart';
import 'package:obs_for_sama/mvvm/data_layer/service/o_b_s_service.dart';
import 'package:obs_for_sama/mvvm/logic_layer/use_cases/cache_read_use_case.dart';
import 'package:obs_for_sama/mvvm/logic_layer/use_cases/cache_write_use_case.dart';
import 'package:obs_for_sama/mvvm/logic_layer/use_cases/connect_to_o_b_s_use_case.dart';
import 'package:obs_for_sama/mvvm/logic_layer/use_cases/get_exception_use_case.dart';
import 'package:obs_for_sama/mvvm/logic_layer/use_cases/get_profile_o_b_s_use_case.dart';
import 'package:obs_for_sama/mvvm/logic_layer/use_cases/user_get_text_field_use_case.dart';
import 'package:obs_for_sama/mvvm/ui_layer/view_models/o_b_s_server_view_model.dart';

/// Il y a un ordre d'éxécution des controllers.
class ServerBinding extends Bindings {
  @override
  void dependencies() {
    Get
          ..put<OBSServerViewModel>(
            OBSServerViewModel(
              connectToOBSUseCase: ConnectToOBSUseCase(repository: getServerRepository()),
              getProfileUseCase: GetProfileOBSUseCase(repository: getServerRepository()),
              cacheReadUseCase: CacheReadUseCase(repository: getCacheRepository()),
              cacheWriteUseCase: CacheWriteUseCase(repository: getCacheRepository()),
              userGetTextFieldUseCase: UserGetTextFieldUseCase(repository: getAuthRepository()),
              getExceptionUseCase: GetExceptionUseCase(),
            ),
          )
          ..put<ErrorController>(ErrorController())
          ..put<AuthObsFormController>(AuthObsFormController())
        // ..put<SourcesController>(SourcesController())
        // ..put<ScenesController>(ScenesController())
        // ..put<SoundController>(SoundController())
        ;
  }

  OBSRepository getServerRepository() {
    const OBSService service = OBSService();
    return const OBSRepository(obsService: service);
  }

  CacheRepository getCacheRepository() {
    final CacheService service = CacheService();
    return CacheRepository(cacheService: service);
  }

  AuthRepository getAuthRepository() {
    final AuthService service = AuthService();
    return AuthRepository(authService: service);
  }
}
