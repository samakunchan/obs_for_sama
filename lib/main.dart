import 'dart:io';

import 'package:app_with_flutter_bloc/app_with_flutter_bloc.dart';
import 'package:app_with_get_x/app_with_get_x.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // For more long splash screen.
  // final WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  // Timer(const Duration(seconds: 5), FlutterNativeSplash.remove);
  // runApp(const MyApp());
  if (appFlavor == 'getx') {
    runApp(const MyApp());
    if (Platform.isWindows) {
      doWhenWindowReady(() {
        final win = appWindow;
        const Size minSize = Size(800, 600);
        const Size launcherSize = Size(1200, 800);

        win
          ..minSize = minSize
          ..size = launcherSize
          ..alignment = Alignment.center
          ..title = 'OBS Manager - v0.18.0'
          ..show();
      });
    }
    return;
  } else if (appFlavor == 'bloc') {
    runApp(const ProjectApp());
    if (Platform.isWindows) {
      doWhenWindowReady(() {
        final win = appWindow;
        const Size minSize = Size(800, 600);
        const Size launcherSize = Size(1200, 800);

        win
          ..minSize = minSize
          ..size = launcherSize
          ..alignment = Alignment.center
          ..title = 'OBS Manager - v0.18.0'
          ..show();
      });
    }
    return;
  } else {
    runApp(const ProjectApp());
    if (Platform.isWindows) {
      doWhenWindowReady(() {
        final win = appWindow;
        const Size minSize = Size(800, 600);
        const Size launcherSize = Size(1200, 800);

        win
          ..minSize = minSize
          ..size = launcherSize
          ..alignment = Alignment.center
          ..title = 'OBS Manager - v0.18.0'
          ..show();
      });
    }
    return;
  }
}
