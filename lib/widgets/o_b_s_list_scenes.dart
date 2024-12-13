import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:obs_for_sama/core/clippers.dart';
import 'package:obs_for_sama/core/controllers/scenes_controller.dart';
import 'package:obs_for_sama/core/enums.dart';
import 'package:obs_for_sama/widgets/r_s_i_button.dart';
import 'package:obs_websocket/obs_websocket.dart';

class OBSListScenes extends StatelessWidget {
  const OBSListScenes({super.key});

  @override
  Widget build(BuildContext context) {
    final ScenesController controller = Get.put(ScenesController());

    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            /// Titre
            Row(
              children: [
                Text(
                  AppText.scenes.label,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Obx(() {
                return Wrap(
                  spacing: 20,
                  runSpacing: 10,
                  children: List.generate(controller.scenes.length, (int index) {
                    final Scene scene = controller.scenes[index];
                    final String currentScene = controller.currentSceneName.value;

                    return RSIButton(
                      key: ValueKey<String>('Scene button n°$index : ${scene.sceneName}'),
                      edgeClipper: const RSIEdgeClipper(edgeRightTop: true, edgeLeftBottom: true),
                      width: 150,
                      height: 150,
                      onTap: () => controller.onChangeScene(scene: scene),
                      color: currentScene == scene.sceneName
                          ? Theme.of(context).colorScheme.tertiary
                          : Theme.of(context).colorScheme.primaryContainer,
                      text: scene.sceneName,
                    );
                  }),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
