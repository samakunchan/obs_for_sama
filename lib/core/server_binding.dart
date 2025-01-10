import 'package:get/get.dart';
import 'package:obs_for_sama/core/controllers/auth_obs_form_controller.dart';
import 'package:obs_for_sama/core/controllers/cache_controller.dart';
import 'package:obs_for_sama/core/controllers/error_controller.dart';
import 'package:obs_for_sama/core/controllers/scenes_controller.dart';
import 'package:obs_for_sama/core/controllers/server_controller.dart';
import 'package:obs_for_sama/core/controllers/sound_controller.dart';
import 'package:obs_for_sama/core/controllers/sources_controller.dart';

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
      ..put<SoundController>(SoundController());
  }
}
