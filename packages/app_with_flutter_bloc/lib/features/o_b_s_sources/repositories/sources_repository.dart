import 'package:obs_websocket/event.dart';
import 'package:obs_websocket/obs_websocket.dart';

import '../../../core/exceptions/exceptions.dart';
import '../../server/singleton/o_b_s_singleton.dart';

class SourcesRepository {
  static Future<List<SceneItemDetail>> toogleActiveSource({
    required SceneItemDetail source,
    required String currentSceneName,
  }) async {
    try {
      final ObsWebSocket? obsWebSocket = await OBSSingleton().obs;

      final SceneItemEnableStateChanged sceneItemEnableStateChanged = SceneItemEnableStateChanged(
        sceneName: currentSceneName,
        sceneItemId: source.sceneItemId,
        sceneItemEnabled: !source.sceneItemEnabled,
      );

      await obsWebSocket?.sceneItems.setSceneItemEnabled(sceneItemEnableStateChanged);
      return getListSourcesByCurrentScene(currentSceneName: currentSceneName);
    } on Exception {
      throw OBSSourcesException('SOURCES_TOOGLE_ERROR');
    }
  }

  static Future<List<SceneItemDetail>> getListSourcesByCurrentScene({required String currentSceneName}) async {
    try {
      final ObsWebSocket? obsWebSocket = await OBSSingleton().obs;

      final List<SceneItemDetail> details = await obsWebSocket?.sceneItems.getSceneItemList(currentSceneName) ?? [];
      return details.reversed.toList();
    } on Exception {
      throw OBSSourcesException('SOURCES_LIST_ERROR');
    }
  }
}
