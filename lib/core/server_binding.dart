import 'package:get/get.dart';
import 'package:obs_for_sama/core/controllers/cache_controller.dart';
import 'package:obs_for_sama/core/controllers/scenes_controller.dart';
import 'package:obs_for_sama/core/controllers/server_controller.dart';
import 'package:obs_for_sama/core/controllers/sound_controller.dart';
import 'package:obs_for_sama/core/controllers/sources_controller.dart';

class ServerBinding extends Bindings {
  @override
  void dependencies() {
    Get
      ..put<ServerController>(ServerController())
      ..put<CacheController>(CacheController())
      ..put<ScenesController>(ScenesController())
      ..put<SourcesController>(SourcesController())
      ..put<SoundController>(SoundController());
  }
}
