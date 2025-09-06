import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:obs_for_sama/app_with_flutter_bloc/features/server/bloc/server_bloc.dart';
import 'package:obs_for_sama/app_with_flutter_bloc/presentions/widgets/o_b_s_reload_button.dart';
import 'package:obs_for_sama/app_with_flutter_bloc/presentions/widgets/o_b_s_server_connection_button_material.dart';
import 'package:obs_for_sama/app_with_flutter_bloc/presentions/widgets/o_b_s_toogle_sound_button.dart';
import 'package:obs_for_sama/app_with_flutter_bloc/presentions/widgets/o_b_s_toogle_stream_button.dart';
import 'package:obs_for_sama/core/index.dart';

class OBSActionButtonsMobileBloc extends StatelessWidget {
  const OBSActionButtonsMobileBloc({super.key});

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
                                /// CONNECT OBS
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Platform.isAndroid
                                        ? const GoToSettingPage(
                                            key: ValueKey<String>('Android Button connection'),
                                          )
                                        : const GoToSettingPage(
                                            key: ValueKey<String>('IOS Button connection'),
                                          ),
                                  ),
                                ),

                                /// REFRESH
                                const Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.all(8),
                                    child: OBSReloadButton(),
                                  ),
                                ),

                                /// SOUND
                                const Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.all(8),
                                    child: OBSToogleSoundButton(),
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
                        child: GoToSettingPage(),
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
