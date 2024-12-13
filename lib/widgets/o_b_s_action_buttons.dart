import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:obs_for_sama/core/clippers.dart';
import 'package:obs_for_sama/core/controllers/server_controller.dart';
import 'package:obs_for_sama/core/enums.dart';
import 'package:obs_for_sama/widgets/o_b_s_server_connection_button_widget.dart';
import 'package:obs_for_sama/widgets/o_b_s_server_connection_button_widget_cupertino.dart';
import 'package:obs_for_sama/widgets/o_b_s_toogle_sound_button.dart';
import 'package:obs_for_sama/widgets/r_s_i_button_outlined.dart';

class OBSActionButtons extends StatelessWidget {
  const OBSActionButtons({required this.controller, super.key});
  final ServerController controller;

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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (controller.isOBSSynchronized.value)
              Column(
                key: const ValueKey<String>('Top buttons (online).'),
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
                        Obx(
                          () => controller.isStreamStarted.value
                              ? Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: RSIButtonOutlined(
                                    color: Colors.red,
                                    onTap: controller.stopStreaming,
                                    edgeClipper: const RSIEdgeClipper(edgeRightTop: true, edgeLeftBottom: true),
                                    text: AppText.stop.label,
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: RSIButtonOutlined(
                                    onTap: controller.startStreaming,
                                    edgeClipper: const RSIEdgeClipper(edgeRightTop: true, edgeLeftBottom: true),
                                    text: AppText.start.label,
                                  ),
                                ),
                        ),
                        const SizedBox(width: 200, child: Divider(height: 50)),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: RSIButtonOutlined(
                            onTap: controller.reload,
                            edgeClipper: const RSIEdgeClipper(edgeRightTop: true, edgeLeftBottom: true),
                            child: Icon(
                              Icons.refresh,
                              size: 40,
                              color: Theme.of(context).colorScheme.outline,
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(8),
                          child: OBSToogleSoundButton(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 200, child: Divider(height: 50)),
                ],
              )
            else
              Column(
                key: const ValueKey<String>('Top buttons (offline).'),
                children: [
                  /// Titre
                  Text(
                    AppText.title.label,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ],
              ),

            /// OBS BUTTONS FOOTER
            Column(
              key: const ValueKey<String>('Bottom buttons'),
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const SizedBox(width: 200, child: Divider(height: 50)),

                /// OBS SETTINGS
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Platform.isAndroid ? const OBSServerConnectionButton() : const OBSServerConnectionButtonWidgetCupertino(),
                ),

                /// OBS CONNECTION
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: RSIButtonOutlined(
                    onTap: controller.connectToOBS,
                    edgeClipper: const RSIEdgeClipper(edgeRightTop: true, edgeLeftBottom: true),
                    text: AppText.connectToOBS.label,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
