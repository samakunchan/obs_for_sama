import 'package:obs_for_sama/app_with_flutter_bloc/features/server/exceptions/server_exception.dart';
import 'package:obs_for_sama/app_with_flutter_bloc/features/server/singleton/o_b_s_singleton.dart';
import 'package:obs_websocket/event.dart';
import 'package:obs_websocket/obs_websocket.dart';

class SourcesRepository {
  static Future<List<SceneItemDetail>> toogleActiveSource({
    required SceneItemDetail source,
    required String currentSceneName,
  }) async {
    final ObsWebSocket? obsWebSocket = await OBSSingleton().obs;

    final SceneItemEnableStateChanged sceneItemEnableStateChanged = SceneItemEnableStateChanged(
      sceneName: currentSceneName,
      sceneItemId: source.sceneItemId,
      sceneItemEnabled: !source.sceneItemEnabled,
    );

    await obsWebSocket?.sceneItems.setSceneItemEnabled(sceneItemEnableStateChanged);
    return getListSourcesByCurrentScene(currentSceneName: currentSceneName);
  }

  static Future<List<SceneItemDetail>> getListSourcesByCurrentScene({required String currentSceneName}) async {
    try {
      final ObsWebSocket? obsWebSocket = await OBSSingleton().obs;

      final List<SceneItemDetail> details = await obsWebSocket?.sceneItems.getSceneItemList(currentSceneName) ?? [];
      return details.reversed.toList();
    } on Exception catch (_) {
      throw ServerException('SOURCES_ERROR');
    }
  }
}
