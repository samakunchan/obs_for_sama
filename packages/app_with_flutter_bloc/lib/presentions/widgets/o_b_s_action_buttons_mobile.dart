import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/index.dart';
import '../../features/server/bloc/server_bloc.dart';
import '../index.dart';

class OBSActionButtonsMobile extends StatelessWidget {
  const OBSActionButtonsMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      key: const ValueKey<String>('Actions Buttons Mobile View'),
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          BlocBuilder<ServerBloc, ServerState>(
            builder: (BuildContext context, ServerState state) {
              switch (state) {
                case ServerIsConnected():
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Titre
                      Text(
                        AppText.title.label,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  flex: 6,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: SizedBox(
                                      width: 30,
                                      child: RSIButtonOutlined(
                                        onTap: Scaffold.of(context).openDrawer,
                                        edgeClipper: const RSIEdgeClipper(
                                          edgeRightTop: true,
                                          // edgeLeftBottom: true,
                                          // edgeRightBottom: true,
                                          edgeLeftTop: true,
                                        ),
                                        child: Icon(
                                          Icons.menu,
                                          // size: 40,
                                          color: Theme.of(context).colorScheme.outline,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                const Expanded(flex: 4, child: SizedBox()),

                                /// SOUND
                                const Expanded(
                                  flex: 6,
                                  child: Padding(
                                    padding: EdgeInsets.all(8),
                                    child: SizedBox(
                                      width: 30,
                                      child: OBSToogleSoundButton(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      /// OBS BUTTONS FOOTER
                      const Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              /// OBS SETTINGS
                              Expanded(
                                child: OBSToogleStreamButton(),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  );
                default:
                  return const Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      /// OBS SETTINGS
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: GoToSettingPageButton(),
                      ),
                    ],
                  );
              }
            },
          ),
        ],
      ),
    );
  }
}
