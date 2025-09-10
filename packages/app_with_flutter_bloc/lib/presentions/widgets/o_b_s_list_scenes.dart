import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:obs_websocket/obs_websocket.dart';
import 'package:sizer/sizer.dart';

import '../../core/index.dart';
import '../../features/o_b_s_scenes/bloc/current_scene_bloc.dart';
import '../../features/o_b_s_scenes/selectors/current_scene_selector.dart';
import '../../features/o_b_s_scenes/selectors/scenes_selector.dart';

class OBSListScenes extends StatelessWidget {
  const OBSListScenes({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: ScenesSelector(
              values: (List<Scene> scenes) {
                return Wrap(
                  spacing: 15.sp,
                  runSpacing: 15.sp,
                  children: scenes.isEmpty
                      ? List.generate(3, (int index) {
                          return RSIButton(
                            key: ValueKey<String>('Scene button n°-$index'),
                            edgeClipper: const RSIEdgeClipper(edgeRightTop: true, edgeLeftBottom: true),
                            width: 40.sp,
                            height: 40.sp,
                            onTap: () {},
                            color: Colors.grey.withValues(alpha: (index + 1) * .3),
                            text: 'SCENE_NAME $index',
                          );
                        })
                      : List.generate(scenes.length, (int index) {
                          final Scene scene = scenes[index];

                          return CurrentSceneSelector(
                            value: (String currentScene) => RSIButton(
                              key: ValueKey<String>('Scene button n°$index : ${scene.sceneName}'),
                              edgeClipper: const RSIEdgeClipper(edgeRightTop: true, edgeLeftBottom: true),
                              width: 40.sp,
                              height: 40.sp,
                              onTap: () {
                                context.read<CurrentSceneBloc>().add(
                                  CurrentSceneChanged(sceneName: scene.sceneName),
                                );
                              },
                              color: currentScene == scene.sceneName
                                  ? Theme.of(context).colorScheme.tertiary
                                  : Theme.of(context).colorScheme.primaryContainer,
                              text: scene.sceneName,
                            ),
                          );
                        }),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
