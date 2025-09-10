import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:obs_websocket/obs_websocket.dart';

import '../../core/index.dart';
import '../../features/cache/listeners/cache_listener.dart';
import '../../features/error/bloc/error_bloc.dart';
import '../../features/o_b_s_scenes/selectors/current_scene_selector.dart';
import '../../features/server/bloc/server_bloc.dart';
import '../../features/server/listeners/server_listener.dart';
import '../../features/server/repositories/server_repository.dart';
import '../../features/server/singleton/o_b_s_singleton.dart';
import '../../features/title/bloc/title_bloc.dart';
import '../../features/title/selectors/title_selector.dart';
import '../widgets/animated_arrow.dart';
import '../widgets/go_to_setting_page_button.dart';
import '../widgets/o_b_s_action_buttons.dart';
import '../widgets/o_b_s_list_scenes.dart';
import '../widgets/o_b_s_list_sources.dart';

class OBSLayoutDefault extends StatelessWidget {
  const OBSLayoutDefault({super.key});

  @override
  Widget build(BuildContext context) {
    final PageController pageController = PageController();

    return ServerListener(
      child: CacheListener(
        child: SafeArea(
          child: BlocBuilder<ErrorBloc, ErrorState>(
            builder: (_, ErrorState state) {
              if (state is ErrorMessageDisplayed) {
                Widget errorIcon = const SizedBox();
                if (kDebugMode) {
                  print(
                    'MESSAGE ${state.message}',
                  );
                }
                if (state.message == AppMessagesEnum.wifiError.key) {
                  errorIcon = const Icon(
                    Icons.signal_wifi_connected_no_internet_4_rounded,
                    size: 120,
                  );
                  return Column(
                    spacing: 10,
                    children: [
                      Expanded(
                        child: Center(child: errorIcon),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 30),
                        child: Text(
                          state.message,
                          style: kbodyLarge.copyWith(color: kSecondaryColor),
                        ),
                      ),
                    ],
                  );
                }
                if (state.message.contains(AppMessagesEnum.cacheEmpty.key)) {
                  errorIcon = const Icon(
                    Icons.sd_card_alert_outlined,
                    size: 120,
                  );
                  return Column(
                    children: [
                      Expanded(
                        child: Center(
                          child: Text(
                            'OBS Disconnected...',
                            style: kheadlineLarge,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsetsGeometry.symmetric(vertical: 30),
                        child: GoToSettingPageButton(),
                      ),
                    ],
                  );
                }
                if (state.message.contains(AppMessagesEnum.cacheEmpty.key) ||
                    state.message == AppMessagesEnum.connectionRefused.key) {
                  return Column(
                    children: [
                      Expanded(
                        child: Center(
                          child: Text(
                            'OBS \nDisconnected...',
                            style: kheadlineLarge,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsetsGeometry.symmetric(vertical: 30),
                        child: GoToSettingPageButton(),
                      ),
                    ],
                  );
                }
              }
              if (kDebugMode) {
                print('NO ERROR MESSAGE $state');
              }

              /// Liste des pages
              final List<Widget> pages = [
                const OBSListScenes(
                  key: ValueKey<String>('List Of Scenes'),
                ),
                CurrentSceneSelector(
                  value: (String sceneName) => OBSListSources(
                    currentSceneName: sceneName,
                    key: const ValueKey<String>('List Of Sources'),
                  ),
                ),
              ];
              return Padding(
                padding: const EdgeInsets.all(16),
                child: BlocBuilder<ServerBloc, ServerState>(
                  builder: (BuildContext context, ServerState state) {
                    if (kDebugMode) {
                      print('OBSLayoutDefault - $state');
                    }
                    switch (state) {
                      case ServerIsConnected():

                        /// Important. Lance l'écoute des events.
                        _listenEvent(context);

                        return Row(
                          children: [
                            const Expanded(
                              child: OBSActionButtons(
                                key: ValueKey<String>('Actions Buttons'),
                              ),
                            ),

                            const VerticalDivider(),
                            Expanded(
                              flex: 2,
                              child: Stack(
                                children: [
                                  PageView.custom(
                                    controller: pageController,
                                    onPageChanged: (pageIndex) {
                                      if (pageIndex == 0) {
                                        context.read<TitleBloc>().add(TitleChanged(title: AppText.scenes.label));
                                      } else if (pageIndex == 1) {
                                        context.read<TitleBloc>().add(TitleChanged(title: AppText.sources.label));
                                      } else {
                                        context.read<TitleBloc>().add(const TitleChanged(title: 'NO_TITLE'));
                                      }
                                    },
                                    childrenDelegate: SliverChildBuilderDelegate(
                                      (_, int pageIndex) {
                                        final Widget page = pages[pageIndex];

                                        return page;
                                      },
                                      childCount: pages.length,
                                    ),
                                  ),

                                  /// TITLE
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: kPrimaryColor,
                                        boxShadow: [
                                          BoxShadow(
                                            offset: Offset(-10, -10),
                                            color: kButtonColor,
                                            blurRadius: 60,
                                          ),
                                        ],
                                      ),
                                      child: TitleSelector(
                                        value: (String title) => Text(
                                          title,
                                          style: Theme.of(context).textTheme.headlineMedium,
                                        ),
                                      ),
                                    ),
                                  ),

                                  /// Arrow
                                  Align(
                                    child: TitleSelector(
                                      value: (String title) {
                                        if (title == AppText.scenes.label) {
                                          return Align(
                                            alignment: Alignment.centerRight,
                                            child: AnimatedArrow(
                                              onTap: () {
                                                pageController.animateToPage(
                                                  1,
                                                  duration: const Duration(milliseconds: 500),
                                                  curve: Curves.easeInOut,
                                                );
                                              },
                                              icon: Icons.keyboard_arrow_right_rounded,
                                            ),
                                          );
                                        } else if (title == AppText.sources.label) {
                                          return Align(
                                            alignment: Alignment.centerLeft,
                                            child: AnimatedArrow(
                                              onTap: () {
                                                pageController.animateToPage(
                                                  0,
                                                  duration: const Duration(milliseconds: 500),
                                                  curve: Curves.easeInOut,
                                                );
                                              },
                                              icon: Icons.keyboard_arrow_left_rounded,
                                            ),
                                          );
                                        } else {
                                          return const SizedBox();
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      case ServerIsLoading():
                        return const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          spacing: 10,
                          children: [
                            Center(child: CircularProgressIndicator(padding: EdgeInsetsGeometry.all(20))),
                            Text('Loading...', style: TextStyle(color: kTextShadow)),
                          ],
                        );

                      default:
                        return Center(
                          child: Text(state.toString()),
                        );
                    }
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _listenEvent(BuildContext context) async {
    final ObsWebSocket? obsWebSocket = await OBSSingleton().obs;
    if (obsWebSocket != null) {
      obsWebSocket.addFallbackListener((Event event) => ServerRepository().fallBackEvent(event, context));
    }
  }
}
