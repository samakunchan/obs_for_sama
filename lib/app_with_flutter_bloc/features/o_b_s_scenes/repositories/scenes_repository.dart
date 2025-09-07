import 'package:flutter/foundation.dart';
import 'package:obs_for_sama/app_with_flutter_bloc/features/o_b_s_scenes/models/o_b_s_scene_model.dart';
import 'package:obs_for_sama/app_with_flutter_bloc/features/server/singleton/o_b_s_singleton.dart';
import 'package:obs_websocket/obs_websocket.dart';

class ScenesRepository {
  /// Get all scenes.
  static Future<OBSSceneModel> getListScenes() async {
    final ObsWebSocket? obsWebSocket = await OBSSingleton().obs;
    final SceneListResponse? response = await obsWebSocket?.scenes.getSceneList();
    if (response != null) {
      return OBSSceneModel(
        scenes: response.scenes.reversed.toList(),
        currentScene: response.currentProgramSceneName,
      );
    }
    return OBSSceneModel(
      scenes: List<Scene>.empty(growable: true),
      currentScene: 'SCENES_NOT_AVAILABLE',
    );
  }

  /// Event to change current scene<br>
  /// required [Scene]
  static Future<String> onChangeScene({required String sceneName}) async {
    if (kDebugMode) {
      print('La scene est géré par le répository');
    }
    final ObsWebSocket? obsWebSocket = await OBSSingleton().obs;
    await obsWebSocket?.scenes.setCurrentProgramScene(sceneName);
    final String currentScene = await obsWebSocket?.scenes.getCurrentProgramScene() ?? 'no scenes';
    return currentScene;
  }

  static Future<String?> getCurrentScene() async {
    final ObsWebSocket? obsWebSocket = await OBSSingleton().obs;
    final String? response = await obsWebSocket?.scenes.getCurrentProgramScene();
    return response;
  }
}
