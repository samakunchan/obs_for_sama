import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:obs_for_sama/core/themes/color_scheme.dart';
import 'package:obs_for_sama/features/cache/bloc/cache_bloc.dart';
import 'package:obs_for_sama/features/error/bloc/error_bloc.dart';
import 'package:obs_for_sama/features/messages/enums/messages_enum.dart';
import 'package:obs_for_sama/features/server/bloc/server_bloc.dart';
import 'package:obs_for_sama/presention_with_bloc/index.dart';

class OBSLayoutMobileBloc extends StatelessWidget {
  const OBSLayoutMobileBloc({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final safeAreaPadding = mediaQuery.padding;
    final screenHeight = mediaQuery.size.height;
    final availableHeight = screenHeight - safeAreaPadding.top - safeAreaPadding.bottom;

    return MultiBlocListener(
      listeners: [
        BlocListener<ServerBloc, ServerState>(
          listener: (BuildContext context, ServerState state) {
            if (state is ServerHasError) {
              print('Serveur à une érreur : ${state.message}');
              context.read<ErrorBloc>().add(ErrorEmitted(message: state.message));
            }
          },
          child: BlocListener<CacheBloc, CacheState>(
            listener: (BuildContext context, CacheState state) {
              if (state is CacheHasError) {
                context.read<ErrorBloc>().add(ErrorEmitted(message: state.message));
              }
            },
          ),
        ),
      ],
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
              }
              if (state.message.contains(AppMessagesEnum.cacheEmpty.key)) {
                errorIcon = const Icon(Icons.sd_card_alert_outlined);
              }
              return Column(
                children: [
                  Expanded(
                    child: Center(child: errorIcon),
                  ),
                  const OBSServerConnectionButton(),
                ],
              );
            }
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
                        return const Column(
                          children: [
                            VerticalDivider(),
                            Expanded(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('On est sur la bonne voie'),
                                  // /// SCENES
                                  // OBSListScenes(
                                  //   key: ValueKey<String>('List Of Scenes'),
                                  // ),
                                  // VerticalDivider(),
                                  //
                                  // /// SOURCES
                                  // OBSListSources(
                                  //   key: ValueKey<String>('List Of Sources'),
                                  // ),
                                ],
                              ),
                            ),

                            /// ACTIONS BOUTONS
                            OBSActionButtonsMobileBloc(
                              key: ValueKey<String>('Page Mobile View'),
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
                      // case ServerHasError():
                      //   return Text(
                      //     state.message,
                      //     style: const TextStyle(color: Colors.white),
                      //   );
                      // return ErrorMessageScreen(message: state.message);
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
    );
  }
}
