import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:obs_for_sama/app_with_flutter_bloc/core/routes.dart';
import 'package:obs_for_sama/app_with_flutter_bloc/features/cache/bloc/cache_bloc.dart';
import 'package:obs_for_sama/app_with_flutter_bloc/features/cache/models/o_b_s_model.dart';
import 'package:obs_for_sama/app_with_flutter_bloc/features/cache/repositories/cache_repository.dart';
import 'package:obs_for_sama/app_with_flutter_bloc/features/error/bloc/error_bloc.dart';
import 'package:obs_for_sama/app_with_flutter_bloc/features/server/bloc/server_bloc.dart';
import 'package:obs_for_sama/app_with_flutter_bloc/features/server/repositories/server_repository.dart';
import 'package:obs_for_sama/app_with_flutter_bloc/features/sound/bloc/sound_bloc.dart';
import 'package:obs_for_sama/core/index.dart';
import 'package:obs_websocket/obs_websocket.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class ProjectApp extends StatelessWidget {
  const ProjectApp({super.key});

  @override
  Widget build(BuildContext context) {
    // final Future<OBSManagerModel> manager = YoloRepo(context).managerDatas();
    return MultiBlocProvider(
      providers: [
        BlocProvider<CacheBloc>(create: (_) => CacheBloc()),
        BlocProvider<ErrorBloc>(create: (_) => ErrorBloc()),
        BlocProvider<ServerBloc>(create: (_) => ServerBloc()..add(ServerConnected())),
        // BlocProvider<SoundBloc>(create: (_) => SoundBloc(manager: manager)..add(SoundConfigured())),
      ],
      child: MaterialApp(
        key: const ValueKey<String>('Material Flutter Bloc'),
        theme: kThemeData,
        locale: const Locale('en', 'US'),
        initialRoute: '/',
        onGenerateRoute: Routes.generateRoute,
      ),
      // child: Builder(
      //   builder: (context1) {
      //     // yolo(manager, context1);
      //
      //     // context1.read<CacheBloc>().add(const CacheInspectionCredentials());
      //     return MaterialApp(
      //       key: const ValueKey<String>('Material Flutter Bloc'),
      //       theme: kThemeData,
      //       locale: const Locale('en', 'US'),
      //       initialRoute: '/dzd',
      //       onGenerateRoute: Routes.generateRoute,
      //     );
      //   },
      // ),
    );
  }

  Future<void> yolo(Future<OBSManagerModel> manager, BuildContext context) async {
    final OBSManagerModel aaa = await manager;
    aaa.obsWebSocket.addFallbackListener((Event event) => YoloRepo(context).fallBackEvent(event));
  }
}

//             return MaterialApp(
//               theme: kThemeData,
//               home: Scaffold(
//                 body: SafeArea(
//                   child: Column(
//                     children: [
//                       Expanded(
//                         child: Center(
//                           child: Icon(
//                             state.message == AppMessagesEnum.serverError.key
//                                 ? Icons.dataset_linked_outlined
//                                 : Icons.error,
//                           ),
//                         ),
//                       ),
//                       const OBSServerConnectionButton(),
//                     ],
//                   ),
//                 ),
//               ),
//             );
class OBSManagerModel {
  OBSManagerModel({
    required this.serverRepository,
    required this.obsWebSocket,
  });

  final ServerRepository serverRepository;
  final ObsWebSocket obsWebSocket;
}

class YoloRepo {
  const YoloRepo(this.context);

  final BuildContext context;

  Future<OBSManagerModel> managerDatas() async {
    final OBSModel obsModel = await CacheRepository.instance.obdModel;
    if (kDebugMode) {
      print(obsModel.toJson());
    }

    if (kDebugMode) {
      print('Lancement de ManagerDatas');
    }

    // Attend que la connexion soit établie
    final ObsWebSocket obs = await ObsWebSocket.connect(
      'ws://${obsModel.localIp}:${obsModel.localPort}',
      password: obsModel.localPassword,
    );

    final ServerRepository serverRepository = ServerRepository();

    await serverRepository.connectToOBS();
    return OBSManagerModel(
      serverRepository: serverRepository,
      obsWebSocket: obs,
    );
  }

  Future<void> fallBackEvent(Event event) async {
    // final SoundController soundController = Get.find();
    // final ScenesController scenesController = Get.find();
    // print('type: ${event.eventType} data: ${event.eventData}');
    if (kDebugMode) {
      print('On est dans le fallback');
    }
    if (event.eventType == 'CurrentProgramSceneChanged') {
      // await _obs?.scenes.setCurrentProgramScene(event.eventData!['sceneName'].toString());
      // final String currentScene = await _obs?.scenes.getCurrentProgramScene() ?? 'no scene';
      // scenesController.currentSceneName.value = currentScene;

      // final SourcesController sourcesController = Get.put(SourcesController());
      // await sourcesController.getListSourcesByCurrentScene();
    }

    if (event.eventType == 'InputMuteStateChanged') {
      // TODO Changer le nom de SoundInitialized, il ne se lance pas à l'initialisation
      context.read<SoundBloc>().add(SoundInitialized(isSoundMuted: event.eventData!['inputMuted'] as bool));
      // soundController.isSoundMuted.value = event.eventData!['inputMuted'] as bool;
    }

    if (event.eventType == 'StreamStateChanged') {
      StatusStream statusStream = StatusStream.stopped;
      if (event.eventData!['outputState'].toString() == 'OBS_WEBSOCKET_OUTPUT_STARTING') {
        statusStream = StatusStream.isStarting;
      }
      if (event.eventData!['outputState'].toString() == 'OBS_WEBSOCKET_OUTPUT_STARTED') {
        statusStream = StatusStream.started;
        await WakelockPlus.enable();
      }
      if (event.eventData!['outputState'].toString() == 'OBS_WEBSOCKET_OUTPUT_STOPPING') {
        statusStream = StatusStream.isStopping;
      }
      if (event.eventData!['outputState'].toString() == 'OBS_WEBSOCKET_OUTPUT_STOPPED') {
        statusStream = StatusStream.stopped;
      }
      // isStreamOnline(status: statusStream);
    }
  }
}
