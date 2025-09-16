import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/index.dart';
import '../../features/server/bloc/server_bloc.dart';
import '../index.dart';

class OBSActionButtons extends StatelessWidget {
  const OBSActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final safeAreaPadding = mediaQuery.padding;
    final screenHeight = mediaQuery.size.height;
    final availableHeight = screenHeight - safeAreaPadding.top - safeAreaPadding.bottom;

    return SingleChildScrollView(
      child: SizedBox(
        height: availableHeight * .85,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            BlocBuilder<ServerBloc, ServerState>(
              builder: (BuildContext context, ServerState state) {
                switch (state) {
                  case ServerIsConnected():
                    return Column(
                      key: const ValueKey<String>('Top buttons (online).'),
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Titre
                        Text(
                          AppText.title.label,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: RSIButtonOutlined(
                                  onTap: Scaffold.of(context).openDrawer,
                                  edgeClipper: const RSIEdgeClipper(
                                    // edgeRightTop: true,
                                    edgeLeftBottom: true,
                                    edgeRightBottom: true,
                                    // edgeLeftTop: true,
                                  ),
                                  child: Icon(
                                    Icons.menu,
                                    color: Theme.of(context).colorScheme.outline,
                                  ),
                                ),
                              ),

                              /// SOUND
                              const Padding(
                                padding: EdgeInsets.all(8),
                                child: OBSToogleSoundButton(),
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
      ),
    );
  }
}
