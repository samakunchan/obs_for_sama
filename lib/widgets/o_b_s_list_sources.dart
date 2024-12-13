import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:obs_for_sama/core/clippers.dart';
import 'package:obs_for_sama/core/controllers/sources_controller.dart';
import 'package:obs_for_sama/core/enums.dart';
import 'package:obs_for_sama/widgets/r_s_i_button.dart';
import 'package:obs_for_sama/widgets/r_s_i_button_outlined.dart';
import 'package:obs_websocket/obs_websocket.dart';

class OBSListSources extends StatelessWidget {
  const OBSListSources({super.key});

  @override
  Widget build(BuildContext context) {
    final SourcesController controller = Get.put(SourcesController());

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Titre
          Text(
            AppText.sources.label,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Obx(() {
                      return Wrap(
                        spacing: 20,
                        runSpacing: 10,
                        children: List.generate(controller.sources.length, (int index) {
                          final SceneItemDetail source = controller.sources[index];

                          return !source.sceneItemEnabled
                              ? RSIButtonOutlined(
                                  key: ValueKey<String>('Source Button ‘${source.sourceName}‘ off'),
                                  edgeClipper: const RSIEdgeClipper(edgeRightTop: true, edgeLeftBottom: true),
                                  width: 150,
                                  height: 150,
                                  onTap: () => controller.toogleActiveSource(source: source),
                                  color: Theme.of(context).colorScheme.shadow,
                                  text: source.sourceName,
                                )
                              : RSIButton(
                                  key: ValueKey<String>('Source Button ‘${source.sourceName}‘ on'),
                                  edgeClipper: const RSIEdgeClipper(edgeRightTop: true, edgeLeftBottom: true),
                                  width: 150,
                                  height: 150,
                                  onTap: () => controller.toogleActiveSource(source: source),
                                  text: source.sourceName,
                                );
                        }),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
