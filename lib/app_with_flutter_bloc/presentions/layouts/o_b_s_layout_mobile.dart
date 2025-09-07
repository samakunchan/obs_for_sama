import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:obs_for_sama/app_with_flutter_bloc/features/cache/listeners/cache_listener.dart';
import 'package:obs_for_sama/app_with_flutter_bloc/features/error/bloc/error_bloc.dart';
import 'package:obs_for_sama/app_with_flutter_bloc/features/messages/enums/messages_enum.dart';
import 'package:obs_for_sama/app_with_flutter_bloc/features/server/bloc/server_bloc.dart';
import 'package:obs_for_sama/app_with_flutter_bloc/features/server/listeners/server_listener.dart';
import 'package:obs_for_sama/app_with_flutter_bloc/features/server/repositories/server_repository.dart';
import 'package:obs_for_sama/app_with_flutter_bloc/features/server/singleton/o_b_s_singleton.dart';
import 'package:obs_for_sama/app_with_flutter_bloc/features/title/bloc/title_bloc.dart';
import 'package:obs_for_sama/app_with_flutter_bloc/features/title/selectors/title_selector.dart';
import 'package:obs_for_sama/app_with_flutter_bloc/presentions/widgets/go_to_setting_page_button.dart';
import 'package:obs_for_sama/app_with_flutter_bloc/presentions/widgets/o_b_s_action_buttons_mobile.dart';
import 'package:obs_for_sama/app_with_flutter_bloc/presentions/widgets/o_b_s_list_scenes.dart';
import 'package:obs_for_sama/core/index.dart';
import 'package:obs_websocket/obs_websocket.dart';

class OBSLayoutMobile extends StatelessWidget {
  const OBSLayoutMobile({super.key});

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    final EdgeInsets safeAreaPadding = mediaQuery.padding;
    final double screenHeight = mediaQuery.size.height;
    final double availableHeight = screenHeight - safeAreaPadding.top - safeAreaPadding.bottom;

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
                  errorIcon = const Icon(Icons.signal_wifi_connected_no_internet_4_rounded);
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
                  errorIcon = const Icon(Icons.sd_card_alert_outlined);
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
              }
              if (kDebugMode) {
                print('NO ERROR MESSAGE $state');
              }

              /// Liste des pages
              final List<Widget> pages = [
                const OBSListScenes(
                  key: ValueKey<String>('List Of Scenes'),
                ),
                const SizedBox(
                  key: ValueKey<String>('Placeholder'),
                ),
              ];
              return SizedBox(
                height: availableHeight * .95,
                child: Padding(
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
                              PageView.custom(
                                onPageChanged: (pageIndex) {
                                  if (pageIndex == 0) {
                                    context.read<TitleBloc>().add(TitleChanged(title: AppText.scenes.label));
                                  } else if (pageIndex == 1) {
                                    context.read<TitleBloc>().add(TitleChanged(title: AppText.sources.label));
                                  } else {
                                    context.read<TitleBloc>().add(const TitleChanged(title: 'OUT_OF_TITLE'));
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

                              /// ACTIONS BOUTONS
                              Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  /// Titre
                                  Row(
                                    children: [
                                      ColoredBox(
                                        color: kPrimaryColor,
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
