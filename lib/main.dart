import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:obs_for_sama/core/clippers.dart';
import 'package:obs_for_sama/core/constantes.dart';
import 'package:obs_for_sama/widgets/error_message_screen.dart';
import 'package:obs_for_sama/widgets/r_s_i_button.dart';
import 'package:obs_for_sama/widgets/r_s_i_button_outlined.dart';
import 'package:obs_websocket/obs_websocket.dart';
import 'package:obs_websocket/request.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String ip = 'IP';
const String port = 'Port';
const String password = 'Password';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const OBSControlPage(),
      theme: kThemeData,
    );
  }
}

class OBSControlPage extends StatefulWidget {
  const OBSControlPage({super.key});

  @override
  _OBSControlPageState createState() => _OBSControlPageState();
}

class _OBSControlPageState extends State<OBSControlPage> {
  ObsWebSocket? _obsWebSocket;
  String _obsStatusMessage = 'Loading...';
  bool _isStreamOnline = false;
  bool _isOBSSynchronized = false;
  bool _isMuted = false;
  String _currentSceneName = 'Inconnue';
  late List<Scene> _scenes = List.empty(growable: true);
  late List<SceneItemDetail> _sources = List.empty(growable: true);
  final _formKey = GlobalKey<FormState>();
  late TextEditingController textEditingControllerIp;
  late TextEditingController textEditingControllerPort;
  late TextEditingController textEditingControllerPassword;
  late final Future<SharedPreferencesWithCache> prefsWithCache;
  late SharedPreferencesWithCache cache;

