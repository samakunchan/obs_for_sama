import 'package:get/get.dart';
import 'package:obs_for_sama/core/controllers/lifecyle/life_cycle_controller.dart';
import 'package:obs_for_sama/core/controllers/obs/auth_obs_form_controller.dart';
import 'package:obs_for_sama/core/controllers/obs/cache_controller.dart';
import 'package:obs_for_sama/core/controllers/obs/error_controller.dart';
import 'package:obs_for_sama/core/controllers/obs/scenes_controller.dart';
import 'package:obs_for_sama/core/controllers/obs/server_controller.dart';
import 'package:obs_for_sama/core/controllers/obs/sound_controller.dart';
import 'package:obs_for_sama/core/controllers/obs/sources_controller.dart';

/// Il y a un ordre d'éxécution des controllers.
class ServerBinding extends Bindings {
  @override
  void dependencies() {
    Get
      ..put<CacheController>(CacheController())
      ..put<ErrorController>(ErrorController())
      ..put<AuthObsFormController>(AuthObsFormController())
      ..put<ServerController>(ServerController())
      ..put<SourcesController>(SourcesController())
      ..put<ScenesController>(ScenesController())
      ..put<SoundController>(SoundController())
      ..put<LifeCycleController>(LifeCycleController());
  }
}
