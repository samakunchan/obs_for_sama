import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:obs_for_sama/core/controllers/server_controller.dart';
import 'package:obs_for_sama/core/enums.dart';
import 'package:obs_for_sama/widgets/o_b_s_reload_button.dart';
import 'package:obs_for_sama/widgets/o_b_s_server_connection_button_widget.dart';
import 'package:obs_for_sama/widgets/o_b_s_server_connection_button_widget_cupertino.dart';
import 'package:obs_for_sama/widgets/o_b_s_toogle_sound_button.dart';
import 'package:obs_for_sama/widgets/o_b_s_toogle_stream_button.dart';

class OBSActionButtons extends StatelessWidget {
  const OBSActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final ServerController controller = Get.find();
    final mediaQuery = MediaQuery.of(context);
    final safeAreaPadding = mediaQuery.padding;
    final screenHeight = mediaQuery.size.height;
    final availableHeight = screenHeight - safeAreaPadding.top - safeAreaPadding.bottom;

    return SingleChildScrollView(
      child: SizedBox(
        height: availableHeight * .85,
        child: Obx(() {
          return Column(
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
                    const Padding(
                      padding: EdgeInsets.all(8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          OBSToogleStreamButton(
                            key: ValueKey<String>('Start and Stop Stream.'),
                          ),
                          SizedBox(width: 200, child: Divider(height: 50)),
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: OBSReloadButton(),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: OBSToogleSoundButton(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Platform.isAndroid
                    ? const OBSServerConnectionButton(
                        key: ValueKey<String>('Android Button connection'),
                      )
                    : const OBSServerConnectionButtonWidgetCupertino(
                        key: ValueKey<String>('IOS Button connection'),
                      ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