  @override
  void initState() {
    prefsWithCache = SharedPreferencesWithCache.create(
      cacheOptions: const SharedPreferencesWithCacheOptions(
        allowList: <String>{ip, port, password},
      ),
    );
    _connectToOBS();

    textEditingControllerIp = TextEditingController();
    textEditingControllerPort = TextEditingController();
    textEditingControllerPassword = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    textEditingControllerIp.dispose();
    textEditingControllerPort.dispose();
    textEditingControllerPassword.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    listenScenesFromOBS();
    // TODO a instancier dans un widget leaf isolé pour voir si ça marche.
    // listenVolumeFromOBS();

    final mediaQuery = MediaQuery.of(context);
    final safeAreaPadding = mediaQuery.padding;
    final screenHeight = mediaQuery.size.height;
    final availableHeight = screenHeight - safeAreaPadding.top - safeAreaPadding.bottom;

    return Scaffold(
      appBar: AppBar(title: const Center(child: Text('OBS MANAGER'))),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          if (constraints.maxWidth < 600) {
            return OrientationBuilder(
              builder: (BuildContext context, Orientation orientation) {
                switch (orientation) {
                  case Orientation.portrait:
                  case Orientation.landscape:
                    return buildSafeAreaMobile(availableHeight, context);
                }
              },
            );
          } else {
            return OrientationBuilder(
              builder: (BuildContext context, Orientation orientation) {
                switch (orientation) {
                  case Orientation.portrait:
                  case Orientation.landscape:
                    return buildSafeArea(availableHeight, context);
                }
              },
            );
          }
        },
      ),
    );
  }

  SafeArea buildSafeArea(double availableHeight, BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: SizedBox(
          height: availableHeight * .95,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                /// BOUTONS
                showActionButtons(context),
                const VerticalDivider(),
                if (_isOBSSynchronized)
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// SCENES
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                /// Titre
                                Row(
                                  children: [
                                    Text(
                                      'SCENES',
                                      style: Theme.of(context).textTheme.headlineMedium,
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Wrap(
                                    spacing: 20,
                                    runSpacing: 10,
                                    children: List.generate(_scenes.length, (int index) {
                                      return RSIButton(
                                        edgeClipper: const RSIEdgeClipper(edgeRightTop: true, edgeLeftBottom: true),
                                        width: 150,
                                        height: 150,
                                        onTap: () => _changeScene(scene: _scenes[index]),
                                        color: _currentSceneName == _scenes[index].sceneName
                                            ? Theme.of(context).colorScheme.tertiary
                                            : Theme.of(context).colorScheme.primaryContainer,
                                        text: _scenes[index].sceneName,
                                      );
                                    }),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const VerticalDivider(),

                        /// SOURCES
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                /// Titre
                                Row(
                                  children: [
                                    Text(
                                      'SOURCES',
                                      style: Theme.of(context).textTheme.headlineMedium,
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Wrap(
                                    spacing: 20,
                                    runSpacing: 10,
                                    children: List.generate(_sources.length, (int index) {
                                      return !_sources[index].sceneItemEnabled
                                          ? RSIButtonOutlined(
                                              edgeClipper: const RSIEdgeClipper(edgeRightTop: true, edgeLeftBottom: true),
                                              width: 150,
                                              height: 150,
                                              onTap: () => _toogleActiveSource(source: _sources[index]),
                                              color: Theme.of(context).colorScheme.shadow,
                                              text: _sources[index].sourceName,
                                            )
                                          : RSIButton(
                                              edgeClipper: const RSIEdgeClipper(edgeRightTop: true, edgeLeftBottom: true),
                                              width: 150,
                                              height: 150,
                                              onTap: () => _toogleActiveSource(source: _sources[index]),
                                              text: _sources[index].sourceName,
                                            );
                                    }),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )

                /// Error message
                else
                  ErrorMessageScreen(message: _obsStatusMessage),
              ],
            ),
          ),
        ),
      ),
    );
  }

  SafeArea buildSafeAreaMobile(double availableHeight, BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: SizedBox(
          height: availableHeight * .95,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const VerticalDivider(),
                if (_isOBSSynchronized)
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// SCENES
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// Titre
                              Text(
                                'SCENES',
                                style: Theme.of(context).textTheme.headlineMedium,
                              ),
                              Expanded(
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(16),
                                        child: Wrap(
                                          spacing: 20,
                                          runSpacing: 10,
                                          children: List.generate(_scenes.length, (int index) {
                                            return RSIButton(
                                              edgeClipper: const RSIEdgeClipper(edgeRightTop: true, edgeLeftBottom: true),
                                              width: 150,
                                              height: 150,
                                              onTap: () => _changeScene(scene: _scenes[index]),
                                              color: _currentSceneName == _scenes[index].sceneName
                                                  ? Theme.of(context).colorScheme.tertiary
                                                  : Theme.of(context).colorScheme.primaryContainer,
                                              text: _scenes[index].sceneName,
                                            );
                                          }),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const VerticalDivider(),

                        /// SOURCES
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// Titre
                              Text(
                                'SOURCES',
                                style: Theme.of(context).textTheme.headlineMedium,
                              ),
                              Expanded(
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(16),
                                        child: Wrap(
                                          spacing: 20,
                                          runSpacing: 10,
                                          // crossAxisAlignment: CrossAxisAlignment.start,
                                          children: List.generate(_sources.length, (int index) {
                                            return !_sources[index].sceneItemEnabled
                                                ? RSIButtonOutlined(
                                                    edgeClipper: const RSIEdgeClipper(edgeRightTop: true, edgeLeftBottom: true),
                                                    width: 150,
                                                    height: 150,
                                                    onTap: () => _toogleActiveSource(source: _sources[index]),
                                                    color: Theme.of(context).colorScheme.shadow,
                                                    text: _sources[index].sourceName,
                                                  )
                                                : RSIButton(
                                                    edgeClipper: const RSIEdgeClipper(edgeRightTop: true, edgeLeftBottom: true),
                                                    width: 150,
                                                    height: 150,
                                                    onTap: () => _toogleActiveSource(source: _sources[index]),
                                                    text: _sources[index].sourceName,
                                                  );
                                          }),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )

                /// Error message
                else
                  ErrorMessageScreen(message: _obsStatusMessage),

                /// BOUTONS
                showActionButtonsMobile(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// ACTION BUTTONS
  Column showActionButtons(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            if (_isOBSSynchronized)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Titre
                  Text(
                    'PLAY YOUR WAY',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (_isStreamOnline)
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: RSIButtonOutlined(
                              color: Colors.red,
                              onTap: _stopStreaming,
                              edgeClipper: const RSIEdgeClipper(edgeRightTop: true, edgeLeftBottom: true),
                              text: 'STOP',
                            ),
                          )
                        else
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: RSIButtonOutlined(
                              onTap: _startStreaming,
                              edgeClipper: const RSIEdgeClipper(edgeRightTop: true, edgeLeftBottom: true),
                              text: 'START',
                            ),
                          ),
                        const SizedBox(width: 200, child: Divider(height: 50)),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: RSIButtonOutlined(
                            onTap: _reload,
                            edgeClipper: const RSIEdgeClipper(edgeRightTop: true, edgeLeftBottom: true),
                            child: Icon(
                              Icons.refresh,
                              size: 40,
                              color: Theme.of(context).colorScheme.outline,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: RSIButtonOutlined(
                            onTap: _toogleMuteVolume,
                            edgeClipper: const RSIEdgeClipper(edgeRightTop: true, edgeLeftBottom: true),
                            child: _isMuted
                                ? Icon(
                                    Icons.volume_off,
                                    size: 40,
                                    color: Theme.of(context).colorScheme.outline,
                                  )
                                : Icon(
                                    Icons.volume_up_sharp,
                                    size: 40,
                                    color: Theme.of(context).colorScheme.outline,
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 200, child: Divider(height: 50)),
                ],
              )
            else
              Column(
                children: [
                  /// Titre
                  Text(
                    'PLAY YOUR WAY',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ],
              ),
          ],
        ),

        /// OBS BUTTONS FOOTER
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Column(
              children: [
                const SizedBox(width: 200, child: Divider(height: 50)),

                /// OBS SETTINGS
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: RSIButtonOutlined(
                    onTap: () async {
                      await showDialog<dynamic>(
                        context: context,
                        builder: _showDialog,
                      ).then((value) {
                        setCache();
                      });
                    },
                    edgeClipper: const RSIEdgeClipper(edgeRightTop: true, edgeLeftBottom: true),
                    child: Icon(
                      Icons.settings,
                      size: 40,
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                ),

                /// OBS CONNECTION
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: RSIButtonOutlined(
                    onTap: _connectToOBS,
                    edgeClipper: const RSIEdgeClipper(edgeRightTop: true, edgeLeftBottom: true),
                    text: 'CONNECT OBS',
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Padding showActionButtonsMobile(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              if (_isOBSSynchronized)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Titre
                    Text(
                      'PLAY YOUR WAY',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          /// CONNECT OBS
                          Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: RSIButtonOutlined(
                                    onTap: _connectToOBS,
                                    edgeClipper: const RSIEdgeClipper(edgeRightTop: true, edgeLeftBottom: true),
                                    text: 'CONNECT OBS',
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: RSIButtonOutlined(
                                    onTap: () async {
                                      await showDialog<dynamic>(
                                        context: context,
                                        builder: _showDialog,
                                      ).then((_) {
                                        setCache();
                                      });
                                    },
                                    edgeClipper: const RSIEdgeClipper(edgeRightTop: true, edgeLeftBottom: true),
                                    child: Icon(
                                      Icons.settings,
                                      size: 40,
                                      color: Theme.of(context).colorScheme.outline,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: RSIButtonOutlined(
                                    onTap: _reload,
                                    edgeClipper: const RSIEdgeClipper(edgeRightTop: true, edgeLeftBottom: true),
                                    child: Icon(
                                      Icons.refresh,
                                      size: 40,
                                      color: Theme.of(context).colorScheme.outline,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: RSIButtonOutlined(
                                    onTap: _toogleMuteVolume,
                                    edgeClipper: const RSIEdgeClipper(
                                      edgeRightTop: true,
                                      edgeLeftBottom: true,
                                    ),
                                    child: _isMuted
                                        ? Icon(
                                            Icons.volume_off,
                                            size: 40,
                                            color: Theme.of(context).colorScheme.outline,
                                          )
                                        : Icon(
                                            Icons.volume_up_sharp,
                                            size: 40,
                                            color: Theme.of(context).colorScheme.outline,
                                          ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    /// OBS BUTTONS FOOTER
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            /// OBS SETTINGS
                            Expanded(
                              child: _isStreamOnline
                                  ? Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: RSIButtonOutlined(
                                        color: Colors.red,
                                        onTap: _stopStreaming,
                                        edgeClipper: const RSIEdgeClipper(edgeRightTop: true, edgeLeftBottom: true),
                                        text: 'STOP',
                                      ),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: RSIButtonOutlined(
                                        onTap: _startStreaming,
                                        edgeClipper: const RSIEdgeClipper(edgeRightTop: true, edgeLeftBottom: true),
                                        text: 'START',
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                )
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    /// CONNECT OBS
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: RSIButtonOutlined(
                              onTap: _connectToOBS,
                              edgeClipper: const RSIEdgeClipper(edgeRightTop: true, edgeLeftBottom: true),
                              text: 'CONNECT OBS',
                            ),
                          ),
                        ),
                      ],
                    ),

                    /// OBS SETTINGS
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: RSIButtonOutlined(
                        onTap: () async {
                          await showDialog<dynamic>(
                            context: context,
                            builder: _showDialog,
                          ).then((value) {
                            setCache();
                          });
                        },
                        edgeClipper: const RSIEdgeClipper(edgeRightTop: true, edgeLeftBottom: true),
                        child: Icon(
                          Icons.settings,
                          size: 40,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }

  /// DIALOG
  Widget _showDialog(BuildContext context) {
    return CupertinoAlertDialog(
      title: const Text('Server parameters'),
      content: Column(
        children: [
          Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: CupertinoTextField(
                    controller: textEditingControllerIp,
                    placeholder: '192.XXX.XXX.XXX',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: CupertinoTextField(
                    controller: textEditingControllerPort,
                    placeholder: '1234',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: CupertinoTextField(
                    obscureText: true,
                    controller: textEditingControllerPassword,
                    placeholder: 'OBS Websocket Password',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: <CupertinoDialogAction>[
        CupertinoDialogAction(
          onPressed: () => Navigator.of(context).pop(),
          child: const Icon(Icons.cancel),
        ),
        CupertinoDialogAction(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Navigator.of(context).pop();
            }
          },
          child: const Icon(Icons.check),
        ),
      ],
    );
  }

  Future<void> listenScenesFromOBS() async {
    // await _obsWebSocket?.listen(EventSubscription.all.code);
    // await _obsWebSocket?.listen(EventSubscription.inputs.code);
    await _obsWebSocket?.listen(EventSubscription.scenes.code);
  }

  Future<void> listenVolumeFromOBS() async {
    // await _obsWebSocket?.listen(EventSubscription.all.code);
    await _obsWebSocket?.listen(EventSubscription.inputs.code);
    // await _obsWebSocket?.listen(EventSubscription.scenes.code);
  }

  Future<void> _connectToOBS() async {
    print('je lance la connexion à OBS.');
    try {
      await _getLocalDataForSettings();
      _obsWebSocket = await ObsWebSocket.connect(
        'ws://${textEditingControllerIp.text}:${textEditingControllerPort.text}',
        password: textEditingControllerPassword.text,
        fallbackEventHandler: (Event event) async {
          print('type: ${event.eventType} data: ${event.eventData}');
          if (event.eventType == 'CurrentProgramSceneChanged') {
            await _obsWebSocket?.scenes.setCurrentProgramScene(event.eventData!['sceneName'].toString());
            final String currentScene = await _obsWebSocket?.scenes.getCurrentProgramScene() ?? 'no scene';
            setState(() {
              _currentSceneName = currentScene;
            });
            await _getListSources();
          }

          if (event.eventType == 'InputMuteStateChanged') {
            setState(() {
              _isMuted = event.eventData!['inputMuted'] as bool;
            });
          }
        },
      );
      final ProfileListResponse? defaultProfile = await _obsWebSocket?.config.getProfileList();

      if (defaultProfile != null && defaultProfile.currentProfileName.isNotEmpty) {
        await _reload();
        setState(() {
          _isOBSSynchronized = true;
        });
      }
    } catch (e) {
      setState(() {
        // _obsStatusMessage = 'Erreur de connexion: \n$e';
        _obsStatusMessage = 'OBS Disconnected...';
        _isOBSSynchronized = false;
      });
    }
  }

  Future<void> _toogleMuteVolume() async {
    const String inputName = 'Mic/Aux';
    final Inputs? inputs = _obsWebSocket?.inputs;
    await inputs?.toggleMute(inputName);
    final bool? isMuted = await inputs?.getMute(inputName);
    setState(() {
      _isMuted = isMuted ?? false;
    });
  }

  Future<void> _getStatusVolume() async {
    const String inputName = 'Mic/Aux';
    final Inputs? inputs = _obsWebSocket?.inputs;
    final bool? isMuted = await inputs?.getMute(inputName);
    setState(() {
      _isMuted = isMuted ?? false;
    });
  }

  Future<void> _showStreamStatus(StreamStatusResponse response) async {
    setState(() {
      _isStreamOnline = response.outputActive;
    });
  }

  Future<void> _getCurrentScene() async {
    try {
      final String? response = await _obsWebSocket?.scenes.getCurrentProgramScene();
      setState(() {
        _currentSceneName = response ?? 'Inconnue';
      });
    } catch (e) {
      _obsStatusMessage = 'Erreur lors de la récupération de la scène : $e';
    }
  }

  Future<void> _reload() async {
    await _getListScenes();
    await _getLocalDataForSettings();
    await _getStatusVolume();
    await _getListSources();
    await _getCurrentScene();
    await _obsWebSocket?.stream.status.then(_showStreamStatus);
  }

  Future<void> _getLocalDataForSettings() async {
    cache = await prefsWithCache;
    final String? localIp = cache.getString(ip);
    final String? localPort = cache.getString(port);
    final String? localPassword = cache.getString(password);
    if (localIp != null && localPort != null && localPassword != null) {
      // print('Détection des données locales.');
      textEditingControllerIp = TextEditingController(text: localIp);
      textEditingControllerPort = TextEditingController(text: localPort);
      textEditingControllerPassword = TextEditingController(text: localPassword);
    } else {
      // print('Les données locales n‘ont pas été trouvés');
      _obsStatusMessage = 'OBS Disconnected...';
      _isOBSSynchronized = false;
    }
  }

  Future<void> _startStreaming() async {
    try {
      await _obsWebSocket?.stream.start().then((value) async {
        setState(() {
          _isStreamOnline = true;
        });
      });
    } catch (e) {
      _obsStatusMessage = 'Erreur lors du démarrage du streaming : $e';
    }
  }

  Future<void> _stopStreaming() async {
    try {
      await _obsWebSocket?.stream.stop().then((_) async {
        setState(() {
          _isStreamOnline = false;
        });
      });
    } catch (e) {
      _obsStatusMessage = 'Erreur lors de l‘arrêt du streaming : $e';
    }
  }

  Future<void> _changeScene({required Scene scene}) async {
    await _obsWebSocket?.scenes.setCurrentProgramScene(scene.sceneName);
    final String currentScene = await _obsWebSocket?.scenes.getCurrentProgramScene() ?? 'no scenes';
    setState(() {
      _currentSceneName = currentScene;
    });
    await _getListSources();
  }

  Future<void> _toogleActiveSource({required SceneItemDetail source}) async {
    final SceneItemEnableStateChanged sceneItemEnableStateChanged = SceneItemEnableStateChanged(
      sceneName: _currentSceneName,
      sceneItemId: source.sceneItemId,
      sceneItemEnabled: !source.sceneItemEnabled,
    );

    await _obsWebSocket?.sceneItems.setSceneItemEnabled(sceneItemEnableStateChanged);
    await _getListSources();
  }

  Future<void> _getListScenes() async {
    final SceneListResponse? response = await _obsWebSocket?.scenes.getSceneList();
    if (response != null) {
      setState(() {
        _scenes = response.scenes.reversed.toList();
        _currentSceneName = response.currentProgramSceneName;
      });
    }
  }

  Future<void> _getListSources() async {
    final List<SceneItemDetail> details = await _obsWebSocket?.sceneItems.getSceneItemList(_currentSceneName) ?? [];
    setState(() {
      _sources = details.reversed.toList();
    });
  }

  Future<void> setCache() async {
    await cache.setString(ip, textEditingControllerIp.text);
    await cache.setString(port, textEditingControllerPort.text);
    await cache.setString(password, textEditingControllerPassword.text);
  }
}

/// Detecter le cable USB - C
/// Faire le formulaire android
/// Statemanager getX
