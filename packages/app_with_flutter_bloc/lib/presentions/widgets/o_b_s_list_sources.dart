import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:obs_websocket/obs_websocket.dart';
import 'package:sizer/sizer.dart';

import '../../core/index.dart';
import '../../features/o_b_s_sources/bloc/current_source_bloc.dart';
import '../../features/o_b_s_sources/selectors/sources_selector.dart';

class OBSListSources extends StatelessWidget {
  const OBSListSources({required this.currentSceneName, super.key});
  final String currentSceneName;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: SourcesSelector(
              values: (List<SceneItemDetail> sources) {
                return Wrap(
                  spacing: 15.sp,
                  runSpacing: 15.sp,
                  children: sources.isEmpty
                      ? List.generate(10, (int index) {
                          return RSIButton(
                            key: ValueKey<String>('Source button n°-$index'),
                            edgeClipper: const RSIEdgeClipper(edgeRightTop: true, edgeLeftBottom: true),
                            width: 40.sp,
                            height: 40.sp,
                            onTap: () {},
                            color: Colors.grey.withValues(alpha: (index + 1) * .2),
                            text: 'SOURCE_NAME $index',
                          );
                        })
                      : List.generate(sources.length, (int index) {
                          final SceneItemDetail source = sources[index];

                          return !source.sceneItemEnabled
                              ? RSIButtonOutlined(
                                  key: ValueKey<String>('Source Button ‘${source.sourceName}‘ off'),
                                  edgeClipper: const RSIEdgeClipper(edgeRightTop: true, edgeLeftBottom: true),
                                  width: 40.sp,
                                  height: 40.sp,
                                  onTap: () {
                                    context.read<CurrentSourceBloc>().add(
                                      CurrentSourceChanged(
                                        source: source,
                                        sceneName: currentSceneName,
                                      ),
                                    );
                                  },
                                  color: Theme.of(context).colorScheme.shadow,
                                  text: source.sourceName,
                                )
                              : RSIButton(
                                  key: ValueKey<String>('Source Button ‘${source.sourceName}‘ on'),
                                  edgeClipper: const RSIEdgeClipper(edgeRightTop: true, edgeLeftBottom: true),
                                  width: 40.sp,
                                  height: 40.sp,
                                  onTap: () {
                                    context.read<CurrentSourceBloc>().add(
                                      CurrentSourceChanged(
                                        source: source,
                                        sceneName: currentSceneName,
                                      ),
                                    );
                                  },
                                  text: source.sourceName,
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
