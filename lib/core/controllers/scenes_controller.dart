import 'package:get/get.dart';
import 'package:obs_for_sama/core/controllers/server_controller.dart';
import 'package:obs_for_sama/core/controllers/sources_controller.dart';
import 'package:obs_websocket/obs_websocket.dart';

/// # [ScenesController]
/// Controller to manage all scenes from OBS.
/// ## Main goal
/// - Get current scene.
/// - Get all scenes.
/// - Change scene on press.
class ScenesController extends GetxController {
  final RxList<Scene> scenes = List<Scene>.empty(growable: true).obs;
  final RxString currentSceneName = 'Unknow scene name'.obs;

  Future<void> onChangeScene({required Scene scene}) async {
    final ServerController controller = Get.put(ServerController());
    final SourcesController sourcesController = Get.put(SourcesController());
    await controller.obsWebSocket?.scenes.setCurrentProgramScene(scene.sceneName);
    final String currentScene = await controller.obsWebSocket?.scenes.getCurrentProgramScene() ?? 'no scenes';
    currentSceneName.value = currentScene;
    await sourcesController.getListSourcesByCurrentScene();
  }

  Future<void> getListScenes() async {
    final ServerController controller = Get.put(ServerController());
    final SceneListResponse? response = await controller.obsWebSocket?.scenes.getSceneList();
    if (response != null) {
      scenes.value = response.scenes.reversed.toList();
      currentSceneName.value = response.currentProgramSceneName;
    }
  }

  Future<void> getCurrentScene() async {
    final serverController = Get.put(ServerController());
    try {
      final String? response = await serverController.obsWebSocket?.scenes.getCurrentProgramScene();
      currentSceneName.value = response ?? 'Inconnue';
    } catch (e) {
      serverController.showStatusMessage(message: 'Erreur lors de la récupération de la scène : $e');
    }
  }
}
