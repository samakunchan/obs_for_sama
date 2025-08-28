import 'package:get/get.dart';
import 'package:obs_for_sama/core/controllers/obs/scenes_controller.dart';
import 'package:obs_for_sama/core/controllers/obs/server_controller.dart';
import 'package:obs_websocket/event.dart';
import 'package:obs_websocket/obs_websocket.dart';

/// # [SourcesController]
/// Controller to manage all sources from OBS.
/// ## Main goal
/// - Get all sources by current scene.
/// - Turn on/off one source.
class SourcesController extends GetxController {
  final RxString currentSceneName = 'Unknow scene name'.obs;
  final RxList<SceneItemDetail> sources = List<SceneItemDetail>.empty(growable: true).obs;

  Future<void> toogleActiveSource({required SceneItemDetail source}) async {
    final ScenesController scenesController = Get.find();
    final ServerController controller = Get.find();

    final SceneItemEnableStateChanged sceneItemEnableStateChanged = SceneItemEnableStateChanged(
      sceneName: scenesController.currentSceneName.value,
      sceneItemId: source.sceneItemId,
      sceneItemEnabled: !source.sceneItemEnabled,
    );

    await controller.obsWebSocket?.sceneItems.setSceneItemEnabled(sceneItemEnableStateChanged);
    await getListSourcesByCurrentScene();
  }

  Future<void> getListSourcesByCurrentScene() async {
    final ScenesController scenesController = Get.find();
    final ServerController controller = Get.find();

    final currentScene = scenesController.currentSceneName.value;
    final List<SceneItemDetail> details = await controller.obsWebSocket?.sceneItems.getSceneItemList(currentScene) ?? [];
    sources.value = details.reversed.toList();
  }
}
