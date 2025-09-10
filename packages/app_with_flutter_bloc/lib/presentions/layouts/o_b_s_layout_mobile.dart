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
import '../widgets/o_b_s_action_buttons_mobile.dart';
import '../widgets/o_b_s_list_scenes.dart';
import '../widgets/o_b_s_list_sources.dart';

class OBSLayoutMobile extends StatelessWidget {
  const OBSLayoutMobile({super.key});

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
                if (state.message.contains(AppMessagesEnum.wifiError.key)) {
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
                if (state.message.contains(AppMessagesEnum.cacheEmpty.key) ||
                    state.message.contains(AppMessagesEnum.connectionRefused.key) ||
                    state.message.contains(AppMessagesEnum.serverError.key)) {
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
                      print('OBSLayoutMobileBloc - $state');
                    }
                    switch (state) {
                      case ServerIsConnected():

                        /// Important. Lance l'écoute des events.
                        _listenEvent(context);

                        return Stack(
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * .6,
                              child: PageView.custom(
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
                            ),

                            /// ACTIONS BOUTONS
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                /// Titre
                                Row(
                                  children: [
                                    Container(
                                      decoration: const BoxDecoration(
                                        color: kPrimaryColor,
                                        boxShadow: [
                                          BoxShadow(
                                            offset: Offset(5, -5),
                                            color: kButtonColor,
                                            blurRadius: 30,
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
                                  ],
                                ),
                                const Divider(height: 0),

                                const ColoredBox(
                                  color: kPrimaryColor,
                                  child: OBSActionButtonsMobile(
                                    key: ValueKey<String>('Page Mobile View'),
                                  ),
                                ),
                              ],
                            ),

                            /// Arrow
                            TitleSelector(
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
